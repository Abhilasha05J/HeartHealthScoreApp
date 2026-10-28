/// Domain models for the ECG feature. No plugin / platform-channel types here.
library;

enum EcgTestType {
  twelveLead('TWELVE_LEAD'),
  leadTwo('LEAD_TWO');

  const EcgTestType(this.wireName);

  /// Name of the matching `EcgTestType` constant in the Spandan SDK.
  final String wireName;
}

/// Patient details the Spandan SDK needs before a test can start.
class EcgPatientData {
  const EcgPatientData({
    required this.patientId,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
  });

  /// Our backend stores a single full name, the SDK wants first + last.
  /// ASSUMPTION: first word = first name, the rest = last name. A single-word name
  /// yields an empty last name; confirm the SDK accepts that (else send '-').
  factory EcgPatientData.fromFullName({
    required String patientId,
    required String fullName,
    required int age,
    required String gender,
    required double heightCm,
    required double weightKg,
  }) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return EcgPatientData(
      patientId: patientId,
      firstName: parts.first,
      lastName: parts.length > 1 ? parts.sublist(1).join(' ') : '',
      age: age,
      gender: gender,
      heightCm: heightCm,
      weightKg: weightKg,
    );
  }

  final String patientId;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final double heightCm;
  final double weightKg;
}

enum EcgSdkState { initializing, ready, failed, unsupported }

enum EcgConnectionState {
  disconnected,
  attached,
  connected,
  usbPermissionDenied,
  timedOut,
}

class EcgDeviceStatus {
  const EcgDeviceStatus({
    this.sdkState = EcgSdkState.initializing,
    this.connection = EcgConnectionState.disconnected,
    this.sdkMessage,
    this.deviceVariant,
    this.deviceId,
    this.firmwareVersion,
  });

  final EcgSdkState sdkState;
  final EcgConnectionState connection;
  final String? sdkMessage;
  final String? deviceVariant;
  final String? deviceId;
  final String? firmwareVersion;

  bool get canStartTest =>
      sdkState == EcgSdkState.ready && connection == EcgConnectionState.connected;
}

class EcgCharacteristics {
  const EcgCharacteristics({
    required this.pr,
    required this.qrs,
    required this.qt,
    required this.qtc,
    required this.rr,
    required this.heartRate,
  });

  final int pr;
  final int qrs;
  final int qt;
  final double qtc;
  final int rr;
  final int heartRate;
}

class EcgConclusions {
  const EcgConclusions({
    required this.anomalies,
    required this.detection,
    required this.ecgType,
    required this.recommendation,
    required this.risk,
  });

  final String anomalies;
  final String detection;
  final String ecgType;
  final String recommendation;
  final String risk;
}

class EcgReport {
  const EcgReport({
    required this.characteristics,
    required this.conclusions,
    this.reportId,
    this.pdfReportUrl,
    this.deviceVariant,
    this.deviceId,
    this.firmwareVersion,
  });

  final String? reportId;
  final String? pdfReportUrl;
  final EcgCharacteristics characteristics;
  final EcgConclusions conclusions;
  final String? deviceVariant;
  final String? deviceId;
  final String? firmwareVersion;
}

sealed class EcgReportEvent {
  const EcgReportEvent();
}

class EcgReportReady extends EcgReportEvent {
  const EcgReportReady(this.report);
  final EcgReport report;
}

class EcgReportFailed extends EcgReportEvent {
  const EcgReportFailed(this.message);
  final String message;
}

enum EcgFailure {
  sdkNotInitialised,
  invalidTest,
  deviceNotConnected,
  unsupportedPlatform,
  unknown,
}

class EcgException implements Exception {
  const EcgException(this.failure, [this.detail]);

  final EcgFailure failure;
  final String? detail;

  String get userMessage => switch (failure) {
    EcgFailure.sdkNotInitialised =>
    'ECG service is not ready yet. Please try again in a moment.',
    EcgFailure.invalidTest => 'This ECG test is not enabled for your account.',
    EcgFailure.deviceNotConnected =>
    'Connect your Spandan device via USB and try again.',
    EcgFailure.unsupportedPlatform =>
    'ECG recording is not supported on this device.',
    EcgFailure.unknown => 'Could not start the ECG test. Please try again.',
  };

  @override
  String toString() => 'EcgException($failure${detail == null ? '' : ': $detail'})';
}