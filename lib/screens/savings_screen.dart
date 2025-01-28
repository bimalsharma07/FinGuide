import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/savings_service.dart';
import '../dialogs/withdrawal_dialog.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final Color primaryColor = const Color(0xFF0D1C2E);
  final Map<String, String> _savingsMessages = {
    'Dream House': 'Your dream home goal is getting closer! 🏡',
    'Education': 'Invest in your future! 📚',
    'Travel': 'Adventure awaits! ✈️',
    'Health': 'Your health is your wealth! 💖',
    'Marriage': 'Building a strong foundation! 💍',
  };

  @override
  Widget build(BuildContext context) {
    final savingsService = Provider.of<SavingsService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Savings Goals',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: primaryColor,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTotalSavingsCard(savingsService),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _buildPointsCard(savingsService),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: savingsService.savings.entries.map((entry) => 
                  _buildGoalCard(
                    entry.key,
                    savingsService.savings[entry.key]!['amount']!,
                    savingsService.savings[entry.key]!['goal']!,
                  )
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSavingsCard(SavingsService service) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.savings_rounded, size: 28, color: Color(0xFF0D1C2E)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Saved',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryColor.withOpacity(0.8),
                  ),
                ),
                Text('£${service.totalSavings.toStringAsFixed(0)}', // Use totalSavings getter
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(String category, double amount, double goal) {
    final colors = {
      'Dream House': Colors.green[400]!,
      'Education': Colors.blue[400]!,
      'Travel': Colors.orange[400]!,
      'Health': Colors.red[400]!,
      'Marriage': Colors.purple[400]!,
    };

    final icons = {
      'Dream House': Icons.home_rounded,
      'Education': Icons.school_rounded,
      'Travel': Icons.airplanemode_active_rounded,
      'Health': Icons.favorite_rounded,
      'Marriage': Icons.favorite_border_rounded,
    };

    final percentage = goal > 0 ? (amount / goal) : 0;
    final goalText = goal > 0 
        ? '£${amount.toStringAsFixed(0)} of £${goal.toStringAsFixed(0)}'
        : 'No goal set';
    final percentageText = goal > 0 
        ? '${(percentage * 100).toStringAsFixed(1)}% of goal'
        : 'Set a goal to track progress';

    return GestureDetector(
      onTap: () => _showWithdrawalDialog(category, context),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icons[category], color: colors[category], size: 28),
                  const SizedBox(width: 12),
                  Text(category,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _savingsMessages[category]!,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                goalText,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: percentage.toDouble(),
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(colors[category]!),
                minHeight: 10,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    percentageText,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '£${amount.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: colors[category]!,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWithdrawalDialog(String category, BuildContext context) {
    final savingsService = Provider.of<SavingsService>(context, listen: false);
    final currentAmount = savingsService.savings[category]!['amount']!;

    showDialog(
      context: context,
      builder: (context) => WithdrawalDialog(
        category: category,
        currentAmount: currentAmount,
        onWithdraw: (amount) {
          if (amount > currentAmount) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Sorry, you cannot withdraw more than £${currentAmount.toStringAsFixed(2)}.',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          savingsService.transferToBalance(category, amount);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Withdrawal of £${amount.toStringAsFixed(2)} successful!',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildPointsCard(SavingsService service) {
    final points = service.totalSavings / 10; // Use totalSavings getter
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome_rounded, 
              size: 30, 
              color: Colors.amber
            ),
            const SizedBox(height: 3),
            Text(
              '${points.toStringAsFixed(0)} Points',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            Text(
              'FinGuide Points',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color.fromARGB(239, 1, 7, 27),
              ),
            ),
          ],
        ),
      ),
    );
  }
}