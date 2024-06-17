import 'dart:convert';

import 'package:dio/dio.dart';

class ResponseParseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data['code'] != null) {
      if (response.data['code'] == 200) {
        response.data = response.data["data"] ?? {};
        super.onResponse(response, handler);
        return;
      }
    }
    throw DioException.badResponse(
      requestOptions: response.requestOptions,
      response: Response(
        requestOptions: response.requestOptions,
        data: jsonEncode(response.data),
        statusCode: response.data['code'] ?? 500,
        statusMessage: response.data["message"] ?? "",
      ),
      statusCode: response.data['code'] ?? 500,
    );
  }
}
