import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controllers/weather_controller.dart';

final selectedCityProvider = StateProvider<String>((ref) => 'London');

class WeatherView extends ConsumerWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherControllerProvider);
    final selectedCity = ref.watch(selectedCityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ora Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_sharp),
            onPressed: () {
              _showCitySearchDialog(context, ref);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_sharp),
            onPressed: () {
              ref.read(weatherControllerProvider.notifier).fetchWeatherData(selectedCity);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Current City: $selectedCity',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: weatherState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : weatherState.error != null
                    ? Center(child: Text(weatherState.error!))
                    : weatherState.currentWeather == null
                        ? const Center(child: Text('No weather data available. Please search for a city.'))
                        : RefreshIndicator(
                            onRefresh: () async {
                              await ref.read(weatherControllerProvider.notifier).fetchWeatherData(selectedCity);
                            },
                            child: ListView(
                              children: [
                                _buildCurrentWeather(weatherState),
                                _buildForecast(weatherState),
                              ],
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  void _showCitySearchDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        String cityName = '';
        return AlertDialog(
          title: const Text('Enter City Name'),
          content: TextField(
            onChanged: (value) {
              cityName = value;
            },
            decoration: const InputDecoration(hintText: "e.g., London, New York, Tokyo"),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Search'),
              onPressed: () {
                if (cityName.isNotEmpty) {
                  ref.read(selectedCityProvider.notifier).state = cityName;
                  ref.read(weatherControllerProvider.notifier).fetchWeatherData(cityName);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurrentWeather(WeatherState state) {
    final weather = state.currentWeather;
    if (weather == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              weather.cityName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${weather.temperature.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 48),
            ),
            Text(
              weather.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              DateFormat('HH:mm').format(DateTime.now()),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecast(WeatherState state) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              '7-Day Forecast',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.forecast.length,
            itemBuilder: (context, index) {
              final day = state.forecast[index];
              return ListTile(
                leading: Image.network(
                  'http://openweathermap.org/img/w/${day.icon}.png',
                ),
                title: Text(DateFormat('EEEE').format(day.date)),
                subtitle: Text(day.description),
                trailing: Text('${day.temperature.toStringAsFixed(1)}°C'),
              );
            },
          ),
        ],
      ),
    );
  }
}