import 'package:flutter/material.dart';
import '../models/transaction.dart';

class SavingsService with ChangeNotifier {
  double _balance = 2200.00;
  final List<Transaction> _transactions = [];
  final Map<String, Map<String, double>> _savings = {
    'Dream House': {'amount': 500.00, 'goal': 10000.00},
    'Education': {'amount': 300.00, 'goal': 5000.00},
    'Travel': {'amount': 200.00, 'goal': 3000.00},
    'Health': {'amount': 100.00, 'goal': 2000.00},
    'Marriage': {'amount': 50.00, 'goal': 10000.00},
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GETTERS
  // ─────────────────────────────────────────────────────────────────────────────
  double get balance => _balance;
  List<Transaction> get transactions => _transactions;
  Map<String, Map<String, double>> get savings => _savings;

  // Calculate total savings by summing amounts across all categories
  double get totalSavings {
    return _savings.values.fold(0, (sum, entry) => sum + (entry['amount'] ?? 0));
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // METHODS
  // ─────────────────────────────────────────────────────────────────────────────
  /// Increase the main balance by [amount].
  void addToBalance(double amount) {
    _balance += amount;
    notifyListeners();
  }

  /// Add a [Transaction] to the list and notify listeners.
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  /// Transfer [amount] from the main balance to the specified [category].
  /// Also logs a transaction for this transfer.
  void transferToSavings(String category, double amount) {
    if (_balance >= amount) {
      // 1. Subtract from the main balance
      _balance -= amount;

      // 2. Add to the category's savings
      _savings[category]!['amount'] =
          (_savings[category]!['amount'] ?? 0) + amount;

      // 3. Log the transfer as a transaction
      _transactions.add(
        Transaction(
          title: 'Transfer to $category',
          amount: amount,
          date: DateTime.now(),
          isIncome: false, // It's going out from the main balance
        ),
      );

      // 4. Trigger UI refresh
      notifyListeners();
    }
  }

  /// Transfer [amount] from the specified [category] back to the main balance.
  /// Also logs a transaction for this transfer.
  void transferToBalance(String category, double amount) {
    final currentAmount = _savings[category]!['amount'] ?? 0.0;
    if (currentAmount >= amount) {
      // 1. Subtract from the savings category
      _savings[category]!['amount'] = currentAmount - amount;

      // 2. Add to the main balance
      _balance += amount;

      // 3. Log the withdrawal as a transaction
      _transactions.add(
        Transaction(
          title: 'Withdrawal from $category',
          amount: amount,
          date: DateTime.now(),
          isIncome: true, // Main balance increases
        ),
      );

      // 4. Trigger UI refresh
      notifyListeners();
    }
  }

  /// Set or update the goal for the given [category].
  void setSavingsGoal(String category, double goal) {
    _savings[category]!['goal'] = goal;
    notifyListeners();
  }
}
