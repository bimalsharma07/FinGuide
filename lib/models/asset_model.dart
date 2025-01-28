import 'dart:math';

class Asset {
  final String id;
  final String type; // e.g., Home, Car, Stock, Cash
  final String name;
  final double value; // Initial value at the time of purchase
  final DateTime dateOfPurchase; // New property to track purchase date
  final DateTime dateAdded;

  Asset({
    required this.id,
    required this.type,
    required this.name,
    required this.value,
    required this.dateOfPurchase,
    required this.dateAdded,
  });

  // Calculate current value based on asset type
  double getCurrentValue() {

    if (type == 'Cash') return value; // Cash doesn't appreciate/depreciate
    
    final ageInYears = DateTime.now().difference(dateOfPurchase).inDays / 365;
    
    // Example calculation - modify with your actual business logic
    switch (type) {
      case 'Home':
        return value * pow(1.05, ageInYears); // 5% annual appreciation
      case 'Car':
        return value * pow(0.85, ageInYears); // 15% annual depreciation
      case 'Stock':
        return value * (1 + Random().nextDouble() * 0.5 - 0.25); // Random fluctuation
      default:
        return value;
  }
}
}