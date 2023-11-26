import 'package:flutter/material.dart';
import 'package:park_smart/home_screen.dart';

void main() {
  runApp(MyApp(key: UniqueKey())); 
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

