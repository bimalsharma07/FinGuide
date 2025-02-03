import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PayBillsDialog extends StatefulWidget {
  final double balance;
  final Function(String, double) onBillPaid;

  const PayBillsDialog({
    super.key,
    required this.balance,
    required this.onBillPaid,
  });

  @override
  State<PayBillsDialog> createState() => _PayBillsDialogState();
}

class _PayBillsDialogState extends State<PayBillsDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  String selectedBill = 'Netflix'; // Default bill type

  // ─────────────────────────────────────────────────────────────────────────────
  // VALIDATION: Check if the entered amount is valid
  // ─────────────────────────────────────────────────────────────────────────────
  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter amount';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Invalid amount';
    }
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    if (amount > widget.balance) {
      return 'Insufficient balance';
    }
    return null;
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
              // Title
              Text(
                'Pay Bills',
                style: GoogleFonts.dmSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D1C2E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Bill Type Dropdown
              DropdownButtonFormField<String>(
                value: selectedBill,
                decoration: InputDecoration(
                  labelText: 'Bill Type',
                  labelStyle: GoogleFonts.dmSans(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                items: ['Netflix', 'Sky TV', 'Broadband']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBill = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Amount Input with Validation
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: GoogleFonts.dmSans(fontSize: 14),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 16, top: 14),
                    child: Text('£', style: TextStyle(fontSize: 16)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  errorStyle: GoogleFonts.dmSans(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
                style: GoogleFonts.dmSans(fontSize: 14),
                keyboardType: TextInputType.number,
                validator: _validateAmount, // Add validator here
              ),
              const SizedBox(height: 25),

              // Pay Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final amount = double.parse(_amountController.text);
                    widget.onBillPaid(selectedBill, amount);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1C2E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Pay',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
