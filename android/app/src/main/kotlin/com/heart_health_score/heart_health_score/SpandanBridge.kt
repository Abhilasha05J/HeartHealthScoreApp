package com.heart_health_score.heart_health_score

import android.app.Application
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

import `in`.sunfox.healthcare.commons.android.spandan_sdk.SpandanSDK
import `in`.sunfox.healthcare.commons.android.spandan_sdk.OnInitializationCompleteListener
import `in`.sunfox.healthcare.commons.android.spandan_sdk.connection.DeviceInfo
import `in`.sunfox.healthcare.commons.android.spandan_sdk.connection.OnDeviceConnectionStateChangeListener
import `in`.sunfox.healthcare.commons.android.spandan_sdk.connection.SpandanSDKException
import `in`.sunfox.healthcare.commons.android.spandan_sdk.enums.EcgTestType
import `in`.sunfox.healthcare.commons.android.spandan_sdk.listener.PDFReportGenerationCallback
import `in`.sunfox.healthcare.commons.android.spandan_sdk.retrofit_helper.PatientData
import `in`.sunfox.healthcare.commons.android.spandan_sdk.retrofit_helper.ReportGenerationResult
import `in`.sunfox.healthcare.commons.android.spandan_sdk_ui.helper.SpandanSDKUI

/**
 * App-scoped bridge between Flutter and the Spandan SDK.
 *
 * Lives in an `object` (not the Activity) on purpose: the SDK is initialised in
 * [MainApplication], and the SDK's own UI runs in a separate Activity, so the report
 * callback can fire while MainActivity / the Flutter engine is paused or even recreated.
 * Report events that arrive while Dart isn't listening are buffered and flushed on the
 * next listen.
 *
 * Channel contract (mirrored in lib/features/ecg/data/spandan_ecg_repository.dart):
 *   MethodChannel  getStatus  -> status map
 *                  startTest  {testType, patient{...}} -> null | PlatformException
 *   EventChannel   {type:'status', ...status map}
 *                  {type:'report', ...}
 *                  {type:'reportFailed', message}
 */
object SpandanBridge {
    private const val METHOD_CHANNEL = "com.heart_health_score/spandan_ecg"
    private const val EVENT_CHANNEL = "com.heart_health_score/spandan_ecg/events"

    private val main = Handler(Looper.getMainLooper())
    private var application: Application? = null
    private var sink: EventChannel.EventSink? = null
    private val undeliveredReports = mutableListOf<Map<String, Any?>>()

    // All mutated on the main thread only.
    private var sdkState = "initializing" // initializing | ready | failed
    private var sdkMessage: String? = null
    private var connection = "disconnected" // disconnected | attached | connected | usbPermissionDenied | timedOut
    private var variant: String? = null
    private var deviceId: String? = null
    private var firmwareVersion: String? = null

    // ---- Called from MainApplication.onCreate() ------------------------------------

    fun initialize(app: Application, verifierToken: String, masterKey: String) {
        application = app

        if (verifierToken.isBlank() || masterKey.isBlank()) {
            sdkState = "failed"
            sdkMessage = "Spandan keys missing. Set SPANDAN_VERIFIER_TOKEN / SPANDAN_MASTER_KEY in ~/.gradle/gradle.properties"
            return
        }

        // Online init. For offline use initializeOffline(app, offlineAuthenticationToken).
        SpandanSDK.initialize(app, verifierToken, masterKey, object : OnInitializationCompleteListener {
            override fun onInitializationSuccess() = update { sdkState = "ready"; sdkMessage = null }
            override fun onInitializationFailed(message: String) = update { sdkState = "failed"; sdkMessage = message }
        })

        SpandanSDK.getInstance().setOnDeviceConnectionStateChangedListener(
            object : OnDeviceConnectionStateChangeListener {
                override fun onDeviceAttached() = update { connection = "attached" }
                override fun onDeviceConnected(deviceInfo: DeviceInfo) = update {
                    connection = "connected"
                    variant = deviceInfo.deviceVariant.name
                    deviceId = deviceInfo.deviceId
                    firmwareVersion = deviceInfo.firmwareVersion
                }
                override fun onDeviceDisconnected() = update {
                    connection = "disconnected"
                    variant = null
                    deviceId = null
                    firmwareVersion = null
                }
                override fun onUsbPermissionDenied() = update { connection = "usbPermissionDenied" }
                override fun onConnectionTimedOut() = update { connection = "timedOut" }
            }
        )
    }

    // ---- Called from MainActivity.configureFlutterEngine() -------------------------

    fun attach(messenger: BinaryMessenger) {
        MethodChannel(messenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getStatus" -> result.success(status())
                "startTest" -> startTest(call, result)
                else -> result.notImplemented()
            }
        }

        EventChannel(messenger, EVENT_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                sink = events
                undeliveredReports.forEach { events.success(it) }
                undeliveredReports.clear()
            }

            override fun onCancel(arguments: Any?) {
                sink = null
            }
        })
    }

    // ---- Start test ----------------------------------------------------------------

    private fun startTest(call: MethodCall, result: MethodChannel.Result) {
        val app = application
            ?: return result.error("SDK_NOT_INITIALISED", "Application not ready", null)

        val args = call.arguments as? Map<*, *>
            ?: return result.error("INVALID_ARGUMENT", "Missing arguments", null)

        val testType = when (args["testType"] as? String) {
            "TWELVE_LEAD" -> EcgTestType.TWELVE_LEAD
            "LEAD_TWO" -> EcgTestType.LEAD_TWO
            else -> return result.error("INVALID_ARGUMENT", "Unknown testType", null)
        }

        val p = args["patient"] as? Map<*, *>
            ?: return result.error("INVALID_ARGUMENT", "Missing patient", null)

        val patient = PatientData(
            age = p.str("age"),
            firstName = p.str("firstName"),
            height = p.str("height"),
            gender = p.str("gender"),
            lastName = p.str("lastName"),
            weight = p.str("weight"),
            patientId = p.str("patientId"),
        )

        try {
            // ASSUMPTION: per the latest doc the first param is the Application (older doc
            // versions called it `activity`). If it won't compile, pass the current Activity.
            SpandanSDKUI.createTestAndStartWithUI(
                app,
                SpandanSDK.getInstance(),
                testType,
                patient,
                pdfReportGenerationCallback = object : PDFReportGenerationCallback {
                    override fun onReportGenerationSuccess(reportGenerationResult: ReportGenerationResult) {
                        emitReport(reportEvent(reportGenerationResult))
                    }

                    override fun onReportGenerationFailed(errorMsg: String) {
                        emitReport(mapOf("type" to "reportFailed", "message" to errorMsg))
                    }
                }
            )
            // The SDK UI is now on screen and owns the flow. Cancelling mid-test (back button)
            // is handled inside the SDK and produces NO callback, so Dart must not block
            // waiting for a result: it listens to the event stream instead.
            result.success(null)
        } catch (e: SpandanSDKException) {
            result.error(codeFor(e.message), e.message, null)
        } catch (e: Exception) {
            result.error("UNKNOWN", e.message, null)
        }
    }

    private fun reportEvent(r: ReportGenerationResult): Map<String, Any?> {
        val c = r.characteristics
        val con = r.conclusions
        val meta = r.reportMetaData?.metaData
        // ASSUMPTION: ecgLeadData (raw waveforms, 12 leads) is intentionally NOT forwarded yet:
        // it's large and the PDF + characteristics cover the dashboard. Add it when needed.
        return mapOf(
            "type" to "report",
            "reportId" to r.reportMetaData?.reportId,
            "pdfReportUrl" to r.pdfReportUrl,
            "characteristics" to mapOf(
                "pr" to c.pr, "qrs" to c.qrs, "qt" to c.qt,
                "qtc" to c.qtc, "rr" to c.rr, "heartRate" to c.heartRate,
            ),
            "conclusions" to mapOf(
                "anomalies" to con.anomalies,
                "detection" to con.detection,
                "ecgType" to con.ecgType,
                "recommendation" to con.recommendation,
                "risk" to con.risk,
            ),
            "deviceVariant" to meta?.deviceVariant,
            "deviceId" to meta?.deviceId,
            "firmwareVersion" to meta?.firmwareVersion,
        )
    }

    // ---- Helpers -------------------------------------------------------------------

    private fun update(block: () -> Unit) {
        main.post {
            block()
            sink?.success(status() + ("type" to "status"))
        }
    }

    private fun emitReport(event: Map<String, Any?>) {
        main.post {
            val s = sink
            if (s != null) s.success(event) else undeliveredReports.add(event)
        }
    }

    private fun status(): Map<String, String?> = mapOf(
        "sdkState" to sdkState,
        "sdkMessage" to sdkMessage,
        "connection" to connection,
        "deviceVariant" to variant,
        "deviceId" to deviceId,
        "firmwareVersion" to firmwareVersion,
    )

    private fun Map<*, *>.str(key: String): String = (this[key] as? String).orEmpty()

    private fun codeFor(message: String?): String = when {
        message == null -> "UNKNOWN"
        message.contains("SDKNotInitialised", ignoreCase = true) -> "SDK_NOT_INITIALISED"
        message.contains("InvalidTest", ignoreCase = true) -> "INVALID_TEST"
        message.contains("DeviceNotConnected", ignoreCase = true) -> "DEVICE_NOT_CONNECTED"
        else -> "UNKNOWN"
    }
}