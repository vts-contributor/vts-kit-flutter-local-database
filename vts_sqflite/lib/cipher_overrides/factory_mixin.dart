import 'package:sqflite_common/sqlite_api.dart';
import 'package:vts_sqflite/cipher_overrides/constant.dart';
import 'package:vts_sqflite/cipher_overrides/database_mixin.dart';
import 'package:vts_sqflite/cipher_overrides/sqlite_api.dart';

import '../src/constant.dart';
import '../src/database.dart';
import '../src/factory_mixin.dart';

///cipher
mixin CipherSqfliteDatabaseFactoryMixin on SqfliteDatabaseFactoryMixin implements CipherDatabaseFactory {
  @override
  SqfliteDatabase newDatabase(
      SqfliteDatabaseOpenHelper openHelper, String path) {
    return CipherSqfliteDatabaseBase(openHelper, path);
  }

  @override
  Future<bool> encryptDatabase(String path, String password) async {
    return await safeInvokeMethod<bool?>(methodEncryptDatabase, {
      paramPath: path,
      paramPassword: password,
    }) ?? false;
  }


  @override
  Future<bool> decryptDatabase(String path, String password) async {
    return await safeInvokeMethod<bool?>(methodDecryptDatabase, {
      paramPath: path,
      paramPassword: password,
    }) ?? false;
  }

  @override
  Future<bool> changePassword(Database database, String newPassword) async {
    return await safeInvokeMethod<bool?>(methodChangePassword, {
      paramId: (database as SqfliteDatabase).id,
      paramPassword: newPassword,
    }) ?? false;
  }
}