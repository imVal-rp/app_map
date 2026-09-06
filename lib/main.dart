import 'package:flutter/material.dart';

import 'features/map/presentation/screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'App Map',
      home: MapScreen(),
    );
  }
}