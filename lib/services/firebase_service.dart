import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/inventory_item.dart';

class FirebaseService {
  FirebaseService({required this.userId, FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final String userId;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _items =>
      _firestore.collection('users').doc(userId).collection('items');

  Stream<List<InventoryItem>> watchItems() {
    return _items
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(InventoryItem.fromDocument)
              .toList(growable: false),
        );
  }

  Future<void> addItem({required String name, required num quantity}) async {
    await _items.add({
      'name': name,
      'quantity': quantity,
      'isFavorite': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateItem({
    required String id,
    required String name,
    required num quantity,
  }) async {
    await _items.doc(id).update({'name': name, 'quantity': quantity});
  }

  Future<void> setFavorite({
    required String id,
    required bool isFavorite,
  }) async {
    await _items.doc(id).update({'isFavorite': isFavorite});
  }

  Future<void> deleteItem(String id) async {
    await _items.doc(id).delete();
  }
}
