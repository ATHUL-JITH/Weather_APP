import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

import '../model/search_model.dart';
import '../model/weather_model.dart';
import '../services/weather_services.dart';

class WeatherController extends ChangeNotifier {
  WeatherServices weatherServices = WeatherServices();
  TextEditingController searchController = TextEditingController();
  double? latitude;
  double? longitude;
  Future<WeatherModel?> getWeather() async {
    try {
      if (latitude == null && longitude == null) {
        getCurrentLocation();
      }
      final currentWeather =
          weatherServices.getWeatherDetails(latitude, longitude);
      return currentWeather;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<List<SearchModel>> searchLocation(String name) {
    return weatherServices.getSuggestions(name);
  }

  void getCurrentLocation() async {
    Position position = await weatherServices.getCurrentLocation();
    latitude = position.latitude;
    longitude = position.longitude;
    notifyListeners();
  }

  assignLocation({lat, long}) {
    latitude = lat;
    longitude = long;
    notifyListeners();
  }

  refresh() {
    notifyListeners();
  }
}
