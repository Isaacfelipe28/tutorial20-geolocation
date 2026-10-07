import 'package:flutter/material.dart';

void main() {
  runApp(const KGpslocatorApp());
}

class KGpslocatorApp extends StatelessWidget {
  const KGpslocatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KGps-locator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KGPS-locator')),
      body: const Center(
        child: Text('KGPS-locator', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
