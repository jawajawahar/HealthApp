import 'package:flutter/material.dart';
import 'reminder_page.dart';
import 'package:untitled1/theme_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medication Reminder',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: ReminderPage(),
    );
  }
}
