import 'package:flutter/material.dart';
import 'package:flutter_application_2/bottom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(useMaterial3: false),
      home: const DynamicBottomNavbar(),
    );
  }
}
