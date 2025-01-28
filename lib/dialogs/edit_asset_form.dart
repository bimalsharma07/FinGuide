import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/asset_model.dart';

class EditAssetForm extends StatefulWidget {
  final Asset asset;
  final Function(Asset) onSave;

  const EditAssetForm({required this.asset, required this.onSave, super.key});

  @override
  State<EditAssetForm> createState() => _EditAssetFormState();
}

class _EditAssetFormState extends State<EditAssetForm> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late String _name;
  late double _value;
  late DateTime _dateOfPurchase;
  late Asset _originalAsset;

  @override
  void initState() {
    super.initState();
    _originalAsset = widget.asset;
    _type = widget.asset.type;
    _name = widget.asset.name;
    _value = widget.asset.value;
    _dateOfPurchase = widget.asset.dateOfPurchase;
  }

  bool get _hasChanges =>
      _type != _originalAsset.type ||
      _name != _originalAsset.name ||
      _value != _originalAsset.value ||
      _dateOfPurchase != _originalAsset.dateOfPurchase;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Edit Asset',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1C2E),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                _buildTypeDropdown(),
                const SizedBox(height: 20),
                _buildNameField(),
                const SizedBox(height: 20),
                _buildValueField(),
                if (_type != 'Cash') const SizedBox(height: 20),
                if (_type != 'Cash') _buildDatePicker(),
                const SizedBox(height: 30),
                _buildButtonRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _type,
      items: ['Home', 'Car', 'Stock', 'Cash']
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type, style: GoogleFonts.poppins(fontSize: 15)),
              ))
          .toList(),
      onChanged: (value) => setState(() {
        _type = value!;
        if (_type == 'Cash') {
          _dateOfPurchase = DateTime.now();
        }
      }),
      decoration: InputDecoration(
        labelText: 'Asset Type',
        labelStyle: GoogleFonts.poppins(fontSize: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
      style: GoogleFonts.poppins(color: Colors.black87, fontSize: 15),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(
        labelText: 'Asset Name',
        labelStyle: GoogleFonts.poppins(fontSize: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        errorStyle: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
      ),
      style: GoogleFonts.poppins(fontSize: 15),
      onChanged: (value) => setState(() => _name = value),
      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
    );
  }

  Widget _buildValueField() {
    return TextFormField(
      initialValue: _value.toStringAsFixed(2),
      decoration: InputDecoration(
        labelText: 'Value (£)',
        labelStyle: GoogleFonts.poppins(fontSize: 15),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 18, top: 16),
          child: Text('£', style: TextStyle(fontSize: 17)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        errorStyle: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
      ),
      style: GoogleFonts.poppins(fontSize: 15),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
      onChanged: (value) => setState(() => _value = double.tryParse(value) ?? 0.0),
      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _selectDate,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Purchase Date',
              labelStyle: GoogleFonts.poppins(fontSize: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              errorStyle: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd').format(_dateOfPurchase),
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                const Icon(Icons.calendar_today, size: 22),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonRow() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            'Cancel',
            () => Navigator.pop(context),
            backgroundColor: Colors.grey[300]!,
            textColor: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            'Save Changes',
            _hasChanges ? _handleSubmit : null,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, VoidCallback? onPressed,
    {Color backgroundColor = const Color(0xFF0D1C2E),
    Color textColor = Colors.white}) {
  return FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center, // Ensures text is centered
      style: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    ),
  );
}


  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dateOfPurchase,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() => _dateOfPurchase = selectedDate);
    }
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

  final updatedAsset = Asset(
    id: widget.asset.id,
    type: _type,
    name: _name,
    value: _value,
    dateOfPurchase: _type == 'Cash' ? DateTime.now() : _dateOfPurchase,
    dateAdded: widget.asset.dateAdded,
  );

  widget.onSave(updatedAsset);
  }
}