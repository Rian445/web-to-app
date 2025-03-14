import 'package:flutter/material.dart';
import 'webview_screen.dart'; 



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RIAN'S PORTFOLIO",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebViewScreen(
        url: 'https://portfolio-rian-islams-projects.vercel.app/',
      ),
    );
  }
}
