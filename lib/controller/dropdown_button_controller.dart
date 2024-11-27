import 'package:flutter/widgets.dart';

class DropDownButtonController extends ChangeNotifier {
  // ForecastController forecastController = ForecastController();
  int initial = 0;
  int setDropdownValue(
      {required DateTime date, required DateTime currentTime}) {
    int index = date.day - currentTime.day;
    return index;
  }

  toggleMenuButton(value) {
    initial = value;
    notifyListeners();
  }
}
