import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vts_sqflite/sql.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('sqflite', () {
    const channel = MethodChannel('com.viettel.vts_sqflite');

    final log = <MethodCall>[];
    String? response;

    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      return response;
    });

    tearDown(() {
      log.clear();
    });

    test('exported', () {
      expect(ConflictAlgorithm.abort, isNotNull);
    });

    test('escapeName_export', () {
      expect(escapeName('group'), '"group"');
    });

    test('unescapeName_export', () {
      expect(unescapeName('"group"'), 'group');
    });
  });
}
