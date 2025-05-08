import 'package:flutter/material.dart';
import 'package:tabi_memo/utils/memo_utils.dart';

class CategoryLabel extends StatelessWidget {
  final String category;

  const CategoryLabel({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final color = getCategoryColor(category);
    final icon = getCategoryIcon(category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            category,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
