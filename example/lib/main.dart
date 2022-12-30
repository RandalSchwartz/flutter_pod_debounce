// remember to add flutter_hooks and hooks_riverpod to pubspec.yaml
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pod_debounce/pod_debounce.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      // themeMode: ThemeMode.dark,
      // title: 'Call me an app!',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Technology'),
      ),
      body: const SafeArea(child: Body()),
      // floatingActionButton: MyFAB(),
    );
  }
}

class Body extends ConsumerWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        const Expanded(child: Placeholder()),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: ref.watch(debouncePod(#one))?.run0((n) {
                  n.pauseForMs(1000);
                  log('Button 1 pressed');
                }),
                child: const Text('Button 1')),
            ElevatedButton(
                onPressed: ref.watch(debouncePod(#two))?.run0((n) {
                  n.pauseForMs(2000);
                  log('Button 2 pressed');
                }),
                child: const Text('Button 2')),
            ElevatedButton(
                onPressed: ref.watch(debouncePod(#three))?.run0((n) {
                  n.pauseForMs(3000);
                  log('Button 3 pressed');
                }),
                child: const Text('Button 3')),
          ],
        ),
        const Expanded(child: Placeholder()),
      ],
    );
  }
}
