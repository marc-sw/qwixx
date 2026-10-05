import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    );
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        colorScheme: colorScheme,
        textTheme: GoogleFonts.averageSansTextTheme(
          ThemeData.from(colorScheme: colorScheme).textTheme,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

/*
  Implement audio
  https://pub.dev/packages/flutter_soloud
*/
