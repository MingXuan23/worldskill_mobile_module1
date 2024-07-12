import 'package:flutter/material.dart';
import 'package:worldskill_module1/page/homepage.dart';

void main() {
  runApp(const MyApp(home:HomePage()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.home});
  final Widget home;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorldSkill Module',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        
      ),
      home: home
    );
  }
}
