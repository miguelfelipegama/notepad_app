import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory, MissingPlatformDirectoryException;
import 'package:path/path.dart' show join;

const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedtoCloudColumn = 'issyncedtocloud';
const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id" INTEGER NOT NULL,
        "email" TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      ); ''';
const createNoteTable = ''' CREATE TABLE IF NOT EXISTS "note" (
        "id" INTEGER NOT NULL,
        "user_id" INTEGER NOT NULL,
        "text" TEXT,
        "issyncedtocloud" INTEGER NOT NULL DEFAULT 0,
        FOREIGN KKEY("user_id) REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
        ); ''';

class DatabaseAlreadyOpenException implements Exception {}

class DatabaseNotOpenException implements Exception {}

class UnableToGetDocumentsDirectoryException implements Exception {}

class NotesService {
  Database? _db;

  Database _getDatabaseOrThrow() {}

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);

      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }

  Future<void> close() async {
    final db = _db;

    if (db == null) {
      throw DatabaseNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedtoCloud;

  const DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedtoCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[userIdColumn] as String,
        isSyncedtoCloud =
            (map[isSyncedtoCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, ID = $id, userId = $userId, synced = $isSyncedtoCloud';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
