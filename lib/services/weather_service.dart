import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final apiKey = dotenv.env['API_KEY'];
    final url = Uri.parse("$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric");

    print("Requesting weather data from URL: $url");

    final response = await http.get(url);

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Throw detailed error message for debugging
      throw Exception("Failed to fetch weather data: ${response.statusCode} - ${response.body}");
    }
  }
}
