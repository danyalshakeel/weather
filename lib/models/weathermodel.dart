// ignore_for_file: public_member_api_docs, sort_constructors_first
class WeatherModel {
  String longitude;
  String latitude;
  String temperature;
  String description;
  String humidity;
  String windSpeed;
  String pressure;
  WeatherModel({
    required this.longitude,
    required this.latitude,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      longitude: json['coord']['lon'].toString(),
      latitude: json['coord']['lat'].toString(),
      temperature: (json['main']['temp'])
          .toStringAsFixed(1), // Converting Kelvin to Celsius
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'].toString(),
      windSpeed: json['wind']['speed'].toString(),
      pressure: json['main']['pressure'].toString(),
    );
  }
}
