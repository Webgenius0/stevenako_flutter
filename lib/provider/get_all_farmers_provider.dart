import 'dart:developer';

import 'package:flutter/material.dart';

class GetAllFarmersProvider extends ChangeNotifier {
  List<String> selectedFarmersIds = [];
  String? pondId;
  String? pondName;
  String? acronym;
  String? pondSize;
  String? pondUnit;
  String? pondLocation;
  String? latitude;
  String? longitude;

  // Getters functions
  String? get PondId => pondId;
  String? get PondName => pondName;
  String? get PondAcronym => acronym;
  String? get PondSize => pondSize;
  String? get PondUnit => pondUnit;
  String? get PondLocation => pondLocation;
  String? get Latitude => latitude;
  String? get Longitude => longitude;

// ------------- setter functions start-------------
  set PondId(String? pondId) {
    this.pondId = pondId;
    notifyListeners();
  }

  set PondName(String? name) {
    pondName = name;
    notifyListeners();
  }

  set Acronym(String? acronym) {
    this.acronym = acronym;
    notifyListeners();
  }

  set PondSize(String? size) {
    pondSize = size;
    notifyListeners();
  }

  set PondUnit(String? pondUnit) {
    this.pondUnit = pondUnit;
    notifyListeners();
  }

  set PondLocation(String? location) {
    pondLocation = location;
    notifyListeners();
  }

  set Latitude(String? latitude) {
    this.latitude = latitude;
    notifyListeners();
  }

  set Longitude(String? longitude) {
    this.longitude = longitude;
    notifyListeners();
  }
// ------------- Setter functions end-------------

  void addFarmerId(String farmerId) {
    log("Adding farmer ID: $selectedFarmersIds");
    if (!selectedFarmersIds.contains(farmerId)) {
      selectedFarmersIds.add(farmerId);
      notifyListeners();
    }
  }

  void removeFarmerId(String farmerId) {
    selectedFarmersIds.remove(farmerId);
    notifyListeners();
  }

  List<String> getSelectedFarmersIds() {
    return selectedFarmersIds;
  }
}
