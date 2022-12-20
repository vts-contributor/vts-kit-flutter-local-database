import 'package:flutter/cupertino.dart';
import 'package:vts_sqflite/src/factory.dart';
import 'package:vts_sqflite/src/factory_impl.dart';
import 'package:vts_sqflite_common/sqlite_api.dart';

export 'package:vts_sqflite/src/factory_impl.dart'
    show sqfliteDatabaseFactoryDefault;

/// Change the default factory used.
///
/// Test only.
///
@visibleForTesting
void setMockDatabaseFactory(DatabaseFactory? factory) {
  // ignore: invalid_use_of_visible_for_testing_member
  sqfliteDatabaseFactory = factory as SqfliteDatabaseFactory?;
}