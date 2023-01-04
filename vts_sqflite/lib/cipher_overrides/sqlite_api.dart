import 'package:vts_sqflite/sqflite.dart';
import 'package:vts_sqflite/src/open_options.dart';

///introduce new sqlcipher methods
abstract class CipherDatabaseFactory extends DatabaseFactory {
  ///Encrypt a database
  Future<bool> encryptDatabase(String path, String password);
  ///decrypt a database
  Future<bool> decryptDatabase(String path, String password);
  ///change a database password
  Future<bool> changePassword(Database database, String newPassword);
}

///add password to options
class CipherOpenDatabaseOptions implements OpenDatabaseOptions {
  /// See [openDatabase] for details
  CipherOpenDatabaseOptions({
    this.version,
    this.onConfigure,
    this.onCreate,
    this.onUpgrade,
    this.onDowngrade,
    this.onOpen,
    this.readOnly = false,
    this.singleInstance = true,
    this.password
  });

  @override
  int? version;
  @override
  OnDatabaseConfigureFn? onConfigure;
  @override
  OnDatabaseCreateFn? onCreate;
  @override
  OnDatabaseVersionChangeFn? onUpgrade;
  @override
  OnDatabaseVersionChangeFn? onDowngrade;
  @override
  OnDatabaseOpenFn? onOpen;
  @override
  bool readOnly;
  @override
  bool singleInstance;

  ///password for sqlcipher
  String? password;
}