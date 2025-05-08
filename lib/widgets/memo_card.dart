import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tabi_memo/models/memo.dart';
import 'package:tabi_memo/screens/detail_screen.dart';
import 'package:tabi_memo/widgets/category_label.dart';
import 'package:tabi_memo/database/database_helper.dart';

class MemoCard extends StatelessWidget {
  final Memo memo;
  final VoidCallback onDeleted;
  final VoidCallback onUpdated;

  const MemoCard({
    super.key,
    required this.memo,
    required this.onDeleted,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Dismissible(
        key: Key(memo.id.toString()),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('削除確認'),
            content: const Text('このメモを削除しますか？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('削除'),
              ),
            ],
          ),
        ),
        onDismissed: (direction) async {
          await DatabaseHelper.delete(memo.id!);
          onDeleted();
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${memo.title}を削除しました')),
          );
        },
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: memo.imagePath != null &&
                    memo.imagePath!.isNotEmpty &&
                    File(memo.imagePath!).existsSync()
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(memo.imagePath!),
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.image, size: 40, color: Colors.grey),
            title: Text(
              memo.title ?? '',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  memo.body ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                if (memo.category != null)
                  CategoryLabel(category: memo.category!),
                if (memo.date != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${memo.date!.year}/${memo.date!.month.toString().padLeft(2, '0')}/${memo.date!.day.toString().padLeft(2, '0')}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey),
                    ),
                  ),
              ],
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(memo: memo),
                ),
              );
              if (result == true) {
                onUpdated();
              }
            },
          ),
        ),
      ),
    );
  }
}
