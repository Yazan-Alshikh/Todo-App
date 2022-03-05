import 'package:flutter/material.dart';
import 'package:todoapp/screen/layout_screen.dart';
import 'package:bloc/bloc.dart';

import 'bloc/observer_class.dart';

void main() {

  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoApp(),
    );
  }
}
