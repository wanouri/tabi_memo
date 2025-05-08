import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tabi_memo/models/memo.dart';
import 'package:tabi_memo/screens/add_data_screen.dart';
import 'package:tabi_memo/widgets/category_label.dart';

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
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final text = '${_memo.title ?? '旅メモ'}\n${_memo.body ?? ''}';

              try {
                if (_memo.imagePath != null && _memo.imagePath!.isNotEmpty) {
                  await Share.shareXFiles(
                    [XFile(_memo.imagePath!)],
                    text: text,
                  );
                } else {
                  await Share.share(text);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('共有に失敗しました')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // タイトル
                Text(
                  _memo.title ?? '',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0288D1),
                      ),
                ),
                const SizedBox(height: 8),
                // カテゴリラベル
                if (_memo.category != null)
                  CategoryLabel(category: _memo.category!),
                const SizedBox(height: 12),
                // 日付
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
                const SizedBox(height: 24),
                // 本文
                Text(
                  _memo.body ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                      ),
                ),
                const SizedBox(height: 24),
                // 画像
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
