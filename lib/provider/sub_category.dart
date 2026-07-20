import 'dart:developer';

import 'package:flutter/material.dart';

final class SubCategory extends ChangeNotifier {
  List<String> selectedSubCatList = [];

  addListOfSub(List<String> list) {
    selectedSubCatList = list;
    notifyListeners();
  }

  addSubCat(String item) {
    selectedSubCatList.add(item);
    log(selectedSubCatList.toString());
    notifyListeners();
  }

  removeSubCat(String item) {
    selectedSubCatList.remove(item);
    notifyListeners();
  }

  clearSubcat() {
    selectedSubCatList.clear();
    notifyListeners();
  }
}
