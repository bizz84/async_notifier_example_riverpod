import 'package:async_notifier_example_riverpod/notifiers/auth_controller.dart';
import 'package:async_notifier_example_riverpod/widgets/auth_button.dart';
import 'package:async_notifier_example_riverpod/widgets/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple account screen showing a login button.
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: AuthButton(
          text: 'Sign in',
          onPressed: () =>
              ref.read(authControllerProvider.notifier).signInAnonymously(),
        ),
      ),
      floatingActionButton: const CounterWidget(),
    );
  }
}
