// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:path/path.dart' as p;
import 'package:vts_sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_test/src/core_import.dart';
import 'package:sqflite_common_test/src/sqflite_import.dart';
import 'package:sqflite_common_test/src/test_scenario.dart';
import 'package:test/test.dart';

/// Common open step
var openStep = [
  'openDatabase',
  {'path': ':memory:', 'singleInstance': true},
  {'id': 1}
];

/// Common close step
var closeStep = [
  'closeDatabase',
  {'id': 1},
  null
];

/// Test with a mock implementation by default
void main() {
  run(null);
}

/// Run open test.
void run(SqfliteTestContext? context) {
  var factory = context?.databaseFactory;
  Future<String> initDeleteDb(String dbName) async {
    if (context == null) {
      // Make it absolute to avoid getDatabasesPath to be called
      // The file itself is not used
      return p.absolute(dbName);
    }
    return await context.initDeleteDb(dbName);
  }

  group('protocol', () {
    test('open close', () async {
      final scenario = wrapStartScenario(factory, [openStep, closeStep]);
      final db = await scenario.factory.openDatabase(inMemoryDatabasePath);
      await db.close();
      scenario.end();
    });
    test('execute', () async {
      final scenario = wrapStartScenario(factory, [
        openStep,
        [
          'execute',
          {'sql': 'PRAGMA user_version = 1', 'id': 1},
          null,
        ],
        closeStep
      ]);
      final db = await scenario.factory.openDatabase(inMemoryDatabasePath);
      await db.setVersion(1);

      await db.close();
      scenario.end();
    });

    test('transaction', () async {
      final scenario = wrapStartScenario(factory, [
        openStep,
        [
          'execute',
          {
            'sql': 'BEGIN IMMEDIATE',
            'id': 1,
            'inTransaction': true,
            'transactionId': null
          },
          {'transactionId': 1},
        ],
        [
          'execute',
          {
            'sql': 'COMMIT',
            'id': 1,
            'inTransaction': false,
            'transactionId': 1
          },
          null,
        ],
        closeStep
      ]);
      final db = await scenario.factory.openDatabase(inMemoryDatabasePath);
      await db.transaction((txn) async {});

      await db.close();
      scenario.end();
    });

    test('open onCreate', () async {
      final scenario = wrapStartScenario(factory, [
        openStep,
        [
          'query',
          {'sql': 'PRAGMA user_version', 'id': 1},
          {
            'columns': ['user_version'],
            'rows': [
              [0]
            ]
          }
        ],
        [
          'execute',
          {
            'sql': 'BEGIN EXCLUSIVE',
            'id': 1,
            'inTransaction': true,
            'transactionId': null
          },
          {'transactionId': 1},
        ],
        [
          'query',
          {'sql': 'PRAGMA user_version', 'id': 1, 'transactionId': 1},
          {
            'columns': ['user_version'],
            'rows': [
              [0]
            ]
          }
        ],
        [
          'execute',
          {'sql': 'PRAGMA user_version = 1', 'id': 1, 'transactionId': 1},
          null,
        ],
        [
          'execute',
          {
            'sql': 'COMMIT',
            'id': 1,
            'inTransaction': false,
            'transactionId': 1
          },
          null,
        ],
        closeStep
      ]);
      final db = await scenario.factory.openDatabase(inMemoryDatabasePath,
          options: OpenDatabaseOptions(onCreate: (_, __) {}, version: 1));

      await db.close();
      scenario.end();
    });

    test('open onDowngradeDelete', () async {
      // Need a real file
      var dbName = await initDeleteDb('protocol_on_downgrade_delete.db');
      var db = await factory?.openDatabase(dbName,
          options: OpenDatabaseOptions(onCreate: (_, __) {}, version: 2));
      await db?.close();

      final scenario = wrapStartScenario(factory, [
        [
          'openDatabase',
          {'path': dbName, 'singleInstance': true},
          {'id': 1}
        ],
        [
          'query',
          {'sql': 'PRAGMA user_version', 'id': 1},
          {
            'columns': ['user_version'],
            'rows': [
              [2]
            ]
          }
        ],
        [
          'execute',
          {
            'sql': 'BEGIN EXCLUSIVE',
            'id': 1,
            'inTransaction': true,
            'transactionId': null
          },
          {'transactionId': 1},
        ],
        [
          'query',
          {'sql': 'PRAGMA user_version', 'id': 1, 'transactionId': 1},
          {
            'columns': ['user_version'],
            'rows': [
              [2]
            ]
          }
        ],
        [
          'execute',
          {
            'sql': 'ROLLBACK',
            'id': 1,
            'transactionId': 1,
            'inTransaction': false
          },
          null,
        ],
        closeStep,
        [
          'deleteDatabase',
          {'path': dbName},
          null
        ],
        [
          'openDatabase',
          {'path': dbName, 'singleInstance': true},
          {'id': 1}
        ],
        [
          'execute',
          {
            'sql': 'BEGIN EXCLUSIVE',
            'id': 1,
            'inTransaction': true,
            'transactionId': null
          },
          {'transactionId': 1},
        ],
        [
          'execute',
          {'sql': 'PRAGMA user_version = 1', 'id': 1, 'transactionId': 1},
          null,
        ],
        [
          'execute',
          {
            'sql': 'COMMIT',
            'id': 1,
            'inTransaction': false,
            'transactionId': 1
          },
          null,
        ],
        closeStep
      ]);
      db = await scenario.factory.openDatabase(dbName,
          options: OpenDatabaseOptions(
              onDowngrade: onDatabaseDowngradeDelete, version: 1));

      await db.close();
      scenario.end();
    });

    test('manual begin transaction', () async {
      final scenario = wrapStartScenario(factory, [
        openStep,
        [
          'execute',
          {'sql': 'BEGIN TRANSACTION', 'id': 1, 'inTransaction': true},
          null,
        ],
        [
          'execute',
          {
            'sql': 'ROLLBACK',
            'id': 1,
            'inTransaction': false,
            'transactionId': -1
          },
          null,
        ],
        closeStep
      ]);
      final db = await scenario.factory.openDatabase(inMemoryDatabasePath);
      await db.execute('BEGIN TRANSACTION');

      await db.close();
      scenario.end();
    });

    test('manual begin end transaction', () async {
      final scenario = wrapStartScenario(factory, [
        openStep,
        [
          'execute',
          {'sql': 'BEGIN TRANSACTION', 'id': 1, 'inTransaction': true},
          null,
        ],
        [
          'execute',
          {'sql': 'ROLLBACK', 'id': 1, 'inTransaction': false},
          null,
        ],
        closeStep
      ]);
      final db = await scenario.factory.openDatabase(inMemoryDatabasePath);
      await db.execute('BEGIN TRANSACTION');
      await db.execute('ROLLBACK');

      await db.close();
      scenario.end();
    });

    test('recovered', () async {
      var dbName = await initDeleteDb('protocol_recovered.db');
      final scenario = wrapStartScenario(factory, [
        [
          'openDatabase',
          {'path': dbName, 'singleInstance': true},
          {'id': 1},
        ],
        [
          'openDatabase',
          {'path': dbName, 'singleInstance': true},
          if (context?.supportsRecoveredInTransaction ?? false)
            {'recovered': true, 'id': 1}
          else
            {'id': 1},
        ],
        closeStep
      ]);

      final db = await scenario.factory.openDatabase(dbName);
      await scenario.factory.internalsInvokeMethod(
          'openDatabase', {'path': dbName, 'singleInstance': true});

      await db.close();
      scenario.end();
    });

    test('recovered_in_transaction_1', () async {
      var dbName = await initDeleteDb('protocol_recovered_in_transaction_1.db');
      final scenario = wrapStartScenario(factory, [
        [
          'openDatabase',
          {'path': dbName, 'singleInstance': true},
          {'id': 1},
        ],
        [
          'execute',
          {'sql': 'BEGIN TRANSACTION', 'id': 1, 'inTransaction': true},
          null,
        ],
        [
          'openDatabase',
          {'path': dbName, 'singleInstance': true},
          if (context?.supportsRecoveredInTransaction ?? false)
            {'recovered': true, 'recoveredInTransaction': true, 'id': 1}
          else
            {'id': 1},
        ],
        [
          'execute',
          {
            'sql': 'ROLLBACK',
            'id': 1,
            'transactionId': -1,
            'inTransaction': false
          },
          null,
        ],
        closeStep
      ]);

      final db = await scenario.factory.openDatabase(dbName);
      await db.execute('BEGIN TRANSACTION');
      await scenario.factory.internalsInvokeMethod(
          'openDatabase', {'path': dbName, 'singleInstance': true});

      await db.close();
      scenario.end();
    });

    test('recovered_in_transaction_2', () async {
      var dbName = await initDeleteDb('protocol_recovered_in_transaction_2.db');
      final scenario = wrapStartScenario(factory, [
        [
          'openDatabase',
          {'path': dbName, 'singleInstance': true},
          {'id': 1}
        ],
        [
          'execute',
          {'sql': 'BEGIN TRANSACTION', 'id': 1, 'inTransaction': true},
          null,
        ],
        [
          'openDatabase',
          {'path': dbName, 'singleInstance': true},
          if (context?.supportsRecoveredInTransaction ?? false)
            {'recovered': true, 'recoveredInTransaction': true, 'id': 1}
          else
            {'id': 1},
        ],
        if (context?.supportsRecoveredInTransaction ?? false)
          [
            'execute',
            {
              'sql': 'ROLLBACK',
              'id': 1,
              'transactionId': -1,
              'inTransaction': false
            },
            null,
          ],
        closeStep
      ]);
      await scenario.factory.internalsInvokeMethod(
          'openDatabase', {'path': dbName, 'singleInstance': true});
      await scenario.factory.internalsInvokeMethod(
        'execute',
        {'sql': 'BEGIN TRANSACTION', 'id': 1, 'inTransaction': true},
      );
      final db = await scenario.factory.openDatabase(dbName);

      await db.close();
      scenario.end();
    });
  });
}
