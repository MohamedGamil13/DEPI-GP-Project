class AuthException implements Exception {
  final String message;
  final String code;
  const AuthException({required this.code, required this.message});

  @override
  String toString() => message;
}
