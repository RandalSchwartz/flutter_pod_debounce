import 'dart:async';
import 'dart:developer';

import 'package:riverpod/riverpod.dart';

final _ticker = Stopwatch()..start();

void _stamp(String message) {
  final elapsed = _ticker.elapsedMilliseconds / 1000;
  log('lib: ${elapsed.toStringAsFixed(3)}: $message');
}

/// a callback that takes no arguments
typedef DebounceRun0Callback = void Function(DebounceNotifier);

/// a callback that takes one argument
typedef DebounceRun1Callback<T1> = void Function(DebounceNotifier, T1);

/// a callback that takes two arguments
typedef DebounceRun2Callback<T1, T2> = void Function(DebounceNotifier, T1, T2);

/// a callback that takes three arguments
typedef DebounceRun3Callback<T1, T2, T3> = void Function(
  DebounceNotifier,
  T1,
  T2,
  T3,
);

/// A [Family] provider that can debounce a callback
/// ```dart
/// ElevatedButton(onPressed: ref.watch(debouncePod(#one))?.run0((n) {
///  n.pauseForMs(1000);
///  // perform action
///  log('Button 1 pressed');
/// }), child: const Text('Button 1')),
/// ```
/// The family must be a unique symbol, and the callback must be a function that
/// takes a [DebounceNotifier] as its first argument.
/// The callback can be called with no incoming arguments, one argument,
/// two arguments, or three arguments.
/// Generics are used to specify the argument types.
// TODO(RandalSchwartz): examples of callbacks with arguments
final debouncePod = NotifierProvider.autoDispose
    .family<DebounceNotifier, DebounceNotifier?, Symbol>(DebounceNotifier.new);

/// A [Notifier] that can debounce a callback, providing the guts
/// for the [debouncePod] provider.
class DebounceNotifier
    extends AutoDisposeFamilyNotifier<DebounceNotifier?, Symbol> {
  @override
  DebounceNotifier? build(Symbol arg) {
    _stamp('build with $arg');
    return this; // initial state is run enabled
  }

  /// Proxies a callback of zero arguments
  void Function() run0(DebounceRun0Callback callback) {
    _stamp('run0');
    return () => callback(this);
  }

  /// Proxies a callback of one argument
  void Function(T1) run1<T1>(DebounceRun1Callback<T1> callback) {
    _stamp('run1');
    return (T1 t1) => callback(this, t1);
  }

  /// Proxies a callback of two arguments
  void Function(T1, T2) run2<T1, T2>(DebounceRun2Callback<T1, T2> callback) {
    _stamp('run2');
    return (T1 t1, T2 t2) => callback(this, t1, t2);
  }

  /// Proxies a callback of three arguments
  void Function(T1, T2, T3) run3<T1, T2, T3>(
    DebounceRun3Callback<T1, T2, T3> callback,
  ) {
    _stamp('run3');
    return (T1 t1, T2 t2, T3 t3) => callback(this, t1, t2, t3);
  }

  /// Pauses the debounce for the specified duration
  void pauseFor(Duration duration) {
    _stamp('pauseFor');
    state = null;
    final timer = Timer(duration, () {
      _stamp('pauseFor done');
      state = this;
    });
    ref.onDispose(timer.cancel);
  }

  /// Pauses the debounce for the specified number of milliseconds
  void pauseForMs(int ms) {
    pauseFor(Duration(milliseconds: ms));
  }
}
