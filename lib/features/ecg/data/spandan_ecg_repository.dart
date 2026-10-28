import 'dart:async';

import 'package:flutter/services.dart';
import 'package:heart_health_score/features/ecg/domain/ecg_entities.dart';
import 'package:heart_health_score/features/ecg/domain/ecg_repository.dart';

/// Talks to SpandanBridge.kt. This is the ONLY file that knows about the channels.
class SpandanEcgRepository implements EcgRepository {
  SpandanEcgRepository() {
    _sub = _events.receiveBroadcastStream().listen(_onEvent, onError: (_) {});
  }

  static const _method = MethodChannel('com.heart_health_score/spandan_ecg');
  static const _events = EventChannel('com.heart_health_score/spandan_ecg/events');

  // ignore: unused_field
  late final StreamSubscription<dynamic> _sub;
  final _statusCtrl = StreamController<EcgDeviceStatus>.broadcast();
  final _reportCtrl = StreamController<EcgReportEvent>.broadcast();
  final _undelivered = <EcgReportEvent>[];

  @override
  bool get isSupported => true;

  @override
  Future<EcgDeviceStatus> getStatus() async {
    final raw = await _method.invokeMapMethod<String, dynamic>('getStatus');
    return _parseStatus(raw ?? const {});
  }

  @override
  Stream<EcgDeviceStatus> watchStatus() async* {
    yield await getStatus();
    yield* _statusCtrl.stream;
  }

  @override
  Stream<EcgReportEvent> get reportEvents async* {
    while (_undelivered.isNotEmpty) {
      yield _undelivered.removeAt(0);
    }
    yield* _reportCtrl.stream;
  }

  @override
  Future<void> startTest({
    required EcgTestType type,
    required EcgPatientData patient,
  }) async {
    try {
      await _method.invokeMethod<void>('startTest', {
        'testType': type.wireName,
        'patient': {
          'patientId': patient.patientId,
          'firstName': patient.firstName,
          'lastName': patient.lastName,
          'age': '${patient.age}',
          'gender': patient.gender,
          // ASSUMPTION: Sunfox said the SDK accepts any string incl. a unit suffix.
          'height': '${_fmt(patient.heightCm)} cm',
          'weight': '${_fmt(patient.weightKg)} kg',
        },
      });
    } on PlatformException catch (e) {
      throw EcgException(_failureFor(e.code), e.message);
    }
  }

  // ---- Event routing --------------------------------------------------------------

  void _onEvent(dynamic raw) {
    final map = Map<String, dynamic>.from(raw as Map);
    switch (map['type']) {
      case 'status':
        _statusCtrl.add(_parseStatus(map));
      case 'report':
        _emitReport(EcgReportReady(_parseReport(map)));
      case 'reportFailed':
        _emitReport(
          EcgReportFailed(map['message'] as String? ?? 'Report generation failed'),
        );
    }
  }

  void _emitReport(EcgReportEvent event) {
    if (_reportCtrl.hasListener) {
      _reportCtrl.add(event);
    } else {
      _undelivered.add(event);
    }
  }

  // ---- Parsing (raw channel maps -> domain models) --------------------------------

  EcgDeviceStatus _parseStatus(Map<String, dynamic> m) => EcgDeviceStatus(
    sdkState: switch (m['sdkState']) {
      'ready' => EcgSdkState.ready,
      'failed' => EcgSdkState.failed,
      _ => EcgSdkState.initializing,
    },
    connection: switch (m['connection']) {
      'attached' => EcgConnectionState.attached,
      'connected' => EcgConnectionState.connected,
      'usbPermissionDenied' => EcgConnectionState.usbPermissionDenied,
      'timedOut' => EcgConnectionState.timedOut,
      _ => EcgConnectionState.disconnected,
    },
    sdkMessage: m['sdkMessage'] as String?,
    deviceVariant: m['deviceVariant'] as String?,
    deviceId: m['deviceId'] as String?,
    firmwareVersion: m['firmwareVersion'] as String?,
  );

  EcgReport _parseReport(Map<String, dynamic> m) {
    final c = Map<String, dynamic>.from(m['characteristics'] as Map);
    final k = Map<String, dynamic>.from(m['conclusions'] as Map);
    return EcgReport(
      reportId: m['reportId'] as String?,
      pdfReportUrl: m['pdfReportUrl'] as String?,
      characteristics: EcgCharacteristics(
        pr: (c['pr'] as num).toInt(),
        qrs: (c['qrs'] as num).toInt(),
        qt: (c['qt'] as num).toInt(),
        qtc: (c['qtc'] as num).toDouble(),
        rr: (c['rr'] as num).toInt(),
        heartRate: (c['heartRate'] as num).toInt(),
      ),
      conclusions: EcgConclusions(
        anomalies: k['anomalies'] as String? ?? '',
        detection: k['detection'] as String? ?? '',
        ecgType: k['ecgType'] as String? ?? '',
        recommendation: k['recommendation'] as String? ?? '',
        risk: k['risk'] as String? ?? '',
      ),
      deviceVariant: m['deviceVariant'] as String?,
      deviceId: m['deviceId'] as String?,
      firmwareVersion: m['firmwareVersion'] as String?,
    );
  }

  EcgFailure _failureFor(String code) => switch (code) {
    'SDK_NOT_INITIALISED' => EcgFailure.sdkNotInitialised,
    'INVALID_TEST' => EcgFailure.invalidTest,
    'DEVICE_NOT_CONNECTED' => EcgFailure.deviceNotConnected,
    _ => EcgFailure.unknown,
  };

  String _fmt(double v) => v.toStringAsFixed(v % 1 == 0 ? 0 : 1);
}