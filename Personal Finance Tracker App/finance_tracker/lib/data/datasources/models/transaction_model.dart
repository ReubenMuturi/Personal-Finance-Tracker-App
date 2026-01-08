import 'package:isar/isar.dart';
part 'transaction_model.g.dart';

@collection
class TransactionModel {
  Id isarId = Isar.autoIncrement;

  late String id;
  late String title;
  late double amount;
  late DateTime date;
  late String category;
  late bool isIncome;

  TransactionModel fromEntity(Transaction entity) {
    id = entity.id;
    title = entity.title;
    amount = entity.amount;
    date = entity.date;
    category = entity.category;
    isIncome = entity.isIncome;
    return this;
  }

  Transaction toEntity() => Transaction(
    id: id,
    title: title,
    amount: amount,
    date: date,
    category: category,
    isIncome: isIncome,
  );
}