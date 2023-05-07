import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tfl_project/textDemo.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void main() async {
  // init the hive
  await Hive.initFlutter();
  // open a box
  var box = await Hive.openBox('mybox');
  //bakground service
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TFL',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home:  TextDemo(),
    );
  }
}
