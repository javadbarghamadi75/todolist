import 'package:flutter/material.dart';
import 'package:todolist/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        unselectedWidgetColor: Colors.white,
        fontFamily: 'Quicksand',
      ),
      home: Home(),
    );
  }
}
