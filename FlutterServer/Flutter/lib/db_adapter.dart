import 'dart:ffi';

import 'package:mobile/tvseries.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class DbAdapter{
   static const int _version = 1;
   static const String _dbName = "TVSeries.db";


   static Future<Database> _getDB() async{
     return openDatabase(join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async => await db.execute("CREATE TABLE TvSeries(id integer, title text, releaseDate text, noSeasons integer, noEpisodes integer, rating integer, status text)"),version: _version
     );
   }

   static Future<int> addTvSeries(TVSeries tvSeries) async{
     final db = await _getDB();
     return await db.insert("TvSeries", tvSeries.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
   }

   static Future<int> updateTvSeries(TVSeries tvSeries) async{
     final db = await _getDB();
     return await db.update("TvSeries", tvSeries.toMap(), where: 'id = ?', whereArgs: [tvSeries.id], conflictAlgorithm: ConflictAlgorithm.replace);
   }

   static Future<int> deleteTvSeries(TVSeries tvSeries) async{
     final db = await _getDB();
     return await db.delete("TvSeries", where: "id = ?", whereArgs: [tvSeries.id]);
   }

   static Future<int> deleteTvSeriesId(int id) async{
     final db = await _getDB();
     return await db.delete("TvSeries", where: "id = ?", whereArgs: [id]);
   }

   static Future<List<TVSeries>?> getAllTvSeries() async {
     final db = await _getDB();
     final List<Map<String, dynamic>> maps = await db.query("TvSeries");
     if (maps.isEmpty) {
       return null;
     }
     return List.generate(
         maps.length, (index) => TVSeries.fromMap(maps[index]));
   }

   static Future<int> deleteAllSeries() async{
     final db = await _getDB();
     return await db.delete("TvSeries");
   }
}