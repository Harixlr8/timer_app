// import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLhelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      time TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'stopwatch.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(String name, String time) async {
    final db = await SQLhelper.db();

    final data = {'name': name, 'time': time};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }
  static Future<List<Map<String,dynamic>>>getItems()async{
    final db =await SQLhelper.db();
    return db.query('items',orderBy: "id");
  }


  // static Future<void>deleteItem(int id)async{
  //   final db = await SQLhelper.db();
  //   try{
  //     await db.delete("items",where: "id=?",whereArgs: [id]);
  //   }
  //   catch(e){
  //     debugPrint('Someting went wrong when deleting $e');
  //   }
  // }

   
}
