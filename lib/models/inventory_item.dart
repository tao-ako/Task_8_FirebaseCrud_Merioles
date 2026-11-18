import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  const InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.isFavorite,
  });

  final String id;
  final String name;
  final num quantity;
  final bool isFavorite;

  factory InventoryItem.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    final name = data['name'];
    final quantity = data['quantity'];
    final isFavorite = data['isFavorite'];

    if (name is! String || quantity is! num || isFavorite is! bool) {
      throw FormatException(
        'Item ${document.id} has missing or invalid fields.',
      );
    }

    return InventoryItem(
      id: document.id,
      name: name,
      quantity: quantity,
      isFavorite: isFavorite,
    );
  }
}
