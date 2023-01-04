import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vts_sqflite/sqflite.dart';
import 'package:sqflite_example/test_page.dart';

///encrypt test page
class SQLCipherTestPage extends TestPage {
  ///encrypt test page
  SQLCipherTestPage({super.key}) : super('sqlcipher test page') {
    test('encrypt database', () async {
      debugPrint(await getDatabasesPath());
      await deleteDatabase('test.db');
      var tempDb = await openDatabase('test.db', password: '');

      await tempDb.execute('CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT)');

      expect(await tempDb.insert('students', {
        'id': 1,
        'name': 'Nguyen Van A',
      }), 1);

      expect(await tempDb.insert('students', {
        'id': 2,
        'name': 'Nguyen Van B',
      }), 2);

      expect ((await tempDb.query('students')).length, 2);

      await tempDb.close();

      tempDb = await openDatabase('test.db');

      expect ((await tempDb.query('students')).length, 2);

      await tempDb.close();

      expect(await encryptDatabase('${await getDatabasesPath()}/test.db', '#123@'), true);

    });

    test('re-open after encryption', () async {
      testMustThrow(() async => await openDatabase('test.db', password: ''));

      var encryptedDb = await openDatabase('test.db', password: '#123@');

      expect ((await encryptedDb.query('students')).length, 2);
      await encryptedDb.close();
    });

    test('change password', () async {
      await deleteDatabase('testChange.db');
      var encryptedDb = await openDatabase('testChange.db', password: '#123@');

      bool changePassRes;
      try {
        changePassRes = await changePassword(encryptedDb, 'ghPass');
      } catch (e) {
        changePassRes = false;
      }
      expect(changePassRes, true);

      await encryptedDb.execute('CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT)');

      expect(await encryptedDb.insert('students', {
        'id': 1,
        'name': 'Nguyen Van A',
      }), 1);

      expect(await encryptedDb.insert('students', {
        'id': 2,
        'name': 'Nguyen Van B',
      }), 2);

      expect ((await encryptedDb.query('students')).length, 2);

      await encryptedDb.close();

      testMustThrow(() async => await openDatabase('testChange.db', password: '#123@'));

      encryptedDb = await openDatabase('testChange.db', password: 'ghPass');

      expect ((await encryptedDb.query('students')).length, 2);
      await encryptedDb.close();
    });

    test('decrypt database', () async {
      await deleteDatabase('test.db');
      var tempDb = await openDatabase('test.db', password: '#123@');

      await tempDb.execute('CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT)');

      expect(await tempDb.insert('students', {
        'id': 1,
        'name': 'Nguyen Van A',
      }), 1);

      expect(await tempDb.insert('students', {
        'id': 2,
        'name': 'Nguyen Van B',
      }), 2);

      expect ((await tempDb.query('students')).length, 2);

      await tempDb.close();

      testMustThrow(() async => await decryptDatabase('${await getDatabasesPath()}/test.db', ''));

      expect(await decryptDatabase('${await getDatabasesPath()}/test.db', '#123@'), true);
    });

    test('re-open after decryption', () async {
      testMustThrow(() async => await openDatabase('test.db', password: '#123@'));

      var decryptedDb = await openDatabase('test.db', password: '');

      expect ((await decryptedDb.query('students')).length, 2);
      await decryptedDb.close();
    });
  }

  ///test but must throw error
  void testMustThrow(Future<void> Function() testFunc) async {
    bool throwTest;
    try {
      //must throw an error here
      await testFunc();
      throwTest = false;
    } catch (e) {
      debugPrint('expected: ${e.toString()}');
      throwTest = true;
    }

    expect(throwTest, true);
  }

}
