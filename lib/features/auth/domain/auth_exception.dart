/// Auth-domain failure with a message already safe to show the user.
///
/// Lives in `domain/` (not `data/`) so presentation code can catch it
/// without importing anything Dio-flavored — controllers already do
/// `catch (e) { errorMessage: e.toString() }`, and overriding [toString]
/// here means that continues to show a clean message instead of
/// "DioException [bad response]: ...".
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}