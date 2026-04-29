import 'package:anchieta_flutter_todo/dtos/task_update_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    return await openDatabase(
      path, 
      version: 2, 
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        tarefa TEXT NOT NULL,
        status INTEGER DEFAULT 0,
        idUserCreated TEXT,
        dtCreated TEXT,
        idUserLastUpdated TEXT,
        dtLastUpdated TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    switch(newVersion){
      case 2: 
        await db.execute('ALTER TABLE tasks ADD COLUMN sync INTEGER DEFAULT 0');
        break;
      default:
        print("Nehhuma opção selecionada");
    }
  }

  Future<int> insertTask(TaskModel task) async {
    Database db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<TaskModel>> getTasksAtivas(String idUserCreated) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks', 
      where: 'status = ? and idUserCreated = ?', 
      whereArgs: [0, idUserCreated],
      orderBy: 'dtCreated DESC'
    );
    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  Future<int> updateTask(TaskUpdateDTO dto) async {
    Database db = await database;
    return await db.update(
      'tasks',
      dto.toMap(), // O DTO já entrega o mapa prontinho
      where: 'id = ?',
      whereArgs: [dto.id],
    );
  }

  // Future<int> deleteTask(String id) async {
  //   Database db = await database;
  //   return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  // }
}