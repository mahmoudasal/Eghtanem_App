class AppException implements Exception {
  final String message;

  AppException([this.message = "An unknown error occurred"]);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  final int? statusCode;

  ServerException(param0, {String message = "Server error", this.statusCode})
      : super(message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String message = "Unauthorized access"])
      : super(message);
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  ValidationException([this.errors, String message = "Validation error"])
      : super(message);

  @override
  String toString() {
    if (errors != null) {
      final errorMessages = errors!.entries
          .map((entry) => "${entry.key}: ${entry.value}")
          .join(", ");
      return "$message: $errorMessages";
    }
    return message;
  }
}

class NotFoundException extends AppException {
  NotFoundException([String message = "Resource not found"]) : super(message);
}

class NetworkException extends AppException {
  NetworkException([String message = "No internet connection"]) : super(message);
}

class BadRequestException extends AppException {
  BadRequestException([String message = "Bad request"]) : super(message);
}

class ForbiddenException extends AppException {
  ForbiddenException([String message = "Forbidden access"]) : super(message);
}
