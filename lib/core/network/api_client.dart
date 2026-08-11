import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';

class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.apiTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Auth-Token': AppConstants.apiKey,
        },
      ),
    );

    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => _logger.i(object.toString()),
      ),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          // final token = await _getToken();
          // if (token != null) options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onError: (error, handler) {
          _logger.e('API Error: \${error.message}', error: error.error, stackTrace: error.stackTrace);
          return handler.next(error);
        },
      ),
    ]);
  }

  Dio get dio => _dio;

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return _dio.delete(path);
  }
}