import 'package:isar/isar.dart';
import '../models/transaction_model.dart';
import '../../domain/entities/transaction.dart';

abstract class TransactionLocalDataSource {
  Future<void> addTransaction(Transaction transaction);
  Stream<List<Transaction>> getTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Isar isar;

  TransactionLocalDataSourceImpl(this.isar);

  @override
  Future<void> addTransaction(Transaction transaction) async {
    final model = TransactionModel()
      ..id = transaction.id
      ..title = transaction.title
      ..amount = transaction.amount
      ..date = transaction.date
      ..category = transaction.category
      ..isIncome = transaction.isIncome;

    await isar.writeTxn(() async {
      await isar.transactionModels.put(model);
    });
  }

  @override
  Stream<List<Transaction>> getTransactions() {
    return isar.transactionModels
        .where()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toEntity()).toList()
          ..sort((a, b) => b.date.compareTo(a.date)));
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await isar.writeTxn(() async {
      final toDelete = await isar.transactionModels.filter().idEqualTo(id).findFirst();
      if (toDelete != null) {
        await isar.transactionModels.delete(toDelete.isarId);
      }
    });
  }
}