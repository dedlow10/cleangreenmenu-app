import 'package:flutter/material.dart';
import './screens/home_screen.dart';
import './theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Clean Menu'),
            backgroundColor: AppBarColor,
          ),
          body: HomeScreen()),
    );
  }
}
