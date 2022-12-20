@TestOn('vm')
import 'dart:io';

import 'package:vts_sqflite_common/sqlite_api.dart';
import 'package:vts_sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

import 'sqflite_ffi_windows_setup_test.dart';

void main() {
  if (Platform.isWindows) {
    sqfliteFfiInit();
    group('windows', () {
      test('version', () async {
        final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
        final results = await db.rawQuery('select sqlite_version()');

        var version = results.first.values.first;
        expect(version, windowsSqliteVersion);
      });
    });
  }
}
