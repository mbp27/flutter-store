import 'dart:async';

import 'package:pitjarusstore/data/providers/auth_provider.dart';

enum AuthStatus { unknown, error, authenticated, unauthenticated }

class AuthRepository {
  final _controller = StreamController<AuthStatus>();
  final _authProvider = AuthProvider();

  Stream<AuthStatus> get status async* {
    await Future.delayed(const Duration(seconds: 2));
    bool isLoggedIn = await _authProvider.isLoggedIn();
    if (isLoggedIn) {
      yield AuthStatus.authenticated;
    } else {
      yield AuthStatus.unauthenticated;
    }
    yield* _controller.stream;
  }

  void dispose() => _controller.close();

  /// Login with username
  Future<void> loginTest({
    required String username,
    required String password,
  }) async {
    try {
      await _authProvider.loginTest(username: username, password: password);
      _controller.add(AuthStatus.authenticated);
    } catch (e) {
      rethrow;
    }
  }

  /// For logout current user
  Future<void> logout() async {
    try {
      await _authProvider.logout();
      _controller.add(AuthStatus.unauthenticated);
    } catch (e) {
      rethrow;
    }
  }

  /// For check if user is logged in or not
  Future<bool> isLoggedIn() => _authProvider.isLoggedIn();
}
