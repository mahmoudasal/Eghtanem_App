import 'package:dio/dio.dart';

/// Base exception class for all app-related exceptions.
class AppException implements Exception {
  final String message;
  AppException([this.message = "An unknown error occurred"]);

  @override
  String toString() => message;
}

/// Exception for server-related errors.
class ServerException extends AppException {
  final int? statusCode;
  final DioException? dioException;

  ServerException({
    required String message,
    this.statusCode,
    this.dioException,
  }) : super(message);

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write("ServerException: $message");
    if (statusCode != null) {
      buffer.write(", Status Code: $statusCode");
    }
    if (dioException != null) {
      buffer.write(", Dio Error: ${dioException!.message}");
      if (dioException!.response != null) {
        buffer.write(", Response Data: ${dioException!.response!.data}");
      }
    }
    return buffer.toString();
  }
}

/// Exception for unauthorized access.
class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = "Unauthorized access"]);
}

/// Exception for validation errors.
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  ValidationException([this.errors, super.message = "Validation error"]);

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write("ValidationException: $message");
    if (errors != null && errors!.isNotEmpty) {
      final errorMessages = errors!.entries
          .map((entry) => "${entry.key}: ${entry.value}")
          .join(", ");
      buffer.write(" [Details: $errorMessages]");
    }
    return buffer.toString();
  }
}

/// Exception for resource not found errors.
class NotFoundException extends AppException {
  NotFoundException([super.message = "Resource not found"]);
}

/// Exception for network-related errors.
class NetworkException extends AppException {
  NetworkException([super.message = "No internet connection"]);
}

/// Exception for bad request errors.
class BadRequestException extends AppException {
  BadRequestException([super.message = "Bad request"]);
}

/// Exception for forbidden access errors.
class ForbiddenException extends AppException {
  ForbiddenException([super.message = "Forbidden access"]);
}