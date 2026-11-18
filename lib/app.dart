import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:flutter/material.dart';

import 'screens/firebase_setup_screen.dart';
import 'screens/home_screen.dart';
import 'services/firebase_service.dart';

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key, this.initializationError, this.userId});

  final FirebaseException? initializationError;
  final String? userId;

  static const Color teal = Color(0xFF009688);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase CRUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(seedColor: teal, primary: teal),
        scaffoldBackgroundColor: const Color(0xFF9E9E9E),
        appBarTheme: const AppBarTheme(
          backgroundColor: teal,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: teal,
          foregroundColor: Colors.white,
        ),
      ),
      home: initializationError == null
          ? userId == null
                ? FirebaseSetupScreen(
                    error: FirebaseException(
                      plugin: 'auth',
                      code: 'missing-user',
                      message: 'Anonymous sign-in did not return a user.',
                    ),
                  )
                : HomeScreen(service: FirebaseService(userId: userId!))
          : FirebaseSetupScreen(error: initializationError!),
    );
  }
}
