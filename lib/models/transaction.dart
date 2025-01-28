// Add this line/ lib/models/transaction.dart
class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}