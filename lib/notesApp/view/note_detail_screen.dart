import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_02/notesApp/model/note.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  NoteDetailScreen({required this.note});

  final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

  Color? parseColor(String? colorString) {
    try {
      if (colorString == null) return null;
      return Color(int.parse(colorString));
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết Ghi chú'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tiêu đề: ${note.title}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            SizedBox(height: 15),
            Text('Nội dung:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text(note.content, style: TextStyle(fontSize: 16, color: Colors.black54)),
            SizedBox(height: 15),
            Text('Mức độ ưu tiên: ${note.priority}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 15),
            Text('Thời gian tạo: ${dateFormatter.format(note.createdAt)}'),
            Text('Thời gian sửa đổi: ${dateFormatter.format(note.modifiedAt)}'),
            SizedBox(height: 15),
            Text('Màu sắc:', style: TextStyle(fontSize: 16)),
            Container(
              width: double.infinity,
              height: 10,
              color: parseColor(note.color) ?? Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }
}
