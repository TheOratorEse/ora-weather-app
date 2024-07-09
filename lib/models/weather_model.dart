
class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final DateTime date;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.date,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
   // print('Parsing JSON: $json'); // Debug print
    
    return WeatherModel(
      cityName: json['name'] ?? 'Unknown',
      temperature: json['main']?['temp'] != null 
          ? (json['main']['temp'] as num).toDouble() 
          : 0.0,
      description: json['weather']?[0]?['description'] ?? 'No description',
      icon: json['weather']?[0]?['icon'] ?? '01d',
      date: json['dt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000)
          : DateTime.now(),
    );
  }
}