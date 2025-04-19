import 'package:app_02/notesApp/view/note_form_screen.dart';
import 'package:app_02/notesApp/view/note_detail_screen.dart'; // Import màn hình chi tiết
import '../db/note_database_helper.dart';
import 'package:app_02/notesApp/model/note.dart';
import 'package:app_02/notesApp/view/note_item.dart';
import 'package:flutter/material.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> _notes = [];
  bool isLoading = true;

  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchNotes();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchNotes() async {
    setState(() => isLoading = true);
    _notes = await NoteDatabaseHelper.instance.getAllNotes();
    setState(() => isLoading = false);
  }

  void _addNewNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteFormScreen()),
    );
    fetchNotes();
  }

  void _editNote(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteFormScreen(note: note)),
    );
    fetchNotes();
  }

  void _deleteNote(int id) async {
    await NoteDatabaseHelper.instance.deleteNote(id);
    fetchNotes();
  }

  void _viewNoteDetail(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailScreen(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách ghi chú theo từ khóa tìm kiếm
    final filteredNotes = _notes.where((note) {
      final titleLower = note.title.toLowerCase();
      final contentLower = note.content.toLowerCase();
      final searchLower = _searchQuery.toLowerCase();
      return titleLower.contains(searchLower) || contentLower.contains(searchLower);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách Ghi chú'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchNotes,
            color: Colors.white,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm ghi chú...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? Center(
              child: Text(
                'Không tìm thấy ghi chú phù hợp',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                return GestureDetector(
                  onTap: () => _viewNoteDetail(note),
                  child: NoteItem(
                    note: note,
                    onEdit: () => _editNote(note),
                    onDelete: () => _deleteNote(note.id!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNote,
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
