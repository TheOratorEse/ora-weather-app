import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _apiKey = 'API KEY';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<WeatherModel> getCurrentWeather(String city) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric'));
        print('API Response: ${response.body}');

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<WeatherModel>> getForecast(String city) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data['list'];

      // Filter forecast data to get one entry per day
      final Map<String, WeatherModel> dailyForecasts = {};
      for (var item in list) {
        final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        final dateString = '${date.year}-${date.month}-${date.day}';

        if (!dailyForecasts.containsKey(dateString)) {
          dailyForecasts[dateString] = WeatherModel.fromJson(item);
        }
      }

      return dailyForecasts.values.take(7).toList();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}