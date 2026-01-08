class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;  // e.g., Food, Salary
  final bool isIncome;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.isIncome,
  });
}