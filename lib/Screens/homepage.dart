import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:weather10/models/weather_api.dart';
import 'package:weather10/models/weathermodel.dart';
import 'package:provider/provider.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final TextEditingController _controller = TextEditingController();

  void getData(BuildContext context) {
    final model =
        Provider.of<Weather_Api_Data_Provider>(context, listen: false);
    model.getapidata(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<Weather_Api_Data_Provider>(context);
    final futureWeatherData = weatherProvider.returndata;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          // padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Color.fromARGB(255, 1, 11, 16)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                //padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter city name',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          getData(context);
                        }),
                  ),
                  controller: _controller,
                ),
              ),
              Expanded(
                child: futureWeatherData.isEmpty
                    ? Center(
                        child:
                            Container(child: const CircularProgressIndicator()))
                    : weatherProvider.notFound == false
                        ? Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.elliptical(30, 35),
                                topRight: Radius.elliptical(30, 35),
                              ),
                              color: Colors.white,
                              // gradient: LinearGradient(
                              //   colors: [Colors.blue, Colors.lightBlueAccent],
                              //   begin: Alignment.topCenter,
                              //   end: Alignment.bottomCenter,
                              // ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'No data available. Please enter a valid city.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 2, 2, 2)),
                                ),
                                const SizedBox(height: 20),
                                ClipRRect(
                                  // borderRadius: const BorderRadius.all(
                                  //   Radius.circular(16),
                                  // ),
                                  child: Image.asset(
                                    "images/errorr.png",
                                    height: MediaQuery.of(context).size.height /
                                        2.5,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                  _controller.text.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildWeatherInfoCard(
                                  title: 'Temperature',
                                  value:
                                      '${futureWeatherData[0].temperature}°C',
                                  icon: Icons.thermostat_sharp,
                                ),
                                _buildWeatherInfoCard(
                                  title: 'Description',
                                  value: futureWeatherData[0].description,
                                  icon: Icons.cloud,
                                ),
                                _buildWeatherInfoCard(
                                  title: 'Humidity',
                                  value: '${futureWeatherData[0].humidity}%',
                                  icon: Icons.water_drop,
                                ),
                                _buildWeatherInfoCard(
                                  title: 'Wind Speed',
                                  value:
                                      '${futureWeatherData[0].windSpeed} m/s',
                                  icon: Icons.air,
                                ),
                                _buildWeatherInfoCard(
                                  title: 'Pressure',
                                  value: '${futureWeatherData[0].pressure} hPa',
                                  icon: Icons.speed,
                                ),
                              ],
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherInfoCard(
      {required String title, required String value, required IconData icon}) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: Colors.blueAccent,
              size: 28,
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
