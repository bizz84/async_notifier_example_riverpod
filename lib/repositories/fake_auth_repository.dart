import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A fake repository class to be used by the notifiers
class FakeAuthRepository {
  FakeAuthRepository() {
    _authStateController.add(false);
  }

  final _authStateController = StreamController<bool>();
  Stream<bool> authStateChanges() => _authStateController.stream;

  Future<void> signInAnonymously() async {
    await Future.delayed(const Duration(seconds: 2));
    _authStateController.add(true);
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 2));
    _authStateController.add(false);
  }

  void dispose() => _authStateController.close();
}

final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

final authStateChangesProvider = StreamProvider<bool>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
