import 'package:flutter/material.dart';

void main() => runApp(WorldRadioApp());

class WorldRadioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Radio',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: Text('World Radio')),
        body: Center(child: Text('Radio Player Coming Soon!')),
      ),
    );
  }
}
