import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabi_memo/models/memo.dart';
import 'package:tabi_memo/screens/add_data_screen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.memo});
  final Memo memo;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Memo _memo;

  @override
  void initState() {
    super.initState();
    _memo = Memo(
      widget.memo.id,
      widget.memo.title,
      widget.memo.body,
      widget.memo.date,
      widget.memo.imagePath,
      widget.memo.category,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateText =
        _memo.date != null ? DateFormat('yyyy/MM/dd').format(_memo.date!) : '';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("旅のひとことメモ"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updateMemo = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDataScreen(memo: widget.memo),
                ),
              );
              if (updateMemo != null) {
                setState(() {
                  _memo = updateMemo;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.place, color: Colors.teal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _memo.title ?? '',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[800],
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // ↓↓↓ このカテゴリ表示を追加 ↓↓↓
                if (_memo.category != null)
                  Row(
                    children: [
                      Icon(
                        getCategoryIcon(_memo.category),
                        color: getCategoryColor(_memo.category),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _memo.category!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: getCategoryColor(_memo.category),
                        ),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      dateText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  _memo.body ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                      ),
                ),
                const SizedBox(height: 24),
                if (_memo.imagePath != null && _memo.imagePath!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_memo.imagePath!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          color: Colors.grey[200],
                          child: const Center(
                            child: Text('画像を読み込めませんでした'),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
