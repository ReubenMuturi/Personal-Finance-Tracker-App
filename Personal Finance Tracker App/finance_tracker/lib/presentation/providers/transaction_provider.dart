import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_transactions.dart';

// ── Providers for dependencies ──────────────────────────────────────────────

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepositoryImpl(
    ref.watch(localDataSourceProvider), // assuming you have this provider
  ),
);

final addTransactionUseCaseProvider = Provider<AddTransaction>(
  (ref) => AddTransaction(ref.watch(transactionRepositoryProvider)),
);

final getTransactionsUseCaseProvider = Provider<GetTransactions>(
  (ref) => GetTransactions(ref.watch(transactionRepositoryProvider)),
);

final deleteTransactionUseCaseProvider = Provider<DeleteTransaction>(
  (ref) => DeleteTransaction(ref.watch(transactionRepositoryProvider)),
);

// ── StreamProvider for the list of transactions ─────────────────────────────

final transactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final getTransactions = ref.watch(getTransactionsUseCaseProvider);

  return getTransactions.call().asyncMap((either) {
    return either.fold(
      (failure) => throw Exception(failure.message), // or handle differently
      (transactions) => transactions,
    );
  });
});

// Alternative: more robust version with Either in state (recommended for production)
final transactionsEitherProvider = StreamProvider<Either<Failure, List<Transaction>>>((ref) {
  final getTransactions = ref.watch(getTransactionsUseCaseProvider);
  return getTransactions.call();
});

// ── Notifier for mutations (add/delete) ─────────────────────────────────────

final transactionNotifierProvider = AsyncNotifierProvider<TransactionNotifier, void>(
  TransactionNotifier.new,
);

class TransactionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Optional: you can preload or listen to transactions here if needed
  }

  /// Add a new transaction
  Future<void> add(Transaction transaction) async {
    state = const AsyncLoading();

    final useCase = ref.read(addTransactionUseCaseProvider);
    final result = await useCase(transaction);

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }

  /// Delete an existing transaction by ID
  Future<void> delete(String id) async {
    state = const AsyncLoading();

    final useCase = ref.read(deleteTransactionUseCaseProvider);
    final result = await useCase(id);

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (_) => const AsyncData(null),
    );
  }

  /// Optional: refresh the transaction list after mutation
  Future<void> refresh() async {
    ref.invalidate(transactionsProvider);
    // or ref.invalidate(transactionsEitherProvider);
  }
}