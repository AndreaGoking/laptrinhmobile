import 'package:flutter/material.dart';
import '../db/note_database_helper.dart';
import '../model/note.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note;
  const NoteFormScreen({this.note});

  @override
  _NoteFormScreenState createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;
  int _priority = 2;
  String _color = '0xFFFFFFFF';
  Color _currentColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.note?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.note?.content ?? '');
    _priority = widget.note?.priority ?? 2;
    _color = widget.note?.color ?? '0xFFFFFFFF';
    _currentColor = Color(int.parse(_color));
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final note = Note(
        id: widget.note?.id,
        title: _titleCtrl.text,
        content: _contentCtrl.text,
        priority: _priority,
        createdAt: widget.note?.createdAt ?? now,
        modifiedAt: now,
        color: _color,
      );

      if (widget.note == null) {
        await NoteDatabaseHelper.instance.insertNote(note);
      } else {
        await NoteDatabaseHelper.instance.updateNote(note);
      }

      Navigator.pop(context);
    }
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn màu ghi chú'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _currentColor,
            onColorChanged: (color) {
              setState(() {
                _currentColor = color;
                _color = '0x${color.value.toRadixString(16).padLeft(8, '0')}';
              });
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Thêm Ghi chú' : 'Sửa Ghi chú'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  labelText: 'Tiêu đề',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Nhập tiêu đề' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _contentCtrl,
                decoration: InputDecoration(
                  labelText: 'Nội dung',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                ),
                maxLines: 5,
                validator: (value) =>
                value == null || value.isEmpty ? 'Nhập nội dung' : null,
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<int>(
                value: _priority,
                decoration: InputDecoration(
                  labelText: 'Mức độ ưu tiên',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Thấp')),
                  DropdownMenuItem(value: 2, child: Text('Trung bình')),
                  DropdownMenuItem(value: 3, child: Text('Cao')),
                ],
                onChanged: (value) => setState(() => _priority = value ?? 2),
              ),
              SizedBox(height: 15),
              Text('Màu ghi chú:', style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickColor,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: _currentColor,
                    border: Border.all(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text('Chạm để chọn màu')),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  'Lưu',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
