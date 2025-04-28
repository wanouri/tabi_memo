import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tabi_memo/database/database_helper.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({super.key});

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  DateTime? _selectedDate;
  String? _imagePath;

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
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imagePath = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: 'Body'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'No Date Chosen!'
                      : DateFormat.yMMMd().format(_selectedDate!),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: Text('Choose Date'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _imagePath == null
                    ? Text('No Image Selected!')
                    : Image.file(
                        File(_imagePath!),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                Spacer(),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Upload Image'),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle save logic here
                DatabaseHelper.insert({
                  'title': _titleController.text,
                  'body': _bodyController.text,
                  'date': _selectedDate?.toIso8601String(),
                  'imagePath': _imagePath,
                });
              },
              child: Center(child: Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
