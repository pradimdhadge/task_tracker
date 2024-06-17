import 'dart:convert';
import 'package:dio/dio.dart';
import '../resources/session_storage.dart';

class NetworkInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers
        .addAll({"Authorization": "Bearer ${SessionStorage().accessToken}"});
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data != null && response.data != "") {
      response.data = jsonDecode(response.data);
    } else {
      response.data = {};
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.data != null && err.response?.data != "") {
      err.response?.data = jsonDecode(err.response?.data);
    } else {
      err.response?.data = {};
    }
    super.onError(err, handler);
  }
}
