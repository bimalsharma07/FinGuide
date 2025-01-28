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
    final assets = wealthService.assets; // Fetch assets
    final totalNetWorth = wealthService.totalNetWorth; // Calculate net worth

    return Scaffold(
      appBar: AppBar(title: const Text('Wealth Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNetWorthHeader(totalNetWorth),
            const SizedBox(height: 24),
            _buildAssetsListHeader(),
            const SizedBox(height: 8),
            _buildAssetsList(assets, totalNetWorth, wealthService),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddAssetDialog(context, wealthService),
      ),
    );
  }

  Widget _buildNetWorthHeader(double totalNetWorth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Net Worth', style: Theme.of(context).textTheme.bodyMedium),
        Text(
          _currencyFormat.format(totalNetWorth),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }

  Widget _buildAssetsListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Your Assets', style: Theme.of(context).textTheme.titleLarge),
        Text('Value', style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }

   Widget _buildAssetsList(
      List<Asset> assets, double totalNetWorth, WealthService wealthService) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: assets.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final asset = assets[index];
        final currentValue = asset.getCurrentValue();

        return ListTile(
          leading: _getAssetIcon(asset.type),
          title: Text(asset.name),
          subtitle: Text(
            asset.type == 'Cash' 
                ? 'Cash' 
                : '${asset.type} (Purchased: ${DateFormat('yyyy-MM-dd').format(asset.dateOfPurchase)})',
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Current: ${_currencyFormat.format(currentValue)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if(asset.type != 'Cash') Text(
                'Initial: ${_currencyFormat.format(asset.value)}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
              Text(
                'Change: ${_currencyFormat.format(currentValue - asset.value)}',
                style: TextStyle(
                  color: currentValue >= asset.value ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          onTap: () => _editAssetDialog(context, wealthService, asset, index),
        );
      },
    );
  }

  Icon _getAssetIcon(String type) {
    final icons = {
      'Home': Icons.home,
      'Car': Icons.directions_car,
      'Stock': Icons.trending_up,
      'Cash': Icons.account_balance,
    };
    return Icon(icons[type] ?? Icons.attach_money);
  }

  void _showAddAssetDialog(BuildContext context, WealthService wealthService) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: AddAssetForm(
          onAdd: (newAsset) {
            wealthService.addAsset(newAsset); // Add asset to WealthService
            Navigator.pop(context); // Close dialog
          },
        ),
      ),
    );
  }

  void _editAssetDialog(
      BuildContext context, WealthService wealthService, Asset asset, int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: EditAssetForm(
          asset: asset,
          onSave: (updatedAsset) {
            wealthService.updateAsset(index, updatedAsset); // Update asset
            Navigator.pop(context); // Close dialog
          },
        ),
      ),
    );
  }
}