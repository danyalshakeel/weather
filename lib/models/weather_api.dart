import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather10/models/weathermodel.dart';

class Weather_Api_Data_Provider extends ChangeNotifier {
  List<WeatherModel> returndata = [];
  List<WeatherModel> backupdata = [
    WeatherModel(
        longitude: "Not found",
        latitude: "0",
        humidity: "0",
        description: "Not found",
        temperature: "Not found",
        windSpeed: "0",
        pressure: "00",
        cityName: "Not found"
        ),
  ];
  bool notFound = false;

  Future<void> getapidata(String name) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$name&appid=58c135eb7b9d47a23fe1b75e60775749&units=metric"));
    if (response.statusCode == 200) {
      final apidata = json.decode(response.body);
      WeatherModel model = WeatherModel.fromJson(apidata);
      returndata.clear();

      notFound = true;
      returndata.add(model);
      notifyListeners();
    } else {
      print("notFound Setted false");
      notFound = false;
      notifyListeners();
      //throw Exception('Failed to load data');
    }
  }
}
// class Weather_Api_Provider extends ChangeNotifier {
//   List<WeatherModel> returndata = [];
//   List<WeatherModel> backupdata = [
//     WeatherModel(
//         longitude: "Not found",
//         latitude: "0",
//         humidity: "0",
//         description: "Not found",
//         temperature: "Not found",
//         windSpeed: "0",        
//         pressure: "00",
//         cityName: "Not found"
//         ),
//   ];
//   bool notFound = true;

//   Future<void> getapidata(String name) async {
//     final response = await http.get(Uri.parse(
//         "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$name?unitGroup=us&key=ZAWBWN5Q4WHQR44ZGVW5852GH"));
//     if (response.statusCode == 200) {
//       final apidata = json.decode(response.body);
//       WeatherModel model = WeatherModel.fromJson(apidata);
//       returndata.clear();

//       notFound = true;
//       returndata.add(model);
//       notifyListeners();
//     } else {
//       print("notFound Setted false");
//       notFound = false;
//       notifyListeners();
//       //throw Exception('Failed to load data');
//     }
//   }
// }
