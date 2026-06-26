import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const FitApp());
}


class FitApp extends StatelessWidget {
  const FitApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const HomePage(title: 'Fit Feat'),
    );
  }
}