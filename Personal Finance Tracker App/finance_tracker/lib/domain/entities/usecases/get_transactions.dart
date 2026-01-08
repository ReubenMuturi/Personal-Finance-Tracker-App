import 'package:dartz/dartz.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import '../../core/error/failures.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Stream<Either<Failure, List<Transaction>>> call() {
    return repository.getTransactions().map((transactions) => Right<Failure, List<Transaction>>(transactions));
    // In case of stream errors, you can handle them here or in the provider
  }
}