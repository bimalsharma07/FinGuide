import 'package:flutter/material.dart';
import 'package:flutter_application_2/dialogs/pay_bills_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/savings_service.dart';
import '../models/transaction.dart';
import '../dialogs/transfer_dialog.dart';
import '../dialogs/add_card_popup.dart';
import '../dialogs/set_goal_dialog.dart';
import 'profile_screen.dart';
import 'savings_screen.dart';
import 'transaction_screen.dart';
import 'wealth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryColor = const Color(0xFF0D1C2E);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _getScreenForIndex(_selectedIndex),
      bottomNavigationBar: _buildNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCardPopup,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 2,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavigationBar() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      backgroundColor: Colors.white,
      destinations: [
        NavigationDestination(
          icon: Icon(
            Icons.home,
            color: _selectedIndex == 0 ? primaryColor : Colors.grey,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.savings,
            color: _selectedIndex == 1 ? primaryColor : Colors.grey,
          ),
          label: 'Savings',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.receipt_long,
            color: _selectedIndex == 2 ? primaryColor : Colors.grey,
          ),
          label: 'Transactions',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.account_balance_wallet,
            color: _selectedIndex == 3 ? primaryColor : Colors.grey,
          ),
          label: 'Wealth',
        ),
      ],
    );
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const SavingsScreen();
      case 2:
        return const TransactionScreen();
      case 3:
        return WealthManagementScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    final savingsService = Provider.of<SavingsService>(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildBalanceCard(savingsService),
              const SizedBox(height: 24),
              _buildFinanceOverview(savingsService),
              const SizedBox(height: 24),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              'Bimal 👋',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProfileScreen()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 2),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.person, color: primaryColor, size: 30),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(SavingsService service) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor, primaryColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '£${service.balance.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Income and expenses section removed.
        ],
      ),
    );
  }

  Widget _buildFinanceOverview(SavingsService service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Finance Overview',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFinanceCard(
                title: 'Income',
                amount: '£${service.income.toStringAsFixed(2)}',
                color: Colors.green,
                icon: Icons.arrow_upward_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFinanceCard(
                title: 'Expenses',
                amount: '£${service.expenses.toStringAsFixed(2)}',
                color: Colors.red,
                icon: Icons.arrow_downward_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinanceCard({
    required String title,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: GoogleFonts.poppins(
              color: primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickActionButton(
              icon: Icons.savings,
              label: 'Transfer',
              onTap: () => _showTransferDialog(context),
            ),
            _buildQuickActionButton(
              icon: Icons.flag,
              label: 'Set Goal',
              onTap: () => _showSetGoalDialog(context),
            ),
            _buildQuickActionButton(
              icon: Icons.payment,
              label: 'Pay Bills',
              onTap: () => _showPayBillsDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCardPopup() {
    showDialog(
      context: context,
      builder: (context) => AddCardPopup(
        onAmountAdded: (amount) {
          final savingsService = Provider.of<SavingsService>(
            context,
            listen: false,
          );

          savingsService.addToBalance(amount);
          savingsService.addTransaction(
            Transaction(
              title: 'Funds Loaded',
              amount: amount,
              date: DateTime.now(),
              isIncome: true,
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '£${amount.toStringAsFixed(2)} Loaded in your Account',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _showTransferDialog(BuildContext context) {
    final savingsService = Provider.of<SavingsService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => TransferDialog(
        balance: savingsService.balance,
        onTransfer: (category, amount) {
          if (savingsService.balance < amount) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Transfer failed: Insufficient balance.',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          savingsService.transferToSavings(category, amount);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '£${amount.toStringAsFixed(2)} transferred to $category!',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _showSetGoalDialog(BuildContext context) {
    final savingsService = Provider.of<SavingsService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => SetGoalDialog(
        onGoalSet: (category, goal) {
          savingsService.setSavingsGoal(category, goal);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Goal for $category set successfully!',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _showPayBillsDialog(BuildContext context) {
    final savingsService = Provider.of<SavingsService>(context, listen: false);

    showDialog(
      context: context,
      builder: (_) => PayBillsDialog(
        balance: savingsService.balance,
        onBillPaid: (String billType, double amount) {
          if (savingsService.balance < amount) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Payment failed: Insufficient balance.',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          savingsService.deductFromBalance(amount);
          savingsService.addTransaction(
            Transaction(
              title: 'Bill Paid: $billType',
              amount: amount,
              date: DateTime.now(),
              isIncome: false,
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '£${amount.toStringAsFixed(2)} paid for $billType',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}
