import 'package:vts_sqflite/cipher_overrides/sqlite_api.dart';
import 'package:vts_sqflite/cipher_overrides/constant.dart';
import 'package:vts_sqflite/src/database_mixin.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../src/database.dart';

///implement cipher
class CipherSqfliteDatabaseBase extends SqfliteDatabaseBase with CipherDatabaseMixin {
  /// ctor
  CipherSqfliteDatabaseBase(SqfliteDatabaseOpenHelper openHelper, String path,
      {OpenDatabaseOptions? options}) : super(openHelper, path, options: options);
}


///add new openDatabase Method
mixin CipherDatabaseMixin on SqfliteDatabaseMixin {
  ///password for sqlcipher
  String? password;

  @override
  Future<SqfliteDatabase> doOpen(OpenDatabaseOptions options) async {
    if (options is CipherOpenDatabaseOptions) {
      password = options.password;
    }
    return super.doOpen(options);
  }

  @override
  Future<T> safeInvokeMethod<T>(String method, [arguments]) {
    //try to pass the password to native channel if possible
    if (password != null) {
      if (arguments is Map) {
        arguments.putIfAbsent(paramPassword, () => password);
      }
    }
    return super.safeInvokeMethod(method, arguments);
  }
}