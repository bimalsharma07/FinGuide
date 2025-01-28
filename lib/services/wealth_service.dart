// wealth_service.dart
import 'package:flutter/foundation.dart';
import '../models/asset_model.dart';

class WealthService extends ChangeNotifier {
  final List<Asset> _assets = [];

  List<Asset> get assets => _assets;

  double get totalNetWorth => _assets.fold(0, (sum, asset) => sum + asset.getCurrentValue());

  void addAsset(Asset asset) {
    _assets.add(asset);
    notifyListeners();
  }

  void updateAsset(int index, Asset newAsset) {
    _assets[index] = newAsset;
    notifyListeners();
  }
}
