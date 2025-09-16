import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/location_service.dart';
import 'services/weather_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  String? _city;
  double? _temp;
  String? _desc;
  bool _loading = false;
  String? _error;

  Future<void> _loadWeather() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final position = await _locationService.getCurrentLocation();
      final data =
          await _weatherService.fetchWeather(position.latitude, position.longitude);

      setState(() {
        _city = data['name'];
        _temp = data['main']['temp'].toDouble();
        _desc = data['weather'][0]['description'];
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather App")),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _error != null
                ? Text("Error: $_error")
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_city != null)
                        Text("City: $_city", style: const TextStyle(fontSize: 24)),
                      if (_temp != null)
                        Text("Temperature: $_temp°C", style: const TextStyle(fontSize: 24)),
                      if (_desc != null)
                        Text("Condition: $_desc", style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadWeather,
                        child: const Text("Refresh"),
                      ),
                    ],
                  ),
      ),
    );
  }
}
