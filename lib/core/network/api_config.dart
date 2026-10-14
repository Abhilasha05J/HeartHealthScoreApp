
abstract class ApiConfig {
  ApiConfig._();

  // static const String baseUrl =
  //     'http://65.0.179.22/api/v1';

  static const String baseUrl = String.fromEnvironment('API_BASE_URL');
  static const String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static bool get isProd => env == 'prod';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
