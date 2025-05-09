
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Database/Note_Database.dart';
import 'note_card.dart';
import 'note_dialog.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await NoteDatabase.instance.getNotes();
    setState(() {
      notes = fetchedNotes;
    });
  }

  final List<Color> noteColors = [
    Colors.white,
    Colors.red.shade100,
    Colors.orange.shade100,
    Colors.yellow.shade100,
    Colors.green.shade100,
  ];

  void showNoteDialog({int? id, String? title, String? content, int colorIndex = 0}) {
    final currentDate = DateFormat('E d MMM').format(DateTime.now());
    showDialog(
      context: context,
      builder: (context) {
        return NoteDialog(
          noteId: id,
          title: title,
          content: content,
          colorIndex: colorIndex,
          noteColors: noteColors,
          onNoteSaved: (newTitle, newDescription, newColorIndex, date) async {
            if (id == null) {
              await NoteDatabase.instance.addNote(newTitle, newDescription, date, newColorIndex);
            } else {
              await NoteDatabase.instance.updateNote(id, newTitle, newDescription, date, newColorIndex);
            }
            fetchNotes();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Notes", style: TextStyle(color: Colors.black, fontSize: 28)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showNoteDialog(),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black87),
      ),
      body: notes.isEmpty
          ? const Center(child: Text("No Notes Found"))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return NoteCard(
              note: note,
              onDelete: () async {
                await NoteDatabase.instance.deleteNote(note['id']);
                fetchNotes();
              },
              onTap: () {
                showNoteDialog(
                  id: note['id'],
                  title: note['title'],
                  content: note['description'],
                  colorIndex: note['color'],
                );
              },
              noteColor: noteColors,
            );
          },
        ),
      ),
    );
  }
}