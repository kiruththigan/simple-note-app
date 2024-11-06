import 'package:flutter/material.dart';
import 'package:my_simple_note/models/Note.dart';
import 'package:my_simple_note/screens/note_add_screen.dart';
import 'package:my_simple_note/screens/note_view_screen.dart';

import '../components/build_quick_action_card.dart';
import '../db_helper/database_handler.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  late DatabaseHandler handler;
  bool isPinned = false;
  String searchKey = "";

  @override
  void initState() {
    super.initState();

    handler = DatabaseHandler();
  }

  Map<String, List<Note>> _groupNotesByDate(List<Note> notes) {
    final now = DateTime.now();
    Map<String, List<Note>> groupedNotes = {
      "Pinned": [],
      "Today": [],
      "Previous 7 Days": [],
      "Previous 30 Days": [],
      "Long Time Ago": []
    };

    for (var note in notes) {
      final updatedDate = note.updatedAt!;
      final difference = now.difference(updatedDate).inDays;

      if (!isPinned && note.isPinned!) {
        groupedNotes["Pinned"]!.add(note);
      } else {
        if (difference == 0) {
          groupedNotes["Today"]!.add(note);
        } else if (difference <= 7) {
          groupedNotes["Previous 7 Days"]!.add(note);
        } else if (difference <= 30) {
          groupedNotes["Previous 30 Days"]!.add(note);
        } else {
          groupedNotes["Long Time Ago"]!.add(note);
        }
      }
    }

    return groupedNotes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "My Simple Note",
      //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //   ),
      //   backgroundColor: Colors.teal,
      // ),
      body: Container(
        padding:
            const EdgeInsets.only(top: 40, right: 16, bottom: 16, left: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("My Notes",
                style: TextStyle(
                    fontSize: 50,
                    // color: Color(0xFF7C3AED),
                    color: Colors.black,
                    fontFamily: "rubik")),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.44),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchKey = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Search notes...",
                            hintStyle: TextStyle(color: Colors.black87),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.black87,
                              ),
                            ),
                            suffixIcon: searchKey.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        searchKey = "";
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildQuickActionCard(
                      title: "All",
                      icon: Icons.notes,
                      color: Colors.blueGrey,
                      isActive: !isPinned,
                      onTap: () {
                        setState(() {
                          isPinned = false;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    buildQuickActionCard(
                      title: "Pinned",
                      icon: Icons.push_pin,
                      color: Colors.blueGrey,
                      isActive: isPinned,
                      onTap: () {
                        setState(() {
                          isPinned = true;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Note>>(
                future: searchKey.trim().isNotEmpty
                    ? handler.getSearchData(searchKey)
                    : isPinned
                        ? handler.getPinnedData()
                        : handler.getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error loading notes"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No notes available"));
                  } else {
                    Map<String, List<Note>> notes =
                        _groupNotesByDate(snapshot.data!);

                    return ListView(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      children: notes.entries.expand<Widget>((entry) {
                        if (entry.value.isNotEmpty) {
                          return [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            ...entry.value.map<Widget>((note) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(top: 6, bottom: 6),
                                child: Material(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    // side: BorderSide(
                                    // color: isPinned || entry.key == "Pinned"
                                    //     ? Colors.black
                                    //     : const Color(0xFF7C3AED),
                                    // width: 2,
                                    // ),
                                  ),
                                  elevation: 4.0,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NoteViewScreen(note: note),
                                        ),
                                      );
                                    },
                                    tileColor: isPinned || entry.key == "Pinned"
                                        ? Colors.teal.shade900.withOpacity(0.77)
                                        : Colors.blueGrey.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    title: Text(note.title!),
                                    titleTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: "itim"),
                                    subtitle: Text(note.description!),
                                    subtitleTextStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.64),
                                        fontSize: 18,
                                        fontFamily: "chakra"),
                                    trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          note.isPinned = !note.isPinned!;
                                          note.updatedAt = DateTime.now();
                                          handler.updateData(note);
                                        });
                                      },
                                      icon: Icon(
                                          note.isPinned!
                                              ? Icons.push_pin
                                              : Icons.push_pin_outlined,
                                          size: 30,
                                          color: note.isPinned!
                                              ? Colors.blueGrey.shade800
                                              : Colors.black54),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ];
                        } else {
                          return [];
                        }
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 25.0,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NoteAddScreen()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
