import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_auth_sample/core/api/interceptors/auth_interceptor.dart';
import 'package:test_auth_sample/core/storage/token_storage.dart';

part 'api_client.g.dart';

@Riverpod(keepAlive: true)
Future<Dio> apiClient(Ref ref) async {
  final dio = Dio();

  final tokenStorage = await ref.watch(tokenStorageProvider.future);

  dio.interceptors.add(AuthInterceptor(tokenStorage));
  dio.options.baseUrl = 'https://reqres.in/api'; // ReqRes API
  dio.options.headers['x-api-key'] = 'reqres-free-v1';

  return dio;
}
