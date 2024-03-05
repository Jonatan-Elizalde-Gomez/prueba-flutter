import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:prueba_tecnica_firma/models/firma.dart';

class FirmaController {
  static final FirmaController _instance = FirmaController._internal();
  Database? _database;

  factory FirmaController() {
    return _instance;
  }

  FirmaController._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'FirmasDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Firmas (id INTEGER PRIMARY KEY AUTOINCREMENT, dataBase64 TEXT)');
    });
  }

  Future<int> guardarFirma(String base64Data) async {
    final db = await database;
    await db.delete('Firmas');
    final res =
        await db.insert('Firmas', Firma(dataBase64: base64Data).toMap());
    return res;
  }

  Future<List<Firma>> getFirmas() async {
    final db = await database;
    final res = await db.query('Firmas');
    List<Firma> list =
        res.isNotEmpty ? res.map((c) => Firma.fromMap(c)).toList() : [];
    return list;
  }

  Future<Firma?> getFirma(int id) async {
    final db = await database;
    final res = await db.query('Firmas', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Firma.fromMap(res.first) : null;
  }

  Future<int> guardarOActualizarFirma(String base64Data) async {
    final db = await database;
    final List<Map<String, dynamic>> existing = await db.query('Firmas');
    if (existing.isNotEmpty) {
      return await db.update('Firmas', {'dataBase64': base64Data},
          where: 'id = ?', whereArgs: [existing.first['id']]);
    } else {
      return await db.insert('Firmas', {'dataBase64': base64Data});
    }
  }
}
