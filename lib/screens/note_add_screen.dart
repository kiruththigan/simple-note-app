import 'package:flutter/material.dart';
import 'package:my_simple_note/db_helper/database_handler.dart';
import 'package:my_simple_note/models/Note.dart';
import 'package:my_simple_note/screens/notes_list_screen.dart';

class NoteAddScreen extends StatefulWidget {
  const NoteAddScreen({super.key});

  @override
  State<NoteAddScreen> createState() => _NoteAddScreenState();
}

class _NoteAddScreenState extends State<NoteAddScreen> {
  late DatabaseHandler handler;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    handler = DatabaseHandler();
  }

  void _handleAdd() {
    final map = {
      "title": titleController.text,
      "description": descriptionController.text,
      "isPinned": false
    };

    final Note note = Note.fromJson(map);
    handler.insertData(note);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully created.'),
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   // title: const Text(
      //   //   "Add Notes",
      //   //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //   // ),
      //   // backgroundColor: Colors.teal,
      // ),
      body: Container(
        // color: Colors.lightBlue.withOpacity(0.2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF36D1DC).withOpacity(0.78),
              Color(0xFF5B86E5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding:
            const EdgeInsets.only(top: 40, right: 16, bottom: 16, left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () => {Navigator.pop(context)},
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                )),
            const Text("New Note",
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.black,
                    fontFamily: "rubik")),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  labelText: "Title", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              maxLines: 4,
              controller: descriptionController,
              decoration: const InputDecoration(
                  labelText: "Description", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    _handleAdd();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotesListScreen()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        return Colors.black87;
                      },
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
