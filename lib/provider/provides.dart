import 'dart:developer';

import 'package:flutter/material.dart';
import '/helpers/toast.dart';

final class ItemOptionIndex extends ChangeNotifier {
  int? _restaurantId;
  int? _restaurantFoodId;
  int? _optionId;
  int _optionQty = 1;
  String? _specialRequest;
  final List<Extra> _extraList = [];

  double? _optionRate;
  double _calVal = 0.0;

  int? get restaurantId => _restaurantId;
  int? get restaurantFoodId => _restaurantFoodId;
  int? get optionId => _optionId;
  int get optionQty => _optionQty;
  String? get specialRequest => _specialRequest;
  List<Extra> get extraList => _extraList;

  set resRaurantId(int id) => _restaurantId = id;
  set resFoodId(int id) => _restaurantFoodId = id;
  set specialReq(String req) => _specialRequest = req;

  double? get optionRate => _optionRate;
  double? get calVal => _calVal;

  changeOption(int i, double rate) {
    _optionId = i;
    _optionRate = rate;
    itemCalculation();
    notifyListeners();
  }

  changeOptionQtyInc() {
    _optionQty++;
    itemCalculation();
    notifyListeners();
  }

  changeOptionQtyDec() {
    if (_optionQty > 1) {
      _optionQty--;
    }
    itemCalculation();
    notifyListeners();
  }

  itemCalculation() {
    _calVal = _optionRate! * _optionQty;
    for (var extras in extraList) {
      _calVal += extras.qty * double.parse(extras.rate);
    }
  }

  addExtras(Extra ex) {
    if (extraList.length < 5 ||
        extraList.any(
          (element) => element.id == ex.id,
        )) {
      extraList.removeWhere((element) => element.id == ex.id);
      extraList.add(ex);
      itemCalculation();
      notifyListeners();
    } else {
      ToastUtil.showShortToast("Can't add more then 5 extra item");
    }
  }

  removeExtras(Extra ex) {
    extraList.removeWhere((element) => element.id == ex.id);
    itemCalculation();
    notifyListeners();
  }

  clearOption() {
    _optionQty = 1;
    _calVal = 0.0;
    _optionId = null;
    _optionRate = null;
    _restaurantId = null;
    _restaurantFoodId = null;
    _specialRequest = null;
    extraList.clear();
  }
}

class Extra {
  int id;
  String rate;
  int qty;
  Extra({
    required this.id,
    required this.qty,
    required this.rate,
  });
}

class DistanceProvider {
  double? _distance;
  double? _duration;

  double? get distance => _distance;
  double? get duration => _duration;

  set setDistance(double distance) => _distance = distance;
  set setDuration(double duration) => _duration = duration;
}

class VoucherProvider extends ChangeNotifier {
  String? _voucher;

  String? get voucher => _voucher;

  set setVoucher(String voucher) => _voucher = voucher;
}

class PlcaeMarkAddress extends ChangeNotifier {
  String? _address;
  String? _city;
  String? _state;
  String? _postalCode;
  String? _country;
  String? _lat;
  String? _lng;
  int? _id;
  bool? _isDefault;
  String? _phone;
  String? _addressName;

  String? get address => _address;
  String? get city => _city;
  String? get state => _state;
  String? get postalCode => _postalCode;
  String? get country => _country;
  String? get lat => _lat;
  String? get lng => _lng;
  int? get id => _id;
  bool? get isDefault => _isDefault;
  String? get phone => _phone;
  String? get addressName => _addressName;

  changePlcaeMarkAddress(
      {String? addres,
      String? cty,
      String? st,
      String? post,
      String? coun,
      String? lati,
      String? longi,
      int? addId,
      bool? addDefault,
      String? phn,
      String? adName}) {
    _address = addres;
    _city = cty;
    _state = st;
    _postalCode = post;
    _country = coun;
    _lat = lati;
    _lng = longi;
    _id = addId;
    _isDefault = addDefault;
    _phone = phn;
    _addressName = adName;
    log((address! + city! + state! + postalCode! + country!.toString() + lat! + lng!));
    notifyListeners();
  }

  clearPlcaeMarkAddress() {
    _address = null;
    _city = null;
    _state = null;
    _postalCode = null;
    _country = null;
    _lat = null;
    _lng = null;
    _id = null;
    _isDefault = null;
    _phone = null;
    _addressName = null;
  }
}

class GenericBool extends ChangeNotifier {
  bool? _isDefault;
  bool? get isDefault => _isDefault;

  set isDefaultId(bool id) => _isDefault = id;

  set isDefaultAddress(bool value) {
    _isDefault = value;
    notifyListeners();
  }

  isDefaultAddressClear() {
    _isDefault = null;
  }
}

class SelectedSubCat extends ChangeNotifier {
  int? _id;
  int? get id => _id;

  set subCatId(int id) => _id = id;

  set subCatID(int value) {
    _id = value;
    notifyListeners();
  }

  selectedSubCatIDClear() {
    _id = null;
  }
}

class GenericProvider extends ChangeNotifier {
  int? _productCatID;
  int? _paymentMethodID;

  int? get productCatID => _productCatID;
  int? get paymentMethodID => _paymentMethodID;

  set setProductCatID(int id) => _productCatID = id;

  set productCatId(int value) {
    _productCatID = value;
    notifyListeners();
  }

  set setpaymentMethodId(int value) {
    _paymentMethodID = value;
    notifyListeners();
  }

  selectedProductCatIDClear() {
    _productCatID = null;
  }

  paymentMethodIdClear() {
    _paymentMethodID = null;
  }
}

class GenericDi {
  String? _appVersion;
  String? _buildNo;

  String? get appVersion => _appVersion;
  String? get buildNo => _buildNo;

  set setAppVersion(String version) => _appVersion = version;
  set setBuildNo(String buildNo) => _buildNo = buildNo;
}

class CartCounter extends ChangeNotifier {
  bool showCart = true;

  set setShowCart(int value) {
    if (value == 0) {
      showCart = false;
    } else {
      showCart = true;
    }
    notifyListeners();
  }
}


class PondObservationProvider with ChangeNotifier {

  String? _observationId;
  String? _pondObservationId;

  String? get observationId => _observationId;
  String? get pondObservationId => _pondObservationId;

  void setObservationId(String? observationId) {
    _observationId = observationId;
    notifyListeners();
  }
  void setPondObservationId(String? pondObservationId) {
    _pondObservationId = pondObservationId;
    notifyListeners();
  }
}
