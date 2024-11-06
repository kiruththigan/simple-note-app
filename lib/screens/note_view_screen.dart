import 'package:flutter/material.dart';
import 'package:my_simple_note/screens/notes_list_screen.dart';
import '../components/build_quick_action_card.dart';
import '../db_helper/database_handler.dart';
import '../models/Note.dart';

class NoteViewScreen extends StatefulWidget {
  final Note note;

  const NoteViewScreen({
    super.key,
    required this.note,
  });

  @override
  State createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  late DatabaseHandler handler;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isPinned = false;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    titleController.text = widget.note.title!;
    descriptionController.text = widget.note.description!;
    isPinned = widget.note.isPinned ?? false;
  }

  void _handleUpdate() {
    final map = {
      "id": widget.note.id,
      "title": titleController.text,
      "description": descriptionController.text,
      "isPinned": isPinned ? 1 : 0,
      "createdAt": widget.note.createdAt?.toIso8601String(),
      "updatedAt": DateTime.now().toIso8601String(),
    };
    final Note note = Note.fromJson(map);
    handler.updateData(note);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully updated.'),
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.teal,
      ),
    );
  }

  Future<void> _showDeleteConfirmation(Note note) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                handler.deleteData(note.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully deleted.'),
                    showCloseIcon: true,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.teal,
                  ),
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotesListScreen()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      // title: const Text(
      //   "Edit Note",
      //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      // ),
      // backgroundColor: Colors.lightBlue.withOpacity(0.2),
      // actions: [
      //   IconButton(
      //     icon: Icon(
      //       isPinned ? Icons.push_pin : Icons.push_pin_outlined,
      //       color: Colors.white,
      //     ),
      //     onPressed: () {
      //       setState(() {
      //         isPinned = !isPinned;
      //       });
      //     },
      //   ),
      // ],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => {Navigator.pop(context)},
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                    )),
                const Text("Edit Note",
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.black,
                        fontFamily: "rubik")),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildQuickActionCard(
                  title: isPinned ? "Unpin" : "Pin",
                  icon: isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: Colors.orange,
                  onTap: () {
                    setState(() {
                      isPinned = !isPinned;
                    });
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                buildQuickActionCard(
                  title: "Delete",
                  icon: Icons.delete,
                  color: Colors.pink,
                  onTap: () {
                    _showDeleteConfirmation(widget.note);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 40,
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
                    _handleUpdate();
                    // Navigator.pop(context);
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
                    "Update",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
