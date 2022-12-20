@TestOn('browser')
import 'package:vts_sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vts_sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_test/all_test.dart' as all;
import 'package:sqflite_common_test/sqflite_test.dart';
import 'package:test/test.dart';

var _factory = databaseFactoryFfiWebNoWebWorker;

class SqfliteFfiWebNoWebWorkerTestContext extends SqfliteLocalTestContext {
  SqfliteFfiWebNoWebWorkerTestContext() : super(databaseFactory: _factory);
}

var ffiTestContext = SqfliteFfiWebNoWebWorkerTestContext();

Future<void> main() async {
  /// Initialize ffi loader
  sqfliteFfiInit();
  // Add _no_isolate suffix to the path
  var dbsPath = await _factory.getDatabasesPath();
  await _factory.setDatabasesPath('${dbsPath}_no_web_worker');

  all.run(ffiTestContext);
}
