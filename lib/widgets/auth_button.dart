import 'package:async_notifier_example_riverpod/notifiers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// auth button that can be used for signing in or signing out
class AuthButton extends ConsumerWidget {
  const AuthButton({super.key, required this.text, required this.onPressed});
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (_, state) {
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.asError.toString())),
          );
        }
      },
    );
    final state = ref.watch(authControllerProvider);
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton(
        onPressed: state.isLoading ? null : onPressed,
        child: state.isLoading
            ? const CircularProgressIndicator()
            : Text(text,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white)),
      ),
    );
  }
}
