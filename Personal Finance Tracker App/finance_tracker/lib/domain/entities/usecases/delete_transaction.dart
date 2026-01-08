import 'package:dartz/dartz.dart';
import '../repositories/transaction_repository.dart';
import '../../core/error/failures.dart';

class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction(this.repository);

  Future<Either<Failure, Unit>> call(String id) async {
    try {
      await repository.deleteTransaction(id);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}