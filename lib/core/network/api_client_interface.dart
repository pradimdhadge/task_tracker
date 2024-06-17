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
  int? status;
  String? message;
  ErrorResponse({
    this.status,
    this.message,
  });

  factory ErrorResponse.fromMap(Map<dynamic, dynamic> map) {
    return ErrorResponse(status: map['code'], message: map['message']);
  }

  factory ErrorResponse.fromJson(String jsonData) {
    return ErrorResponse.fromMap(jsonDecode(jsonData));
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
