import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:tabi_memo/database/database_helper.dart';
import 'package:tabi_memo/models/memo.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({super.key, required this.memo});
  final Memo memo;

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  DateTime? _selectedDate;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.memo.title ?? '';
    _bodyController.text = widget.memo.body ?? '';
    _selectedDate = widget.memo.date;
    _imagePath = widget.memo.imagePath;
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedImage.path);
      final savedImage =
          await File(pickedImage.path).copy('${directory.path}/$fileName');

      setState(() {
        _imagePath = savedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('メモを追加／編集')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'タイトル',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: '本文',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.calendar_month, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? '日付が選択されていません'
                        : DateFormat.yMMMd().format(_selectedDate!),
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text('日付選択'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imagePath == null
                    ? Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(Icons.image, color: Colors.grey),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_imagePath!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('画像アップロード'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_titleController.text.isEmpty ||
                      _bodyController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('すべての項目を入力してください'),
                      ),
                    );
                    return;
                  }
                  if (_selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('日付を選択してください'),
                      ),
                    );
                    return;
                  }
                  if (_imagePath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('画像を選択してください'),
                      ),
                    );
                    return;
                  }
                  if (widget.memo.id != null) {
                    Memo memo = Memo(
                      widget.memo.id,
                      _titleController.text,
                      _bodyController.text,
                      _selectedDate,
                      _imagePath,
                    );

                    DatabaseHelper.update({
                      'id': memo.id,
                      'title': memo.title,
                      'body': memo.body,
                      'date': memo.date?.toIso8601String(),
                      'imagePath': memo.imagePath,
                    });
                    if (context.mounted) {
                      Navigator.pop(context, memo);
                    }
                  } else {
                    DatabaseHelper.insert({
                      'title': _titleController.text,
                      'body': _bodyController.text,
                      'date': _selectedDate?.toIso8601String(),
                      'imagePath': _imagePath,
                    });
                    Navigator.pop(context, true);
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('保存する'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
