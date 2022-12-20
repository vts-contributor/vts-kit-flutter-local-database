import 'package:meta/meta.dart';
import 'package:vts_sqflite_common/sqlite_api.dart';
import 'package:vts_sqflite_common/src/database_mixin.dart';
import 'package:vts_sqflite_common/src/factory.dart';

/// Internal access to invoke method
extension DatabaseFactoryInternalsExt on DatabaseFactory {
  /// Call invoke method manually.
  @visibleForTesting
  Future<T> internalsInvokeMethod<T>(String method, Object? arguments) async {
    return (this as SqfliteDatabaseFactory).invokeMethod<T>(method, arguments);
  }
}

/// Internal access to database configuration
extension DatabaseInternalsExt on Database {
  /// Do not use synchronized to allow concurrent access
  @visibleForTesting
  set internalsDoNotUseSynchronized(bool doNotUseSynchronized) =>
      (this as SqfliteDatabaseMixin).doNotUseSynchronized =
          doNotUseSynchronized;
}
