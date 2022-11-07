/// Notifier example (without codegen)
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Counter extends AutoDisposeNotifier<int> {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }
}

final counterProvider = NotifierProvider.autoDispose<Counter, int>(Counter.new);
