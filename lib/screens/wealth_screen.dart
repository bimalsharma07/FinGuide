import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 218, 222, 228),
        child: const Icon(Icons.add, color: Colors.white, size: 24),
        onPressed: () => _showAddAssetDialog(context, wealthService),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wealth Dashboard',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D1C2E),
                        fontFamily: 'DmSans',
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Net Worth',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currencyFormat.format(totalNetWorth),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Assets',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: 'DmSans',
                            ),
                          ),
                          Text(
                            'Value',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: 'DmSans',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: assets.length,
                  itemBuilder: (context, index) {
                    final asset = assets[index];
                    final currentValue = asset.getCurrentValue();
                    final change = currentValue - asset.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white.withOpacity(0.8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => _editAssetDialog(context, wealthService, asset, index),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF1F5F9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: _getAssetIcon(asset.type),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        asset.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        asset.type == 'Cash'
                                            ? 'Cash'
                                            : '${asset.type} • Purchased: ${DateFormat('yyyy-MM-dd').format(asset.dateOfPurchase)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF64748B),
                                          fontSize: 16,
                                          fontFamily: 'DmSans',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      _buildFinancialInfo(
                                        current: currentValue,
                                        initial: asset.value,
                                        change: change,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
        _buildValueRow(label: 'Current:', value: current, fontSize: 16),
        const SizedBox(height: 8),
        _buildValueRow(
          label: 'Initial:',
          value: initial,
          fontSize: 16,
          color: const Color(0xFF64748B),
        ),
        const SizedBox(height: 8),
        _buildValueRow(
          label: 'Change:',
          value: change,
          fontSize: 16,
          color: change >= 0 ? Colors.green : Colors.red,
        ),
      ],
    );
  }

  Widget _buildValueRow({
    required String label,
    required double value,
    required double fontSize,
    Color color = Colors.black,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
            fontSize: fontSize,
            fontFamily: 'DmSans',
          ),
        ),
        Text(
           label == 'Change:' 
            ? '${value >= 0 ? '+' : ''}${_currencyFormat.format(value)}'
            : _currencyFormat.format(value),
          style: TextStyle(
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
      size: 28,
    );
  }

  void _showAddAssetDialog(BuildContext context, WealthService wealthService) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: AddAssetForm(
          onAdd: (newAsset) {
            wealthService.addAsset(newAsset);
            Navigator.pop(context);
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
        child: EditAssetForm(
          asset: asset,
          onSave: (updatedAsset) {
            wealthService.updateAsset(index, updatedAsset);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
