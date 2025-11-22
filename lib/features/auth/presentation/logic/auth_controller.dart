import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_auth_sample/features/auth/data/models/user.dart';
import 'package:test_auth_sample/features/auth/data/repositories/auth_repository.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<User?> build() async {
    final repository = await ref.watch(authRepositoryProvider.future);
    return repository.checkAuth();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(authRepositoryProvider.future);
      return await repository.login(email, password);
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(authRepositoryProvider.future);
      await repository.logout();
      return null;
    });
  }
}
