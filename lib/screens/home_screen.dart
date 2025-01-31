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
  const HomeScreen({super.key});

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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCardPopup,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _getScreenForIndex(_selectedIndex),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // FLOATING ACTION BUTTON → Add Card Popup
  // ─────────────────────────────────────────────────────────────────────────────
  void _showAddCardPopup() {
    showDialog(
      context: context,
      builder: (context) => AddCardPopup(
        onAmountAdded: (amount) {
          final savingsService = Provider.of<SavingsService>(
            context,
            listen: false,
          );

          // 1) Update main balance
          savingsService.addToBalance(amount);

          // 2) Log this as an income transaction
          savingsService.addTransaction(
            Transaction(
              title: 'Funds Loaded',
              amount: amount,
              date: DateTime.now(),
              isIncome: true,
            ),
          );

          // 3) Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '£${amount.toStringAsFixed(2)} Loaded in your Account',
                style: GoogleFonts.dmSans(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // NAVIGATION BAR
  // ─────────────────────────────────────────────────────────────────────────────
 Widget _buildNavigationBar() {
  return Theme(
    data: Theme.of(context).copyWith(
      // Define the NavigationBar theme
      navigationBarTheme: NavigationBarThemeData(
        // Define the label text style
        labelTextStyle: MaterialStateProperty.all<TextStyle>(
          GoogleFonts.dmSans( 
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0D1C2E), 
          ),
        ),
        // Optionally, define the indicator color
        indicatorColor: primaryColor.withOpacity(0.1),
        // Optionally, define the background color
        backgroundColor: Colors.white,
      ),
    ),
    child: NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      height: 72,
      backgroundColor: Colors.white, // This can be omitted if set in theme
      elevation: 8,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, size: 26),
          selectedIcon: Icon(Icons.home_filled, size: 26),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.savings_outlined, size: 26),
          selectedIcon: Icon(Icons.savings, size: 26),
          label: 'Savings',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined, size: 26),
          selectedIcon: Icon(Icons.account_balance_wallet, size: 26),
          label: 'Transaction',
        ),
        NavigationDestination(
          icon: Icon(Icons.currency_pound_outlined, size: 26),
          selectedIcon: Icon(Icons.currency_pound, size: 26),
          label: 'Wealth',
        ),
      ],
    )
  );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SCREEN SWITCHER
  // ─────────────────────────────────────────────────────────────────────────────
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

  // ─────────────────────────────────────────────────────────────────────────────
  // HOME CONTENT
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildHomeContent() {
    final savingsService = Provider.of<SavingsService>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildBalanceCard(savingsService),
            const SizedBox(height: 24),
            _buildFinanceOverview(),
            const SizedBox(height: 24),
            _buildTransferToSavingsButton(),
            const SizedBox(height: 12),
            _buildSetGoalButton(),
            const SizedBox(height: 12),
            _buildPayBillsButton(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PAY BILLS FLOW
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildPayBillsButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.payment, color: Colors.white),
        label: Text(
          'Pay Bills',
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _showPayBillsDialog(context),
      ),
    );
  }

  void _showPayBillsDialog(BuildContext context) {
    final savingsService = Provider.of<SavingsService>(context, listen: false);

    showDialog(
      context: context,
      builder: (_) => PayBillsDialog(
        balance: savingsService.balance,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SET GOAL
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildSetGoalButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.flag, color: Colors.white),
        label: Text(
          'Set Savings Goal',
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _showSetGoalDialog(context),
      ),
    );
  }

  void _showSetGoalDialog(BuildContext context) {
    final savingsService = Provider.of<SavingsService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => SetGoalDialog(
        onGoalSet: (category, goal) {
          // No check against balance, user can set any goal
          savingsService.setSavingsGoal(category, goal);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Goal for $category set successfully!',
                style: GoogleFonts.dmSans(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TRANSFER TO SAVINGS
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildTransferToSavingsButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.savings, color: Colors.white),
        label: Text(
          'Transfer to Savings',
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _showTransferDialog(context),
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
                  style: GoogleFonts.dmSans(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // Deduct from main balance & add to chosen savings category
          savingsService.transferToSavings(category, amount);

          // Show success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '£${amount.toStringAsFixed(2)} transferred to $category!',
                style: GoogleFonts.dmSans(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HEADER (Profile avatar navigates to ProfileScreen)
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome 👋',
              style: GoogleFonts.dmSans(
                fontSize: 20,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              'Bimal',
              style: GoogleFonts.dmSans(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
          child: CircleAvatar(
            radius: 24,
            backgroundColor: primaryColor.withOpacity(0.1),
            child: Icon(Icons.account_circle, color: primaryColor, size: 38),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // BALANCE CARD
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildBalanceCard(SavingsService service) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Total Balance',
            style: GoogleFonts.dmSans(
              color: Color(0xFF0D1C2E),
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '£${service.balance.toStringAsFixed(2)}',
            style: GoogleFonts.dmSans(
              color: primaryColor,
              fontSize: 40,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.trending_up,
                  color: Colors.green.shade800,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '+2.4%',
                  style: GoogleFonts.dmSans(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // FINANCE OVERVIEW
  // ─────────────────────────────────────────────────────────────────────────────
  Widget _buildFinanceOverview() {
    return Row(
      children: [
        Expanded(
          child: _buildFinanceCard(
            title: 'Income',
            amount: '£3,000',
            color: Colors.green,
            icon: Icons.arrow_upward_rounded,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildFinanceCard(
            title: 'Expenses',
            amount: '£800',
            color: Colors.red,
            icon: Icons.arrow_downward_rounded,
          ),
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
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.dmSans(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: GoogleFonts.dmSans(
              color: primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
