// dialogs/pay_bills_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/savings_service.dart';
import '../models/transaction.dart';

class PayBillsDialog extends StatefulWidget {
  final double balance;

  const PayBillsDialog({super.key, required this.balance});

  @override
  State<PayBillsDialog> createState() => _PayBillsDialogState();
}

class _PayBillsDialogState extends State<PayBillsDialog> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _billCategories = ['Netflix', 'SkyTV', 'Broadband'];
  late String _selectedBill;
  final TextEditingController _amountController = TextEditingController();

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) return 'Please enter amount';
    final amount = double.tryParse(value);
    if (amount == null) return 'Invalid amount format';
    if (amount <= 0) return 'Amount must be greater than 0';
    if (amount > widget.balance) return 'Amount exceeds available balance';
    return null;
  }

  @override
  void initState() {
    super.initState();
    _selectedBill = _billCategories.first;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pay Bills',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D1C2E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildBillDropdown(),
              const SizedBox(height: 15),
              _buildAmountField(),
              const SizedBox(height: 25),
              _buildActionButton('Pay', _handleSubmit),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedBill,
      items: _billCategories
          .map((bill) => DropdownMenuItem(
                value: bill,
                child: Text(bill, style: GoogleFonts.poppins(fontSize: 14)),
              ))
          .toList(),
      onChanged: (value) => setState(() => _selectedBill = value!),
      decoration: InputDecoration(
        labelText: 'Select Bill',
        labelStyle: GoogleFonts.poppins(fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: GoogleFonts.poppins(color: Colors.black87, fontSize: 14),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      decoration: InputDecoration(
        labelText: 'Amount',
        labelStyle: GoogleFonts.poppins(fontSize: 14),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 16, top: 14),
          child: Text('£', style: TextStyle(fontSize: 16)),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        errorStyle: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
      ),
      style: GoogleFonts.poppins(fontSize: 14),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
      validator: _validateAmount,
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF0D1C2E),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final savingsService = Provider.of<SavingsService>(context, listen: false);
      final enteredAmount = double.parse(_amountController.text);

      savingsService.addToBalance(-enteredAmount);
      savingsService.addTransaction(
        Transaction(
          title: 'Payment for $_selectedBill',
          amount: enteredAmount,
          date: DateTime.now(),
          isIncome: false,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment for $_selectedBill successful!',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}