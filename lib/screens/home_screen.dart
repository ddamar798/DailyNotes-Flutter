// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../utils/note_storage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final NoteStorage _noteStorage = NoteStorage();
  List<Map<String, String>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _noteStorage.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _addNote() async {
    if (_titleController.text.isEmpty) return;

    await _noteStorage.saveNote(_titleController.text, _contentController.text);
    _titleController.clear();
    _contentController.clear();
    await _loadNotes();
  }

  Future<void> _deleteNote(int index) async {
    await _noteStorage.deleteNote(index);
    await _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Catatan Harian"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Judul Catatan"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: "Isi Catatan"),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addNote,
              icon: Icon(Icons.add),
              label: Text("Tambah Catatan"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _notes.isEmpty
                  ? Center(child: Text("Belum ada catatan. Ayo buat yang pertama!"))
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        final note = _notes[index];
                        final date = DateTime.parse(note['date']!);
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(note['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(note['content']!, maxLines: 2, overflow: TextOverflow.ellipsis),
                                SizedBox(height: 4),
                                Text(
                                  "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteNote(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}