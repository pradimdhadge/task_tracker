import 'package:dio/dio.dart';

import '../constants/api_paths.dart';
import '../resources/session_storage.dart';
import 'api_client_interface.dart';
import 'network_interceptor.dart';
import 'response_parse_interceptor.dart';

class ApiClient implements ApiClientInterface {
  static final ApiClient _i = ApiClient._();
  bool _isInitialized = false;
  late final Dio _dio;
  Map<String, dynamic> _defaultHeaders = {};
  Future<bool> Function()? onUnAuthorize;

  ApiClient._();
  factory ApiClient() => _i;

  BaseOptions _getBaseOptions(String baseUrl) {
    return BaseOptions(
      baseUrl: baseUrl,
      responseType: ResponseType.plain,
      headers: _defaultHeaders,
    );
  }

  @override
  Future<void> init() async {
    if (_isInitialized) {
      return;
    }
    _defaultHeaders = {'Content-Type': 'application/json'};
    _dio = Dio(_getBaseOptions(ApiPaths.baseUrl));
    _dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      NetworkInterceptor(),
    ]);
    _isInitialized = true;
    // this.onUnAuthorize = onUnAuthorize;
  }

  @override
  Future<ClientResponse> request(
    RequestParam param, {
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    _checkIsInitialized();

    try {
      Response response = await _dio.request(
        param.path,
        options: Options(
          headers: param.customHeader,
          method: getRequestType(param.methodType),
        ),
        data: param.methodType != MethodType.get ? param.payload : null,
        queryParameters:
            param.methodType == MethodType.get ? param.payload : null,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );

      return ClientResponse(
          apiResponse:
              ApiResponse(status: response.statusCode, data: response.data));
    } on DioException catch (e, stack) {
      ApiError apiError = ApiError(
        message: e.message,
        errorResponse: ErrorResponse.fromMap(e.response?.data ?? {}),
        statusCode: e.response?.statusCode,
        error: e.error,
      );

      return ClientResponse(apiError: apiError);
    } catch (error, stack) {
      ApiError apiError = ApiError(
        message: error.toString(),
        errorResponse: null,
      );

      return ClientResponse(apiError: apiError);
    }
  }

  void _checkIsInitialized() {
    if (!_isInitialized) {
      throw "ApiClient is not initialized please call ApiClinet().init()";
    }
  }

//   Future<bool> _onUnAuthorize() async {
//     try {
//       final ClientResponse response = await request(RequestParam(
//         path: ApiPaths().getAccessToken,
//         methodType: MethodType.post,
//         payload: {"refreshToken": SessionStorage().refreshToken},
//       ));

//       if (response.apiResponse != null) {
//         if (response.apiResponse!.status == 200) {
//           SessionStorage().addData(
//               key: "accessToken",
//               value: response.apiResponse!.data["accessToken"]);
//           return true;
//         }
//       }
//     } catch (e) {
//       return false;
//     }
//     return false;
//   }
}
