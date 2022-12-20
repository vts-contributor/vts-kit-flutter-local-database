import 'package:vts_sqflite_common/sqlite_api.dart';
import 'package:vts_sqflite_common/src/batch.dart';
import 'package:vts_sqflite_common/src/constant.dart';
import 'package:vts_sqflite_common/src/database.dart';
import 'package:vts_sqflite_common/src/database_mixin.dart';

/// Transaction param, new in transaction v2
class SqfliteTransactionParam {
  /// null for no transaction
  ///
  final int? transactionId;

  /// Transaction param, new in transaction v2.
  SqfliteTransactionParam(this.transactionId);
}

/// Transaction implementation
class SqfliteTransaction
    with SqfliteDatabaseExecutorMixin
    implements Transaction {
  /// Create a transaction on a given [database]
  SqfliteTransaction(this.database);

  /// The transaction database
  final SqfliteDatabase database;

  /// Optional transaction id, depending on the implementation
  int? transactionId;

  @override
  SqfliteDatabase get db => database;

  /// True if a transaction is successfull
  bool? successful;

  @override
  SqfliteTransaction get txn => this;

  @override
  Batch batch() => SqfliteTransactionBatch(this);
}

/// Special transaction that is run even if a pending transaction is in progress.
SqfliteTransaction getForcedSqfliteTransaction(SqfliteDatabase database) =>
    SqfliteTransaction(database)..transactionId = paramTransactionIdValueForce;
