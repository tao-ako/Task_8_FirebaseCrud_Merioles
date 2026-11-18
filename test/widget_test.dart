import 'package:crud_firebase_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows setup guidance when Firebase initialization fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      InventoryApp(
        initializationError: FirebaseException(
          plugin: 'core',
          code: 'no-options',
        ),
      ),
    );

    expect(find.text('Connect a Firebase project'), findsOneWidget);
    expect(find.textContaining('no-options'), findsOneWidget);
  });
}
