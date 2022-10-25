import 'package:async_notifier_example_riverpod/repositories/fake_auth_repository.dart';
import 'package:async_notifier_example_riverpod/widgets/sign_in_screen.dart';
import 'package:async_notifier_example_riverpod/widgets/sign_out_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateChangesProvider);
    return authStateAsync.when(
      data: (signedIn) {
        if (signedIn) {
          return const SignOutScreen();
        } else {
          return const SignInScreen();
        }
      },
      error: (e, st) => Scaffold(body: Center(child: Text(e.toString()))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
