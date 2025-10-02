import 'package:flutter/material.dart';
import 'package:cole20/features/auth/presentation/signin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Signup App',
      theme: ThemeData(
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SignInScreen(),
    );
  }
}
