import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/message.dart';


class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'geomessage.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE message (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            libelle TEXT,
            message TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            phoneNumber TEXT NOT NULL,
            date TEXT DEFAULT NULL,
            radius REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertMessage(Message message) async {
    final db = await database;
    return await db.insert(
      'message',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Message?> getMessageById(int id) async {
    final db = await database;
    final result = await db.query(
      'message',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Message.fromMap(result.first);
    }
    return null;
  }

  Future<List<Message>> getMessagesWithDate() async {
    final db = await database;
    final result = await db.query(
      'message',
      where: 'date IS NOT NULL',
    );

    return result.map((map) => Message.fromMap(map)).toList();
  }

  Future<List<Message>> getMessagesWithoutDate() async {
    final db = await database;
    final result = await db.query(
      'message',
      where: 'date IS NULL',
    );

    return result.map((map) => Message.fromMap(map)).toList();
  }

  Future<void> deleteDatabaseFile() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'message.db');
    await deleteDatabase(path);
  }

  Future<void> deleteMessage(int id) async {
    final db = await _initDatabase();
    await db.delete(
      'message',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
