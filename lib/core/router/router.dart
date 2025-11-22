import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_auth_sample/features/auth/presentation/logic/auth_controller.dart';
import 'package:test_auth_sample/features/auth/presentation/ui/login_page.dart';
import 'package:test_auth_sample/features/home/presentation/home_page.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    ],
    redirect: (context, state) {
      final user = authState.value;
      final isLoggedIn = user != null && user.token.isNotEmpty;
      final isLoggingIn = state.uri.path == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/';
      }

      return null;
    },
  );
}
