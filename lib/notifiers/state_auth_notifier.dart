/// StateNotifier example (without codegen)
import 'package:async_notifier_example_riverpod/repositories/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this.ref)
      // set the initial state (synchronously)
      : super(const AsyncData(null));
  final Ref ref;

  Future<void> signInAnonymously() async {
    final authRepository = ref.read(authRepositoryProvider);
    // set the loading state
    state = const AsyncLoading();
    // then update it once the [signInAnonymously] method returns
    state = await AsyncValue.guard(authRepository.signInAnonymously);
  }

  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    // set the loading state
    state = const AsyncLoading();
    // then update it once the [signInAnonymously] method returns
    state = await AsyncValue.guard(authRepository.signOut);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref);
});
