import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tabi_memo/database/database_helper.dart';
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
              setState(() {
                _memo = updateMemo;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // タイトル
            Text(
              _memo.title ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),

            // 日付
            Text(
              _memo.date!.toIso8601String().substring(0, 10),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // 本文
            Text(
              _memo.body ?? '',
              style: const TextStyle(
                fontSize: 18,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // 画像（あるときだけ）
            if (_memo.imagePath!.isNotEmpty)
              if (File(_memo.imagePath ?? '').existsSync())
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(_memo.imagePath ?? ''),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
