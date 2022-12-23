import 'package:flutter/cupertino.dart';
import 'package:vts_sqflite/cipher_overrides/factory_mixin.dart';
import 'package:vts_sqflite/cipher_overrides/sqlite_api.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'factory.dart';
import 'factory_impl.dart';

///cipher impl
class CipherSqfliteDatabaseFactoryImpl extends SqfliteDatabaseFactoryImpl with CipherSqfliteDatabaseFactoryMixin{

}
///db factory
CipherDatabaseFactory get databaseFactory => sqfliteDatabaseFactory;
/// sqflite Default factory
@visibleForTesting
CipherDatabaseFactory get sqfliteDatabaseFactory =>
   sqfliteDatabaseFactoryDefault;

/// Default factory that uses the plugin.
CipherDatabaseFactory sqfliteDatabaseFactoryDefault =
CipherSqfliteDatabaseFactoryImpl();
