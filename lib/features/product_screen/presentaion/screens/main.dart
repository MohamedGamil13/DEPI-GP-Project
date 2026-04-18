import 'package:flutter/material.dart';
import 'package:skillbridge/features/product_screen/presentaion/screens/widgets/service_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Detail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ServiceDetailScreen(),
    );
  }
}
