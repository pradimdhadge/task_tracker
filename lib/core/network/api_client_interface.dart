// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';

abstract class ApiClientInterface {
  Future<void> init();
  Future<ClientResponse> request(
    RequestParam param, {
    void Function(int count, int total)? onSendProgress,
    void Function(int count, int total)? onReceiveProgress,
    CancelToken? cancelToken,
  });
}

class ApiResponse {
  final int? status;
  final dynamic data;
  ApiResponse({
    required this.data,
    this.status,
  });
}

class ApiError implements Exception {
  final String? message;
  final int? statusCode;
  final ErrorResponse? errorResponse;
  final Object? error;
  ApiError({
    required this.errorResponse,
    this.message,
    this.statusCode,
    this.error,
  });
}

class ClientResponse {
  ApiResponse? apiResponse;
  ApiError? apiError;

  ClientResponse({this.apiError, this.apiResponse})
      : assert(
            (apiError == null && apiResponse != null) ||
                (apiError != null || apiResponse == null),
            "You can not fill value in both variable and You can not keep both null");
}

class ErrorResponse {
  int? errorCode;
  String? error;
  String? errorTag;
  int? httpCode;
  ErrorResponse({
    this.errorCode,
    this.error,
    this.errorTag,
    this.httpCode,
  });

  factory ErrorResponse.fromMap(Map<String, dynamic> map) {
    return ErrorResponse(
      errorCode: map['error_code'] != null ? map['error_code'] as int : null,
      error: map['error'] != null ? map['error'] as String : null,
      errorTag: map['error_tag'] != null ? map['error_tag'] as String : null,
      httpCode: map['http_code'] != null ? map['http_code'] as int : null,
    );
  }
}

class RequestParam {
  final String path;
  final MethodType methodType;
  final Map<String, dynamic>? customHeader;
  final dynamic payload;
  RequestParam({
    required this.path,
    required this.methodType,
    this.customHeader,
    this.payload,
  });
}

enum MethodType { get, post, put, patch, delete }

getRequestType(MethodType methodType) {
  switch (methodType) {
    case MethodType.get:
      return "GET";
    case MethodType.post:
      return "POST";
    case MethodType.put:
      return "PUT";
    case MethodType.patch:
      return "PATCH";
    case MethodType.delete:
      return "DELETE";
  }
}
