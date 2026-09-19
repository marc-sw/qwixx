import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qwixx/config/dependencies.dart';
import 'package:qwixx/config/routing.dart';
import 'package:uuid/uuid.dart';

final random = Random();
final uuid = Uuid();

void main() {
  runApp(MultiProvider(providers: providers, child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
    );
  }
}

/*

  TODO: Wrap data methods in data layer with https://pub.dev/packages/result_dart
        for better error handling
        Wrap view model methods with https://pub.dev/packages/command_it
        for better state handling

*/
