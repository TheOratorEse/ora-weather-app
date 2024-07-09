import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

final weatherControllerProvider = StateNotifierProvider<WeatherController, WeatherState>((ref) {
  return WeatherController(WeatherService());
});

class WeatherState {
  final WeatherModel? currentWeather;
  final List<WeatherModel> forecast;
  final bool isLoading;
  final String? error;

  WeatherState({
    this.currentWeather,
    this.forecast = const [],
    this.isLoading = false,
    this.error,
  });

  WeatherState copyWith({
    WeatherModel? currentWeather,
    List<WeatherModel>? forecast,
    bool? isLoading,
    String? error,
  }) {
    return WeatherState(
      currentWeather: currentWeather ?? this.currentWeather,
      forecast: forecast ?? this.forecast,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class WeatherController extends StateNotifier<WeatherState> {
  final WeatherService _weatherService;

  WeatherController(this._weatherService) : super(WeatherState());

  Future<void> fetchWeatherData(String city) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final currentWeather = await _weatherService.getCurrentWeather(city);
      final forecast = await _weatherService.getForecast(city);

      state = state.copyWith(
        currentWeather: currentWeather,
        forecast: forecast,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error fetching weather data: $e',
      );
    }
  }
}