/// Backend API configuration.
///
/// ASSUMPTION (flagged, not confirmed): hardcoded for now rather than wired
/// through `--dart-define` / build flavors. The backend dev's email says
/// this host is temporary (HTTP-only, no domain yet — a subdomain + HTTPS
/// is coming once Dheeraj sir provisions one). When that happens:
///   1. Update [baseUrl] below (or, better, move to --dart-define/flavors
///      per SKILL.md checklist item 6.8, since the URL will change again).
///   2. Remove the cleartext-traffic exceptions in AndroidManifest.xml /
///      Info.plist that were added to allow HTTP against this EC2 host.
abstract class ApiConfig {
  ApiConfig._();

  static const String baseUrl =
      'http://ec2-43-204-143-123.ap-south-1.compute.amazonaws.com/api/v1';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
