import 'package:flutter/material.dart';

IconData getCategoryIcon(String? category) {
  switch (category) {
    case 'travel':
      return Icons.flight;
    case 'gourmet':
      return Icons.restaurant;
    case 'business':
      return Icons.work;
    default:
      return Icons.label;
  }
}

Color getCategoryColor(String? category) {
  switch (category) {
    case 'travel':
      return Colors.blue;
    case 'gourmet':
      return Colors.red;
    case 'business':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
