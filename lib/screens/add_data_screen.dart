import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
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
      context: this.context,
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
      setState(() {
        _imagePath = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 16),
            TextField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
                maxLines: 5),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'No Date Chosen!'
                      : DateFormat.yMMMd().format(_selectedDate!),
                ),
                const Spacer(),
                ElevatedButton(
                    onPressed: _pickDate, child: const Text('Choose Date')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _imagePath == null
                    ? const Text('No Image Selected!')
                    : Image.file(File(_imagePath!),
                        width: 100, height: 100, fit: BoxFit.cover),
                const Spacer(),
                ElevatedButton(
                    onPressed: _pickImage, child: const Text('Upload Image')),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty ||
                    _bodyController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                    ),
                  );
                  return;
                }
                if (_selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a date'),
                    ),
                  );
                  return;
                }
                if (_imagePath == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an image'),
                    ),
                  );
                  return;
                }
                if (widget.memo.id != null) {
                  DatabaseHelper.update({
                    'id': widget.memo.id,
                    'title': _titleController.text,
                    'body': _bodyController.text,
                    'date': _selectedDate?.toIso8601String(),
                    'imagePath': _imagePath,
                  });
                } else {
                  DatabaseHelper.insert({
                    'title': _titleController.text,
                    'body': _bodyController.text,
                    'date': _selectedDate?.toIso8601String(),
                    'imagePath': _imagePath,
                  });
                }
              },
              child: const Center(child: Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
