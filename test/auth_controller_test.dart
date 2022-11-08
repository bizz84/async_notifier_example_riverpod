import 'package:async_notifier_example_riverpod/notifiers/auth_controller.dart';
import 'package:async_notifier_example_riverpod/repositories/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
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

  setUpAll(() {
    registerFallbackValue(const AsyncLoading<void>());
  });

  group('initialization', () {
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
      verify(
        // the build method returns a value immediately, so we expect AsyncData
        () => listener(null, const AsyncData<void>(null)),
      );
      verifyNoMoreInteractions(listener);
      verifyNever(authRepository.signOut);
      verifyNever(authRepository.signInAnonymously);
    });
  });

  group('signIn', () {
    test('success', () async {
      // setup
      final authRepository = MockAuthRepository();
      when(authRepository.signInAnonymously).thenAnswer((_) => Future.value());
      final container = makeProviderContainer(authRepository);
      final controller = container.read(authControllerProvider.notifier);
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        authControllerProvider,
        listener,
        fireImmediately: true,
      );
      const data = AsyncData<void>(null);
      // verify initial value from build method
      verify(() => listener(null, data));
      // run
      await controller.signInAnonymously();
      // verify
      verifyInOrder([
        // set loading state
        // * use a matcher since AsyncLoading != AsyncLoading with data
        () => listener(data, any(that: isA<AsyncLoading>())),
        // data when complete
        () => listener(any(that: isA<AsyncLoading>()), data),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authRepository.signInAnonymously).called(1);
    });

    test('failure', () async {
      // setup
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection failed');
      when(authRepository.signInAnonymously).thenThrow(exception);
      final container = makeProviderContainer(authRepository);
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        authControllerProvider,
        listener,
        fireImmediately: true,
      );
      const data = AsyncData<void>(null);
      // verify initial value from build method
      verify(() => listener(null, data));
      // run
      final controller = container.read(authControllerProvider.notifier);
      await controller.signInAnonymously();
      // verify
      verifyInOrder([
        // set loading state
        // * use a matcher since AsyncLoading != AsyncLoading with data
        () => listener(data, any(that: isA<AsyncLoading>())),
        // error when complete
        () => listener(
            any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authRepository.signInAnonymously).called(1);
    });
  });

  group('signOut', () {
    test('success', () async {
      // setup
      final authRepository = MockAuthRepository();
      when(authRepository.signOut).thenAnswer((_) => Future.value());
      final container = makeProviderContainer(authRepository);
      final controller = container.read(authControllerProvider.notifier);
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        authControllerProvider,
        listener,
        fireImmediately: true,
      );
      const data = AsyncData<void>(null);
      // verify initial value from build method
      verify(() => listener(null, data));
      // run
      await controller.signOut();
      // verify
      verifyInOrder([
        // set loading state
        // * use a matcher since AsyncLoading != AsyncLoading with data
        () => listener(data, any(that: isA<AsyncLoading>())),
        // data when complete
        () => listener(any(that: isA<AsyncLoading>()), data),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authRepository.signOut).called(1);
    });

    test('failure', () async {
      // setup
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection failed');
      when(authRepository.signOut).thenThrow(exception);
      final container = makeProviderContainer(authRepository);
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        authControllerProvider,
        listener,
        fireImmediately: true,
      );
      const data = AsyncData<void>(null);
      // verify initial value from build method
      verify(() => listener(null, data));
      // run
      final controller = container.read(authControllerProvider.notifier);
      await controller.signOut();
      // verify
      verifyInOrder([
        // set loading state
        // * use a matcher since AsyncLoading != AsyncLoading with data
        () => listener(data, any(that: isA<AsyncLoading>())),
        // error when complete
        () => listener(
            any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
      ]);
      verifyNoMoreInteractions(listener);
      verify(authRepository.signOut).called(1);
    });
  });
}
