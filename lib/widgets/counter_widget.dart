import 'package:async_notifier_example_riverpod/notifiers/counter_manual.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterWidget extends ConsumerWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    return FloatingActionButton(
      child: Text('$counter'),
      onPressed: () => ref.read(counterProvider.notifier).state++,
    );
  }
}
