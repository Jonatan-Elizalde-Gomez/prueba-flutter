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
    // Si _database es nulo entonces inicializamos la base de datos
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

  // Modificación aquí
  Future<int> guardarFirma(String base64Data) async {
    final db = await database;
    // Primero, borra todas las entradas existentes
    await db.delete('Firmas');
    // Luego, inserta la nueva firma
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
      // If there's an existing signature, update it
      return await db.update('Firmas', {'dataBase64': base64Data},
          where: 'id = ?', whereArgs: [existing.first['id']]);
    } else {
      // If there's no existing signature, insert a new one
      return await db.insert('Firmas', {'dataBase64': base64Data});
    }
  }
}
