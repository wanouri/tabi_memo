import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tabi_memo/models/memo.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.memo});

  final Memo memo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("tabi memo - Detail Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              memo.title,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              memo.body,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              memo.date.toIso8601String(),
              style: TextStyle(fontSize: 20),
            ),
            if (memo.imagePath.isNotEmpty)
              Image.file(
                File(memo.imagePath),
                width: 100,
                height: 100,
              ),
          ],
        ),
      ),
    );
  }
}
