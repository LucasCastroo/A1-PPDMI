import 'package:flutter/material.dart';
import 'screens/moto_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD de Motos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MotoListPage(),
    );
  }
}
