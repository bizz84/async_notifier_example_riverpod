import 'package:async_notifier_example_riverpod/notifiers/auth_controller.dart';
import 'package:async_notifier_example_riverpod/repositories/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T? next);
}

void main() {
  ProviderContainer makeProviderContainer(MockAuthRepository authRepository) {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('AuthController', () {
    test('initial state is AsyncData', () {
      final authRepository = MockAuthRepository();
      final container = makeProviderContainer(authRepository);
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        authControllerProvider,
        listener,
        fireImmediately: true,
      );
      // verify
      verifyInOrder([
        // the build method returns a value immediately, so we expect AsyncData
        () => listener(null, const AsyncData<void>(null)),
      ]);
      verifyNoMoreInteractions(listener);
      verifyNever(authRepository.signOut);
    });

    test('signOut success', () async {
      // setup
      final authRepository = MockAuthRepository();
      final container = makeProviderContainer(authRepository);
      final controller = container.read(authControllerProvider.notifier);
      when(authRepository.signOut).thenAnswer((_) => Future.value());
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        authControllerProvider,
        listener,
        fireImmediately: true,
      );
      // run
      await controller.signOut();
      // verify
      verifyInOrder([
        // initial value from build method
        () => listener(null, const AsyncData<void>(null)),
        // set loading state
        () => listener(const AsyncData<void>(null), const AsyncLoading<void>()),
        // data when complete
        () => listener(const AsyncLoading<void>(), const AsyncData<void>(null)),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authRepository.signOut).called(1);
    });

    test('signOut failure', () async {
      // setup
      final authRepository = MockAuthRepository();
      final container = makeProviderContainer(authRepository);
      final controller = container.read(authControllerProvider.notifier);
      final exception = Exception('Connection failed');
      when(authRepository.signOut).thenThrow(exception);
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        authControllerProvider,
        listener,
        fireImmediately: true,
      );
      // run
      await controller.signOut();
      // verify
      verifyInOrder([
        // initial value from build method
        () => listener(null, const AsyncData<void>(null)),
        // set loading state
        () => listener(const AsyncData<void>(null), const AsyncLoading<void>()),
        // error when complete
        () => listener(
              const AsyncLoading<void>(),
              any(that: predicate<AsyncValue<void>>((value) {
                expect(value.hasError, true);
                return true;
              })),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authRepository.signOut).called(1);
    });
  });
}
