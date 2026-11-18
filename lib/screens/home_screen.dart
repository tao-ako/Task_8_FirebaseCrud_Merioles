import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/inventory_item.dart';
import '../services/firebase_service.dart';
import '../widgets/item_card.dart';
import '../widgets/item_form_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.service, super.key});

  final FirebaseService service;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<List<InventoryItem>> _itemsStream;
  bool _favoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _itemsStream = widget.service.watchItems();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showItemForm({InventoryItem? item}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => ItemFormDialog(
        item: item,
        onSave: (name, quantity) async {
          if (item == null) {
            await widget.service.addItem(name: name, quantity: quantity);
          } else {
            await widget.service.updateItem(
              id: item.id,
              name: name,
              quantity: quantity,
            );
          }
        },
      ),
    );

    if (!mounted || saved != true) return;
    _showMessage(item == null ? 'Item added.' : 'Item updated.');
  }

  Future<void> _toggleFavorite(InventoryItem item) async {
    try {
      await widget.service.setFavorite(
        id: item.id,
        isFavorite: !item.isFavorite,
      );
    } on FirebaseException catch (error) {
      if (!mounted) return;
      _showMessage('Could not update favorite: ${error.message ?? error.code}');
    }
  }

  Future<void> _deleteItem(InventoryItem item) async {
    try {
      await widget.service.deleteItem(item.id);
      if (mounted) _showMessage('Item deleted.');
    } on FirebaseException catch (error) {
      if (!mounted) return;
      _showMessage('Could not delete item: ${error.message ?? error.code}');
    }
  }

  Widget _buildStreamError(Object error) {
    final details = error is FirebaseException
        ? error.message ?? error.code
        : error.toString();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Unable to load items from Firestore.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(details, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                setState(() {
                  _itemsStream = widget.service.watchItems();
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({required bool noFavorites}) {
    return Center(
      child: Text(
        noFavorites ? 'No favorite items yet.' : 'No items yet.',
        style: const TextStyle(color: Colors.black54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase CRUD'),
        actions: [
          IconButton(
            tooltip: _favoritesOnly ? 'Show all items' : 'Show favorites',
            onPressed: () {
              setState(() {
                _favoritesOnly = !_favoritesOnly;
              });
            },
            icon: Icon(
              _favoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<InventoryItem>>(
        stream: _itemsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return _buildStreamError(snapshot.error!);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final items = snapshot.data ?? const <InventoryItem>[];
          final visibleItems = _favoritesOnly
              ? items.where((item) => item.isFavorite).toList(growable: false)
              : items;

          if (visibleItems.isEmpty) {
            return _buildEmptyState(noFavorites: _favoritesOnly);
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 3, bottom: 80),
            itemCount: visibleItems.length,
            itemBuilder: (context, index) {
              final item = visibleItems[index];
              return ItemCard(
                item: item,
                onFavoritePressed: () => _toggleFavorite(item),
                onEditPressed: () => _showItemForm(item: item),
                onDeletePressed: () => _deleteItem(item),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add item',
        onPressed: () => _showItemForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
