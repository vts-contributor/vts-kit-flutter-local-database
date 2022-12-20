import 'dart:async';

import 'package:vts_sqflite/sqlite_api.dart';
import 'package:vts_sqflite/src/mixin/factory.dart';

Future<void> main() async {
  final factory = buildDatabaseFactory(
      invokeMethod: (String method, [dynamic arguments]) async {
    dynamic result;
    // ignore: avoid_print
    print('$method: $arguments');
    return result;
  });
  final db = await factory.openDatabase(inMemoryDatabasePath);
  await db.getVersion();
}
