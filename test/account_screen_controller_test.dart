import 'package:async_notifier_example_riverpod/account_screen_controller.dart';
import 'package:async_notifier_example_riverpod/fake_auth_repository.dart';
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

  group('AccountScreenController', () {
    test('initial state is AsyncValue.data', () {
      final authRepository = MockAuthRepository();
      final container = makeProviderContainer(authRepository);
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        accountScreenControllerProvider,
        listener,
        fireImmediately: true,
      );
      // verify
      verifyInOrder([
        () => listener(null, const AsyncLoading<void>()),
      ]);
      // ? Should we not get AsyncData after the build method returns?
      // ? Yet, it appears that we get no more interactions
      verifyNoMoreInteractions(listener);
      verifyNever(authRepository.signOut);
    });

    test('signOut success', () async {
      // setup
      final authRepository = MockAuthRepository();
      final container = makeProviderContainer(authRepository);
      final controller =
          container.read(accountScreenControllerProvider.notifier);
      when(authRepository.signOut).thenAnswer((_) => Future.value());
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        accountScreenControllerProvider,
        listener,
        fireImmediately: true,
      );
      // run
      await controller.signOut();
      // verify
      verifyInOrder([
        () => listener(null, const AsyncLoading<void>()),
        // ? Why do we get two more events here?
        // ? Would have expected just one for the loading -> data transition
        () => listener(const AsyncLoading<void>(), const AsyncData<void>(null)),
        () =>
            listener(const AsyncData<void>(null), const AsyncData<void>(null)),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authRepository.signOut).called(1);
    });
    test('signOut failure', () async {
      // setup
      final authRepository = MockAuthRepository();
      final container = makeProviderContainer(authRepository);
      final controller =
          container.read(accountScreenControllerProvider.notifier);
      final exception = Exception('Connection failed');
      when(authRepository.signOut).thenThrow(exception);
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        accountScreenControllerProvider,
        listener,
        fireImmediately: true,
      );
      // run
      await controller.signOut();
      // verify
      verifyInOrder([
        () => listener(null, const AsyncLoading<void>()),
        // ? Why do we get two more events here?
        // ? Would have expected just one for the loading -> error transition
        () => listener(const AsyncLoading<void>(), const AsyncData<void>(null)),
        () => listener(
              const AsyncData<void>(null),
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
