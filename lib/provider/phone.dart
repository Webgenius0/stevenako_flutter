import 'package:flutter/foundation.dart';

final class PhoneProvider extends ChangeNotifier {
  String _phone = " ";

  String get email => _phone;

  changeemail(String phone) async {
    _phone = phone;
    notifyListeners();
  }
}
