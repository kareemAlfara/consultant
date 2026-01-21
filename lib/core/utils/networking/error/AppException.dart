/// Base exception class
class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

/// Server exception (API errors)
class ServerException extends AppException {
  const ServerException(super.message);
}

/// Cache exception (Local storage errors)
class CacheException extends AppException {
  const CacheException(super.message);
}

/// Network exception (No internet)
class NetworkException extends AppException {
  const NetworkException(super.message);
}

/// Validation exception
class ValidationException extends AppException {
  const ValidationException(super.message);
}

/// Authentication exception
class AuthException extends AppException {
  const AuthException(super.message);
}