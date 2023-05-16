import 'package:flutter/material.dart';

class MainPageScreen extends StatefulWidget {
  const MainPageScreen({super.key});

  @override
  _MainPageScreenState createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
        ));
  }
}
