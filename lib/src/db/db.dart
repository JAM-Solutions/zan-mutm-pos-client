import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {

    DbProvider._();

    static final DbProvider _singleton = DbProvider._();

     Database? _database;

    factory DbProvider() => _singleton;

    Future<Database> get database async {
        if (_database != null) return _database!;
        _database = await initDB();
        return _database!;
    }

    initDB() async {
      String dbName =  dotenv.env['DB_NAME'] ?? 'zanmutm_default_db';
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String path = join(documentsDirectory.path, "$dbName.db");
        return await openDatabase(path, version: 1, onOpen: (db) {},
            onCreate: (Database db, int version) async {
               debugPrint("*******Db is has bee created*****");
                await db.execute("CREATE TABLE IF NOT EXISTS migrations ("
                    "id INTEGER PRIMARY KEY,"
                    "version VARCHAR(50) NOT NULL,"
                    "description TEXT NOT NULL,"
                    "script TEXT NOT NULL,"
                    "success BIT"
                    ")");
            });
    }

    migrate() async {
      debugPrint("****Migrating**********");
      var db = await database;
      List<Map<String, dynamic>> executed = await db.query('migrations');
      List<String> versions = executed.map((e) => e['version'].toString()).toList();
      debugPrint(versions.toString());
      final manifestJson = await rootBundle.loadString('AssetManifest.json');
      final List<String> migrations = (json.decode(manifestJson).keys.where((String key) => key.startsWith('migrations'))).toList();
      for (var m in migrations) {
        final names = m.replaceFirst('migrations/', '').split('__');
        if (!versions.contains(names[0])) {
          String content = await rootBundle.loadString(m);
          debugPrint(names.toString());
          debugPrint(content);
           await db.execute(content);

          var insert = {
            'version': names[0],
            'description':names[1].replaceFirst('.sql', ''),
            'script':m,
            'success': 1
          };
          await db.insert('migrations', insert);
        }
      }
      debugPrint("****Migrating successfully**********");
    }
}