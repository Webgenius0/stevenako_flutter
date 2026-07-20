import 'package:flutter/material.dart';

class PondProvider extends ChangeNotifier {
  int? selectedPondId;
  List<int> _selectedFarmerIds = [];

  List<int> get selectedFarmerIds => _selectedFarmerIds;

  List<int> selectedIds = [];

  void setSelectedFarmers(List<int> ids) {
    _selectedFarmerIds = ids;
    notifyListeners();
  }

  void clear() {
    _selectedFarmerIds.clear();
    notifyListeners();
  }

  void setSelectedPondName(int? pondName) {
    selectedPondId = pondName;
    notifyListeners();
  }
}
