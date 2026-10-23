import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  final int id;
  final String title;
  final bool isCompleted;

  factory Task.fromMap(Map<String, Object?> map) {
    return Task(
      id: map['id'] as int,
      title: map['title'] as String,
      isCompleted: (map['is_completed'] as int) == 1,
    );
  }
}

/// Owns the SQLite connection and all task data-access operations.
class TaskRepository {
  TaskRepository._(this._database);

  final Database _database;

  static Future<TaskRepository> create() async {
    final databaseDirectory = await getDatabasesPath();
    final databasePath = p.join(databaseDirectory, 'it126_tasks.db');

    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            is_completed INTEGER NOT NULL DEFAULT 0
              CHECK (is_completed IN (0, 1))
          )
        ''');
      },
    );

    return TaskRepository._(database);
  }

  Future<int> createTask(String title) {
    final cleanedTitle = title.trim();
    if (cleanedTitle.isEmpty) {
      throw ArgumentError('Task title cannot be empty.');
    }

    return _database.insert(
      'tasks',
      {'title': cleanedTitle, 'is_completed': 0},
    );
  }

  Future<List<Task>> getAllTasks() async {
    final rows = await _database.query('tasks', orderBy: 'id DESC');
    return rows.map(Task.fromMap).toList();
  }

  Future<int> setCompleted(int id, bool completed) {
    return _database.update(
      'tasks',
      {'is_completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(int id) {
    return _database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() => _database.close();
}
