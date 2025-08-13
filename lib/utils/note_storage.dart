// lib/utils/note_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class NoteStorage {
  static const String _keyNotes = 'daily_notes';

  Future<List<Map<String, String>>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_keyNotes) ?? [];
    return notesJson.map((json) {
      final parts = json.split('||');
      return {
        'title': parts[0],
        'content': parts[1],
        'date': parts[2],
      };
    }).toList();
  }

  Future<void> saveNote(String title, String content) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();
    final now = DateTime.now();
    final newNote = '$title||$content||${now.toString()}';
    notes.add({'title': title, 'content': content, 'date': now.toString()});
    final notesJson = notes.map((note) => '${note['title']}||${note['content']}||${note['date']}').toList();
    await prefs.setStringList(_keyNotes, notesJson);
  }

  Future<void> deleteNote(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();
    notes.removeAt(index);
    final notesJson = notes.map((note) => '${note['title']}||${note['content']}||${note['date']}').toList();
    await prefs.setStringList(_keyNotes, notesJson);
  }
}