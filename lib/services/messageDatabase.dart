import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/message.dart';

class MessageDatabase {
  static final MessageDatabase _instance = MessageDatabase._internal();
  factory MessageDatabase() => _instance;
  MessageDatabase._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'messages.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Création de la table messages
        await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            message TEXT,
            latitude REAL,
            longitude REAL,
            phoneNumber TEXT,
            date TEXT DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
    );
  }

  // Ajouter un message
  Future<void> addMessage(Message message) async {
    final db = await database;
    await db.insert('message', message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Récupérer tous les messages
  Future<List<Message>> getMessages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('messages');
    return List.generate(maps.length, (i) => Message.fromMap(maps[i]));
  }

  // Supprimer un message par ID
  Future<void> deleteMessage(int id) async {
    final db = await database;
    await db.delete('messages', where: 'id = ?', whereArgs: [id]);
  }
}
