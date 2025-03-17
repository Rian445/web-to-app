import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'input_screen.dart';
import 'webview_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  final prefs = await SharedPreferences.getInstance();

  // Check if preferences exist
  final url = prefs.getString('url');
  final appName = prefs.getString('appName');
  final appBarColor = prefs.getString('appBarColor');

  runApp(MyApp(
    initialUrl: url,
    initialAppName: appName,
    initialAppBarColor: appBarColor,
  ));
}

class MyApp extends StatelessWidget {
  final String? initialUrl;
  final String? initialAppName;
  final String? initialAppBarColor;

  const MyApp({
    super.key,
    this.initialUrl,
    this.initialAppName,
    this.initialAppBarColor,
  });

  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // Add opacity if not provided
    }
    return Color(int.parse("0x$hexColor"));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dynamic WebView App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: initialUrl != null && initialAppName != null && initialAppBarColor != null
          ? WebViewScreen(
              url: initialUrl!,
              appName: initialAppName!,
              appBarColor: _parseColor(initialAppBarColor!),
            )
          : InputScreen(), // Show InputScreen if no preferences exist
    );
  }
}