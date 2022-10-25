import 'package:async_notifier_example_riverpod/notifiers/auth_controller.dart';
import 'package:async_notifier_example_riverpod/widgets/auth_button.dart';
import 'package:async_notifier_example_riverpod/widgets/counter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple account screen showing a logout button.
class SignOutScreen extends ConsumerWidget {
  const SignOutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(
        child: AuthButton(
          text: 'Sign out',
          onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
        ),
      ),
      floatingActionButton: const CounterWidget(),
    );
  }
}
