import 'package:dio/dio.dart';
import 'package:test_auth_sample/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle 401 Unauthorized (e.g., logout or refresh token)
      // For this POC, we might just let it propagate or handle it in the UI/Controller
    }
    super.onError(err, handler);
  }
}
