import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../services/savings_service.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Color primaryColor = const Color(0xFF0D1C2E);
  final Color darkGreen = Colors.green[800]!;
  final Color darkRed = Colors.red[800]!;
  final Color scaffoldBackground = Colors.grey[50]!;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Instead of using a local _transactions list, fetch from SavingsService
    final savingsService = Provider.of<SavingsService>(context);
    final allTransactions = savingsService.transactions; 
    // This list includes everything: adding funds, paying bills, 
    // transfers to savings, etc., as long as you log them.

    return Scaffold(
      backgroundColor: scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Transaction History',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: primaryColor,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _buildTabBar(),
        ),
      ),
      body: _buildTabViews(allTransactions),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          isScrollable: false,
          labelPadding: const EdgeInsets.symmetric(horizontal: 0),
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: primaryColor.withOpacity(0.6),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: primaryColor,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          tabs: const [
            Tab(child: Text('All', textAlign: TextAlign.center)),
            Tab(child: Text('Income', textAlign: TextAlign.center)),
            Tab(child: Text('Expenses', textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabViews(List<Transaction> allTransactions) {
    // Filter for Income only
    final incomeTransactions =
        allTransactions.where((t) => t.isIncome).toList();

    // Filter for Expenses only
    final expenseTransactions =
        allTransactions.where((t) => !t.isIncome).toList();

    return TabBarView(
      controller: _tabController,
      children: [
        _buildTransactionList(allTransactions),
        _buildTransactionList(incomeTransactions),
        _buildTransactionList(expenseTransactions),
      ],
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    // If there are no transactions yet, show a placeholder
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No transactions yet',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return _buildTransactionCard(transaction);
        },
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildTypeIndicator(transaction),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('MMM dd, yyyy • hh:mm a')
                        .format(transaction.date),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  // Add + or - sign depending on isIncome
                  '${transaction.isIncome ? '+' : '-'}£${transaction.amount.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: transaction.isIncome ? darkGreen : darkRed,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: transaction.isIncome
                        ? Colors.green[50]
                        : Colors.red[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    // You can customize these status labels
                    transaction.isIncome ? 'Completed' : 'Processed',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: transaction.isIncome ? darkGreen : darkRed,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeIndicator(Transaction transaction) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: transaction.isIncome ? Colors.green[50] : Colors.red[50],
        shape: BoxShape.circle,
      ),
      child: Icon(
        transaction.isIncome
            ? Icons.arrow_upward_rounded
            : Icons.arrow_downward_rounded,
        color: transaction.isIncome ? darkGreen : darkRed,
        size: 24,
      ),
    );
  }
}