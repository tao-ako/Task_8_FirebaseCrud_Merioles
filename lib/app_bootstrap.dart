import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';

Future<void> bootstrapApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseException? initializationError;
  String? userId;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final auth = FirebaseAuth.instance;
    final user =
        auth.currentUser ?? (await auth.signInAnonymously()).user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'missing-user',
        message: 'Anonymous sign-in did not return a user.',
      );
    }
    userId = user.uid;
  } on FirebaseException catch (error) {
    initializationError = error;
  }

  runApp(
    InventoryApp(initializationError: initializationError, userId: userId),
  );
}
