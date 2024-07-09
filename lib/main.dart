import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/weather_view.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
          //    primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blueGrey,
              cardColor: Colors.teal,
              errorColor: Colors.redAccent,
              accentColor: Colors.tealAccent),
          useMaterial3: true),
      home: const WeatherView(),
    );
  }
}
