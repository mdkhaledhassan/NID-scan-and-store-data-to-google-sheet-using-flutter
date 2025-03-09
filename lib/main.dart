import 'package:flutter/material.dart';
import 'package:nid_data_fetch/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NID Data',
      home: HomeScreen(),
    );
  }
}
