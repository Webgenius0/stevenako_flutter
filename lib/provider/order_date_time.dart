// import 'dart:developer';

// import 'package:flutter/material.dart';


// final class DateTimeProvider extends ChangeNotifier {
//   String? _selectedDate;
//   DateSlot? _selectedSlot;

//   String? get selectedDate => _selectedDate;
//   DateSlot? get selectedSlot => _selectedSlot;

//   setDeliveryDate(String date) {
//     _selectedDate = date;
//     log(_selectedDate.toString());
//     notifyListeners();
//   }

//   setTimeSlot(DateSlot seleSlot) async {
//     _selectedSlot = seleSlot;
//     log(_selectedSlot!.slotDisplay.toString());
//     notifyListeners();
//   }

//   @Deprecated("Use setTimeSlot")
//   changTimeSlot(String date, DateSlot seleSlot) async {
//     _selectedDate = date;
//     _selectedSlot = seleSlot;
//     notifyListeners();
//   }

//   orderDateTimeSlotClear() async {
//     _selectedDate = null;
//     _selectedSlot = null;
//     //notifyListeners();
//   }
// }
