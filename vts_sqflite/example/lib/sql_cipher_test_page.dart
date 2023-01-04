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
      bool wrongPassTest;
      try {
        //must throw an error here
        await openDatabase('test.db', password: '');
        wrongPassTest = false;
      } catch (e) {
        debugPrint('expected: ${e.toString()}');
        wrongPassTest = true;
      }

      expect(wrongPassTest, true);

      var encryptedDb = await openDatabase('test.db', password: '#123@');

      expect ((await encryptedDb.query('students')).length, 2);
      await encryptedDb.close();
    });
    //
    // test('change password', () async {
    //   var encryptedDb = await openDatabase('test.db', password: '#123@');
    //
    //   encryptedDb = await openDatabase('test.db', password: '123');
    //
    //   expect ((await encryptedDb.query('students')).length, 2);
    //   await encryptedDb.close();
    // });
    //
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

      bool failDecryptTest;
      try {
        //must throw an error here
        await decryptDatabase('${await getDatabasesPath()}/test.db', '');
        failDecryptTest = false;
      } catch (e) {
        debugPrint('expected: ${e.toString()}');
        failDecryptTest = true;
      }

      expect(failDecryptTest, true);

      expect(await decryptDatabase('${await getDatabasesPath()}/test.db', '#123@'), true);
    });

    test('re-open after decryption', () async {
      bool wrongPassTest;
      try {
        //must throw an error here
        await openDatabase('test.db', password: '#123@');
        wrongPassTest = false;
      } catch (e) {
        debugPrint('expected: ${e.toString()}');
        wrongPassTest = true;
      }

      expect(wrongPassTest, true);

      var decryptedDb = await openDatabase('test.db', password: '');

      expect ((await decryptedDb.query('students')).length, 2);
      await decryptedDb.close();
    });
  }

}
