import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_auth_sample/core/api/api_client.dart';
import 'package:test_auth_sample/core/storage/token_storage.dart';
import 'package:test_auth_sample/features/auth/data/models/user.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
Future<AuthRepository> authRepository(Ref ref) async {
  return AuthRepository(await ref.watch(tokenStorageProvider.future), await ref.watch(apiClientProvider.future));
}

class AuthRepository {
  final TokenStorage _tokenStorage;
  final Dio _dio;

  AuthRepository(this._tokenStorage, this._dio);

  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {'email': email, 'password': password});

      final token = response.data['token'] as String;
      await _tokenStorage.saveToken(token);

      // Place where you pontentialy can use fromJSON generated method
      return User(
        id: '1', // Mock ID
        email: email,
        name: 'ReqRes User',
        role: 'user',
        token: token,
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Login failed');
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clearToken();
  }

  Future<User?> checkAuth() async {
    final token = _tokenStorage.getToken();
    if (token != null) {
      // Simulate token validation / fetching user profile
      await Future.delayed(const Duration(milliseconds: 500));
      return User(id: '1', email: 'test@example.com', name: 'Test User', role: 'admin', token: token);
    }
    return null;
  }
}
