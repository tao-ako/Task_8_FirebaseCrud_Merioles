import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseSetupScreen extends StatelessWidget {
  const FirebaseSetupScreen({required this.error, super.key});

  final FirebaseException error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase CRUD')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connect a Firebase project',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Firebase could not be initialized. Configure this Flutter '
                    'app with your Firebase project, enable Cloud Firestore '
                    'and Anonymous sign-in in Firebase Authentication, then '
                    'run it again.',
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    '${error.code}: ${error.message ?? 'No additional details.'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'See README.md for platform setup instructions. '
                    'No sample data is shown in place of Firestore data.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
