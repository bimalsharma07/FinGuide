import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCardPopup extends StatefulWidget {
  final Function(double) onAmountAdded;

  const AddCardPopup({super.key, required this.onAmountAdded});

  @override
  State<AddCardPopup> createState() => _AddCardPopupState();
}

class _AddCardPopupState extends State<AddCardPopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _cardController.dispose();
    _pinController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String? _validateCard(String? value) {
    if (value == null || value.isEmpty) return 'Card number required';
    if (value.length != 16) return '16 digits required';
    return null;
  }

  String? _validatePin(String? value) {
    if (value == null || value.isEmpty) return 'PIN required';
    if (value.length != 4) return '4 digits required';
    return null;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) return 'Amount required';
    final amount = double.tryParse(value);
    if (amount == null) return 'Invalid amount';
    if (amount < 5) return 'Minimum £5 required';
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      widget.onAmountAdded(amount);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add Funds',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D1C2E),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _cardController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  prefixIcon: const Icon(Icons.credit_card),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorStyle: GoogleFonts.poppins(color: Colors.red),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                validator: _validateCard,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _pinController,
                decoration: InputDecoration(
                  labelText: 'PIN',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorStyle: GoogleFonts.poppins(color: Colors.red),
                ),
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: _validatePin,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount (£)',
                  prefixIcon: const Icon(Icons.currency_pound),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorStyle: GoogleFonts.poppins(color: Colors.red),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: _validateAmount,
              ),
              const SizedBox(height: 25),
              FilledButton(
                onPressed: _submitForm,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1C2E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Add Amount',
                  style: GoogleFonts.poppins(
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