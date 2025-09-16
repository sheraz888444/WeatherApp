import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final apiKey = dotenv.env['API_KEY'];
    final url = Uri.parse("$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch weather data");
    }
  }
}
