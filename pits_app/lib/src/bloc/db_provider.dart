import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pits_app/src/models/item_carrito_model.dart';
import 'package:pits_app/src/models/total_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'StayHome.db');
    return await openDatabase(
      path,
      version: 2,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE ItemsCarrito('
          ' idItemCarrito INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' idProducto INTEGER,'
          ' descripcionProducto TEXT,'
          ' cantidadProducto INTEGER,'
          ' stock INTEGER,'
          ' precioProducto NUMERIC,'
          ' precioIva NUMERIC,'
          ' precioDescuento NUMERIC,'
          ' tipo TEXT,'
          ' horario TEXT,'
          ' vehicleId NUMERIC,'
          ' vehicleInfo TEXT,'
          ' imagenUrl TEXT,'
          ' nombre TEXT'
          ')',
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          final res = await db.rawQuery("PRAGMA table_info(ItemsCarrito)");
          final existeNombre = res.any((col) => col['name'] == 'nombre');
          if (!existeNombre) {
            await db
                .execute("ALTER TABLE ItemsCarrito ADD COLUMN nombre TEXT");
          }
        }
      },
    );
  }

  Future<int> nuevoItemCarrito(ItemCarritoModel item) async {
    final db = await database;
    return await db.insert('ItemsCarrito', item.toJson());
  }

  Future<List<ItemCarritoModel>> getAllItemsCarrito() async {
    final db = await database;
    final res = await db.query('ItemsCarrito');
    return res.isNotEmpty
        ? res.map((c) => ItemCarritoModel.fromJson(c)).toList()
        : [];
  }

  Future<int> getCountItemsCarrito() async {
    final db = await database;
    final res =
        await db.rawQuery('SELECT COUNT(*) as CANTIDAD FROM ItemsCarrito');
    return res.isNotEmpty ? (res.first['CANTIDAD'] as int? ?? 0) : 0;
  }

  Future<int> updateItemCarrito(ItemCarritoModel item) async {
    final db = await database;
    return await db.update('ItemsCarrito', item.toJson(),
        where: 'idItemCarrito = ?', whereArgs: [item.idItemCarrito]);
  }

  Future<int> deleteItemCarrito(int id) async {
    final db = await database;
    return await db
        .delete('ItemsCarrito', where: 'idItemCarrito = ?', whereArgs: [id]);
  }

  Future<int> deleteAllItemsCarrito() async {
    final db = await database;
    return await db.rawDelete("DELETE FROM ItemsCarrito");
  }

  Future<Total> totalCarrito() async {
    final db = await database;
    final res = await db.rawQuery(
        "SELECT SUM(precioProducto*cantidadProducto) AS subtotal, SUM(precioIva*cantidadProducto) as iva, SUM(precioDescuento*cantidadProducto) as descuento FROM ItemsCarrito");
    return res.isNotEmpty
        ? Total.fromJson(res.first)
        : Total(subtotal: 0, iva: 0, descuento: 0);
  }

  Future<int> existeProductoEnCarrito(int idProducto) async {
    final db = await database;
    final res = await db.rawQuery(
        "SELECT idItemCarrito FROM ItemsCarrito WHERE idProducto = ?",
        [idProducto]);
    return res.isNotEmpty ? (res.first['idItemCarrito'] as int? ?? 0) : 0;
  }
}