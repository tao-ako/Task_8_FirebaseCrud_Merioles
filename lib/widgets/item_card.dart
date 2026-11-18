import 'package:flutter/material.dart';

import '../models/inventory_item.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    required this.item,
    required this.onFavoritePressed,
    required this.onEditPressed,
    required this.onDeletePressed,
    super.key,
  });

  final InventoryItem item;
  final VoidCallback onFavoritePressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF8F5FA),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      child: SizedBox(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.only(left: 9, right: 3),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Quantity: ${item.quantity}',
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
              _ItemActionButton(
                icon: item.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: item.isFavorite ? Colors.red : Colors.grey,
                tooltip: item.isFavorite
                    ? 'Remove from Favorites'
                    : 'Add to Favorites',
                onPressed: onFavoritePressed,
              ),
              _ItemActionButton(
                icon: Icons.edit,
                color: const Color(0xFFFFB300),
                tooltip: 'Edit item',
                onPressed: onEditPressed,
              ),
              _ItemActionButton(
                icon: Icons.delete,
                color: Colors.red,
                tooltip: 'Delete item',
                onPressed: onDeletePressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemActionButton extends StatelessWidget {
  const _ItemActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 31, height: 40),
      iconSize: 17,
      tooltip: tooltip,
      color: color,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
