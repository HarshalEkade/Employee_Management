import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/employee.dart';

class LocalDbService {
  static const _dbName = 'employees.db';
  static const _table = 'employees';
  static const _dbVersion = 1;

  Database? _database;

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = p.join(directory.path, _dbName);
    _database = await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            designation TEXT NOT NULL,
            dob TEXT NOT NULL,
            image_path TEXT
          )
        ''');
      },
    );
  }

  Database get _db {
    final db = _database;
    if (db == null) {
      throw StateError('Database not initialized');
    }
    return db;
  }

  Future<List<Employee>> fetchEmployees({
    String search = '',
    DateTime? startDob,
    DateTime? endDob,
    int page = 0,
    int pageSize = 10,
  }) async {
    final where = <String>[];
    final args = <dynamic>[];

    if (search.isNotEmpty) {
      where.add('(name LIKE ? OR designation LIKE ?)');
      args.addAll(['%$search%', '%$search%']);
    }

    if (startDob != null) {
      where.add('date(dob) >= date(?)');
      args.add(startDob.toIso8601String());
    }

    if (endDob != null) {
      where.add('date(dob) <= date(?)');
      args.add(endDob.toIso8601String());
    }

    final whereClause = where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}';
    final offset = page * pageSize;

    final rows = await _db.rawQuery('''
      SELECT * FROM $_table
      $whereClause
      ORDER BY date(dob) DESC
      LIMIT ? OFFSET ?
    ''', [...args, pageSize, offset]);

    return rows.map((e) => Employee.fromMap(e)).toList();
  }

  Future<int> insertEmployee(Employee employee) {
    return _db.insert(_table, employee.toMap());
  }

  Future<int> updateEmployee(Employee employee) {
    return _db.update(
      _table,
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }

  Future<int> deleteEmployee(int id) {
    return _db.delete(
      _table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

