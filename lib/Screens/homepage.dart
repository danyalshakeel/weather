import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather10/models/weather_api.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  const GlassContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _search() {
    final city = _cityController.text.trim();
    if (city.isEmpty) return;
    Provider.of<Weather_Api_Data_Provider>(context, listen: false)
        .getapidata(city);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Weather_Api_Data_Provider>(context);
    final data = provider.returndata;
    final isFound = provider.notFound;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('🌤️ Weather Forecast',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 9, 26, 87), Color.fromARGB(255, 32, 85, 128)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnim,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(30),
                      shadowColor: Colors.black26,
                      child: TextField(
                        controller: _cityController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _search(),
                        decoration: InputDecoration(
                          hintText: '🔍 Enter city name...',
                          prefixIcon: const Icon(Icons.search, color: Colors.black87),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send, color: Colors.black87),
                            onPressed: _search,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (data.isEmpty && isFound)
                      const Expanded(
                        child: Center(
                          child: Text(
                            '🔍 Search to see weather data',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      )
                    else if (!isFound)
                      const Expanded(
                        child: Center(
                          child: Text(
                            '❌ City not found',
                            style: TextStyle(color: Colors.redAccent, fontSize: 16),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              GlassContainer(
                                height: 320,
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      data[0].description.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      data[0].cityName.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: [
                                        _weatherInfoTile(
                                          icon: Icons.thermostat,
                                          label: 'Temperature',
                                          value: "${data[0].temperature}°C",
                                        ),
                                        _weatherInfoTile(
                                          icon: Icons.cloud,
                                          label: 'Humidity',
                                          value: data[0].humidity,
                                        ),
                                        _weatherInfoTile(
                                          icon: Icons.air,
                                          label: 'Wind Speed',
                                          value: data[0].windSpeed,
                                        ),
                                        _weatherInfoTile(
                                          icon: Icons.speed,
                                          label: 'Pressure',
                                          value: data[0].pressure,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return GlassContainer(
      width: 140,
      height: 120,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
