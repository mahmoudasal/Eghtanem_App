import 'dart:convert';
import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;

  AppException([this.message = "An unknown error occurred"]);

  @override
  String toString() => message;
}

/// Exception for server errors with status codes and Dio details.
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
    if (statusCode != null) buffer.write(", Status Code: $statusCode");
    if (dioException != null) {
      buffer.write(", Dio Error: ${dioException!.message}");
      if (dioException!.response != null) {
        final data = dioException!.response!.data;
        buffer.write(", Response Data: ${_convertDataToString(data)}");
      }
    }
    return buffer.toString();
  }

  String _convertDataToString(dynamic data) {
    if (data is String) {
      return data;
    } else if (data is Map || data is List) {
      return const JsonEncoder.withIndent('  ').convert(data);
    } else {
      return data.toString();
    }
  }
}

/// Unauthorized access exception.
class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = "Unauthorized access"]);
}

/// Validation error exception.
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

/// Not found exception.
class NotFoundException extends AppException {
  NotFoundException([super.message = "Resource not found"]);
}

/// Network error exception.
class NetworkException extends AppException {
  NetworkException([super.message = "No internet connection"]);
}

/// Bad request exception.
class BadRequestException extends AppException {
  BadRequestException([super.message = "Bad request"]);
}

/// Forbidden access exception.
class ForbiddenException extends AppException {
  ForbiddenException([super.message = "Forbidden access"]);
}
