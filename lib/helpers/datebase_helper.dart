import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/models/subtask_model.dart';
import 'package:todolist/models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String tasksTable = 'tasks_table';
  String colTaskId = 'taskId';
  String colTaskTitle = 'taskTitle';
  String colTaskDescription = 'taskDescription';
  String colTaskDate = 'taskDate';
  String colTaskTime = 'taskTime';
  String colTaskPriority = 'taskrPiority';
  String colTaskStatus = 'taskStatus';

  String subTasksTable = 'subTasks_table';
  String colSubTaskId = 'subTaskId';
  String colSubTaskTitle = 'subTaskTitle';
  String colSubTaskStatus = 'subTaskStatus';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_list.db';
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      '''
        CREATE TABLE $tasksTable(
          $colTaskId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colTaskTitle TEXT,
          $colTaskDescription TEXT,
          $colTaskDate TEXT,
          $colTaskTime Text,
          $colTaskPriority TEXT,
          $colTaskStatus INTEGER
          )
      ''',
    );

    await db.execute(
      '''
        CREATE TABLE $subTasksTable(
          $colTaskId INTEGER,
          $colSubTaskId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colSubTaskTitle TEXT,
          $colSubTaskStatus INTEGER
          )
      ''',
    );
  }

  Future<List<Map<String, dynamic>>> getTasksMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(tasksTable);
    return result;
  }

  Future<List<Task>> getTasksList() async {
    final List<Map<String, dynamic>> tasksMapList = await getTasksMapList();
    final List<Task> tasksList = [];
    tasksMapList.forEach((taskMap) {
      tasksList.add(Task.fromMap(taskMap));
    });
    tasksList.sort((taskA, taskB) => taskA.taskDate.compareTo(taskB.taskDate));
    return tasksList;
  }

  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    final int result = await db.insert(tasksTable, task.toMap());
    return result;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    final int result = await db.update(
      tasksTable,
      task.toMap(),
      where: '$colTaskId = ?',
      whereArgs: [task.taskId],
    );
    return result;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      tasksTable,
      where: '$colTaskId = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getSubTasksMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(subTasksTable);
    return result;
  }

  Future<List<SubTask>> getSubTasksList() async {
    final List<Map<String, dynamic>> subTasksMapList =
        await getSubTasksMapList();
    final List<SubTask> subTasksList = [];
    subTasksMapList.forEach((subTaskMap) {
      subTasksList.add(SubTask.fromMap(subTaskMap));
    });
    // subTasksList.sort((subTaskA, subTaskB) => subTaskA.subTaskDate.compareTo(subTaskB.subTaskDate));
    return subTasksList;
  }

  Future<int> insertSubTask(SubTask subTask) async {
    Database db = await this.db;
    final int result = await db.insert(subTasksTable, subTask.toMap());
    return result;
  }

  Future<int> updateSubTask(SubTask subTask) async {
    Database db = await this.db;
    final int result = await db.update(
      subTasksTable,
      subTask.toMap(),
      where: '$colSubTaskId = ?',
      whereArgs: [subTask.subTaskId],
    );
    return result;
  }

  Future<int> deleteSubTask(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      subTasksTable,
      where: '$colSubTaskId = ?',
      whereArgs: [id],
    );
    return result;
  }
}
