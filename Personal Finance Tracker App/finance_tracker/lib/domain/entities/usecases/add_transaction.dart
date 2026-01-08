import 'package:dartz/dartz.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import '../../core/error/failures.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  Future<Either<Failure, Unit>> call(Transaction transaction) async {
    try {
      await repository.addTransaction(transaction);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}