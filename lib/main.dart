import 'package:flutter/material.dart';
import 'pantallas/login.dart';

void main() {
  runApp(const CodiceApp());
}

class CodiceApp extends StatelessWidget {
  const CodiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Códice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
