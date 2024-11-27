import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../model/forecast_weather_model.dart';
import '../model/search_model.dart';
import '../model/weather_model.dart';

class WeatherServices extends ChangeNotifier {
  List<SearchModel> searchResult = [];
  final String APIKEY = "e17b7946bad84e9881752724232610";
  late String baseUrl =
      "http://api.weatherapi.com/v1/current.json?key=$APIKEY&q=";
  late String forecastUrl =
      "http://api.weatherapi.com/v1/forecast.json?key=$APIKEY&q=";
  // 11.2479457,75.8337171&days=1&aqi=no&alerts=no
  late String searchUrl =
      "http://api.weatherapi.com/v1/search.json?key=$APIKEY&q=";

  Future<WeatherModel?> getWeatherDetails(latitude, longitude) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl$latitude,$longitude&aqi=no'));
      var data = jsonDecode(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return WeatherModel.fromJson(data);
      } else {
        return WeatherModel.fromJson(data);
      }
    } catch (e) {
      log("error ${e.toString()}");
      return null;
    }
  }

  Future<List<SearchModel>> getSuggestions(String query) async {
    searchResult.clear();
    try {
      final response = await http.get(Uri.parse("$searchUrl$query"));
      var data = jsonDecode(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        for (var i in data) {
          searchResult.add(SearchModel.fromJson(i));
        }
        return searchResult;
      } else {
        return searchResult;
      }
    } catch (e) {
      log(e.toString());
      return searchResult;
    }
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<ForeCastWeatherModel?> getForecastWeather(
      {latitude, longitude, date}) async {
    try {
      final response = await http.get(Uri.parse(
          '$forecastUrl$latitude,$longitude&days=$date&aqi=no&alerts=no'));
      var data = jsonDecode(response.body.toString());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ForeCastWeatherModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      log("error forecast ${e.toString()}");
      return null;
    }
  }
}
