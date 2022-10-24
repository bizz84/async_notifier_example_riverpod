import 'package:async_notifier_example_riverpod/account_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple account screen showing some user info and a logout button.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      accountScreenControllerProvider,
      (_, state) {
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.asError.toString())),
          );
        }
      },
    );
    final state = ref.watch(accountScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: state.isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              )
            : const Text('Account'),
      ),
      body: Center(
        child: TextButton(
          onPressed: state.isLoading
              ? null
              : () =>
                  ref.read(accountScreenControllerProvider.notifier).signOut(),
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
