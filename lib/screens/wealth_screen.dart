import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/wealth_service.dart';
import '../models/asset_model.dart';
import '../dialogs/add_asset_form.dart';
import '../dialogs/edit_asset_form.dart';

class WealthManagementScreen extends StatefulWidget {
  const WealthManagementScreen({super.key});

  @override
  State<WealthManagementScreen> createState() => _WealthManagementScreenState();
}

class _WealthManagementScreenState extends State<WealthManagementScreen> {
  final _currencyFormat = NumberFormat.currency(symbol: '£', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    final wealthService = Provider.of<WealthService>(context);
    final assets = wealthService.assets;
    final totalNetWorth = wealthService.totalNetWorth;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D1C2E),
        child: const Icon(Icons.add, color: Colors.white, size: 24),
        onPressed: () => _showAddAssetDialog(context, wealthService),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wealth Dashboard',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D1C2E),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildNetWorthCard(totalNetWorth),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Assets',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0D1C2E),
                        ),
                      ),
                      Text(
                        'Value',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0D1C2E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: assets.length,
                itemBuilder: (context, index) {
                  final asset = assets[index];
                  return _buildAssetCard(context, wealthService, asset, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetWorthCard(double totalNetWorth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1C2E), Color(0xFF1E3A5F)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Net Worth',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currencyFormat.format(totalNetWorth),
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard(BuildContext context, WealthService wealthService, Asset asset, int index) {
    final currentValue = asset.getCurrentValue();
    final change = currentValue - asset.value;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _editAssetDialog(context, wealthService, asset, index),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _getAssetIcon(asset.type),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            asset.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0D1C2E),
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            asset.type == 'Cash'
                                ? 'Cash'
                                : '${asset.type} • Purchased: ${DateFormat('yyyy-MM-dd').format(asset.dateOfPurchase)}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildFinancialInfo(
                  current: currentValue,
                  initial: asset.value,
                  change: change,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialInfo({
    required double current,
    required double initial,
    required double change,
  }) {
    return Column(
      children: [
        _buildValueRow(label: 'Current:', value: current, fontSize: 14),
        const SizedBox(height: 8),
        _buildValueRow(
          label: 'Initial:',
          value: initial,
          fontSize: 14,
          color: const Color(0xFF64748B),
        ),
        const SizedBox(height: 8),
        _buildValueRow(
          label: 'Change:',
          value: change,
          fontSize: 14,
          color: change >= 0 ? Colors.green : Colors.red,
        ),
      ],
    );
  }

  Widget _buildValueRow({
    required String label,
    required double value,
    required double fontSize,
    Color color = const Color(0xFF0D1C2E),
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
            fontSize: fontSize,
          ),
        ),
        Text(
          label == 'Change:'
              ? '${value >= 0 ? '+' : ''}${_currencyFormat.format(value)}'
              : _currencyFormat.format(value),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: color,
            fontSize: fontSize + 2,
          ),
        ),
      ],
    );
  }

  Icon _getAssetIcon(String type) {
    final icons = {
      'Home': Icons.home,
      'Car': Icons.directions_car,
      'Stock': Icons.trending_up,
      'Cash': Icons.account_balance,
    };
    return Icon(
      icons[type] ?? Icons.attach_money,
      color: const Color(0xFF475569),
      size: 24,
    );
  }

  void _showAddAssetDialog(BuildContext context, WealthService wealthService) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: AddAssetForm(
          onAdd: (newAsset) {
            wealthService.addAsset(newAsset);
            Navigator.pop(context);

            // Show Toast when Asset is added
            Fluttertoast.showToast(
              msg: 'Asset added successfully!',
              backgroundColor: const Color(0xFF0D1C2E),
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          },
        ),
      ),
    );
  }

  void _editAssetDialog(
    BuildContext context,
    WealthService wealthService,
    Asset asset,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: EditAssetForm(
          asset: asset,
          onSave: (updatedAsset) {
            wealthService.updateAsset(index, updatedAsset);
            Navigator.pop(context);

            // Show Toast when Asset is edited
            Fluttertoast.showToast(
              msg: 'Asset updated successfully!',
              backgroundColor: const Color(0xFF0D1C2E),
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          },
        ),
      ),
    );
  }
}
