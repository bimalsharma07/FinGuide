import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class WithdrawalDialog extends StatefulWidget {
  final String category;
  final double currentAmount;
  final Function(double) onWithdraw;

  const WithdrawalDialog({
    super.key,
    required this.category,
    required this.currentAmount,
    required this.onWithdraw,
  });

  @override
  State<WithdrawalDialog> createState() => _WithdrawalDialogState();
}

class _WithdrawalDialogState extends State<WithdrawalDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) return 'Please enter amount';
    final amount = double.tryParse(value);
    if (amount == null) return 'Invalid amount format';
    if (amount <= 0) return 'Amount must be greater than 0';
    if (amount > widget.currentAmount) return 'Amount exceeds available balance';
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
              Text(
                'Withdraw from ${widget.category}',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D1C2E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                'Available: £${widget.currentAmount.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildAmountField(),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton('Cancel', () => Navigator.pop(context),
                        backgroundColor: Colors.grey[300]!, textColor: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildActionButton('Withdraw', _handleSubmit),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildActionButton(String text, VoidCallback onPressed,
      {Color backgroundColor = const Color(0xFF0D1C2E), Color textColor = Colors.white}) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      widget.onWithdraw(amount);
    }
  }
}