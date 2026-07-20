import 'package:flutter/foundation.dart';

final class AuthProvider extends ChangeNotifier {
  int? _selectedAreaId;

  int? get selectedAreaId => _selectedAreaId;

  set selectedAreaId(int? value) {
    if (_selectedAreaId != value) {
      _selectedAreaId = value;
      notifyListeners(); // Notify UI to rebuild
    }
  }

  List<int> _selectedAreaIds2 = [];

  List<int> get selectedAreaIds2 => _selectedAreaIds2;

  void toggleSelectedAreaId(int id) {
    if (_selectedAreaIds2.contains(id)) {
      _selectedAreaIds2.remove(id);
    } else {
      _selectedAreaIds2.add(id);
    }
    notifyListeners();
  }

  void setSelectedAreaIds(List<int> ids) {
    _selectedAreaIds2 = ids;
    notifyListeners();
  }

  void clearSelectedAreaIds() {
    _selectedAreaIds2.clear();
    notifyListeners();
  }
}
