import 'package:flutter/widgets.dart';
import 'package:get/get.dart';


final class AddressProvider extends ChangeNotifier {
  String _address = "You are not logged in".tr;

  String get name => _address;

  updateName({required String address, required double lat, required double lng, bool? selectedLocation}) {
    _address = address;
   // setLocationLatLong(LatLng(lat, lng), selectedLocation: selectedLocation);
    notifyListeners();
  }
}
