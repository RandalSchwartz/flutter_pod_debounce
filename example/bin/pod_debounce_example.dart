import 'dart:async';
import 'dart:developer';

import 'package:pod_debounce/pod_debounce.dart';
import 'package:riverpod/riverpod.dart';

final ticker = Stopwatch()..start();

void stamp(String message) {
  final elapsed = ticker.elapsedMilliseconds / 1000;
  log('${elapsed.toStringAsFixed(3)}: $message');
}

final container = ProviderContainer();

void main(List<String> arguments) async {
  stamp('start');
  container.listen(
    debouncePod(#foo),
    ((previous, next) => stamp('$previous -> $next')),
    fireImmediately: true,
  );
  final onTap0 = container.read(debouncePod(#foo))?.run0((n) {
    n.pauseForMs(2000);
    stamp('onTap0 run0 holding $n');
  });
  stamp('onTap0: $onTap0');
  onTap0?.call();

  await Future.delayed(const Duration(seconds: 3), () => stamp('3s'));

  final onTap1 = container.read(debouncePod(#foo))?.run1<String>((n, s) {
    n.pauseForMs(2000);
    stamp('onTap1 run1 holding $n with $s');
  });

  onTap1?.call('hello');

  await Future.delayed(const Duration(seconds: 1), () => stamp('1s'));
  stamp('end');
}
