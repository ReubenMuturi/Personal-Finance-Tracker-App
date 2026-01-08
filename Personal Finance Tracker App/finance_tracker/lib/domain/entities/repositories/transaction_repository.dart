import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(Transaction transaction);
  Stream<List<Transaction>> getTransactions();
  Future<void> deleteTransaction(String id);
}