import 'package:crud_firebase_app/widgets/item_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('requires an item name and quantity', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ItemFormDialog(onSave: (name, quantity) async {})),
      ),
    );

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter an item name.'), findsOneWidget);
    expect(find.text('Enter a quantity.'), findsOneWidget);
  });

  testWidgets('rejects a non-numeric quantity', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ItemFormDialog(onSave: (name, quantity) async {})),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Keyboard');
    await tester.enterText(find.byType(TextFormField).at(1), 'many');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid numeric quantity.'), findsOneWidget);
  });
}
