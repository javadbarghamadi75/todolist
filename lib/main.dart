import 'package:flutter/material.dart';
import 'package:todolist/res.dart';
import 'package:todolist/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child,
      ),
      title: 'ToDo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        unselectedWidgetColor: colorGrey300,
        fontFamily: 'Quicksand',
      ),
      home: Home(),
    );
  }
}
