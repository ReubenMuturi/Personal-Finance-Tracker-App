import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_datasource.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Unit>> addTransaction(Transaction transaction) async {
    try {
      await localDataSource.addTransaction(transaction);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to add transaction: ${e.toString()}'));
    }
  }

  @override
  Stream<Either<Failure, List<Transaction>>> getTransactions() {
    return localDataSource.getTransactions().map((transactions) {
      return Right<Failure, List<Transaction>>(transactions);
    }).handleError((error) {
      return Left<Failure, List<Transaction>>(CacheFailure('Stream error: ${error.toString()}'));
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteTransaction(String id) async {
    try {
      await localDataSource.deleteTransaction(id);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('Failed to delete transaction: ${e.toString()}'));
    }
  }
}