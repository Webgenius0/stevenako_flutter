import 'package:flutter/foundation.dart';

final class EmailProvider extends ChangeNotifier {
  
  String selectedCountryCode = '+1';
  String _email = " ";
  String _phone = " ";

  String get email => _email;
  String get phone => _phone;

  setEmail(String email) async {
    _email = email;
    notifyListeners();
  }

  setPhone(String phone) async {
    _phone = phone;
    notifyListeners();
  }
}
