import 'package:my_simple_note/models/Note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initialiseDatabase() async {
    String path = await getDatabasesPath();

    const String tableCreateQuery =
        'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, description TEXT,isPinned BOOLEAN NOT NULL DEFAULT 0,createdAt TEXT DEFAULT CURRENT_TIMESTAMP,updatedAt TEXT DEFAULT CURRENT_TIMESTAMP)';

    return openDatabase(join(path, 'my_notes.db'),
        onCreate: (database, version) async {
      await database.execute(tableCreateQuery);
      print("###################################################.");
      print("table created.");
      print("###################################################.");
    }, version: 1);
  }

  Future<void> insertData(Note note) async {
    final Database db = await initialiseDatabase();
    note.createdAt = DateTime.now();
    note.updatedAt = DateTime.now();
    final result = await db.insert("notes", note.toJson());
    print(result);
  }

  Future<List<Note>> getData() async {
    final Database db = await initialiseDatabase();
    final result = await db.query("notes", orderBy: "updatedAt DESC");
    List<Note> notes = result.map((e) => Note.fromJson(e)).toList();

    return notes;
  }

  Future<List<Note>> getPinnedData() async {
    final Database db = await initialiseDatabase();
    final result = await db.query("notes",
        orderBy: "updatedAt DESC", where: "isPinned = ?", whereArgs: [1]);
    List<Note> notes = result.map((e) => Note.fromJson(e)).toList();

    return notes;
  }

  Future<List<Note>> getSearchData(String searchKey) async {
    if (searchKey.trim().isEmpty) {
      return [];
    }
    final Database db = await initialiseDatabase();
    final result = await db.query("notes",
        orderBy: "updatedAt DESC",
        where: "LOWER(title) LIKE ? OR LOWER(description) LIKE ?",
        whereArgs: [
          '%${searchKey.toLowerCase()}%',
          '%${searchKey.toLowerCase()}%'
        ]);
    List<Note> notes = result.map((e) => Note.fromJson(e)).toList();

    return notes;
  }

  Future<void> updateData(Note note) async {
    final Database db = await initialiseDatabase();
    await db
        .update("notes", note.toJson(), where: "id = ?", whereArgs: [note.id]);
  }

  Future<void> deleteData(int id) async {
    final Database db = await initialiseDatabase();
    await db.delete(
      "notes",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
