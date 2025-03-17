WebToApp Converter
A Flutter application that transforms websites into mobile apps with customizable features. Simply enter your web address and app name to create a fully functional mobile application.

Features
Instant Web to App Conversion: Enter any website URL and transform it into a native-looking mobile app

Customizable App Name: Personalize your app with a custom name

Status Bar Customization: Change the color and appearance of the status bar to match your brand

Navigation Bar Styling: Modify the navigation bar color for a seamless user experience

Responsive Design: Works perfectly across different screen sizes and orientations

Cross-Platform Support: Compatible with both Android and iOS devices

Installation
Ensure you have Flutter installed on your machine

Clone this repository

text
git clone https://github.com/Rian445/web-to-app.git
Navigate to the project directory

text
cd webtoapp
Install dependencies

text
flutter pub get
Run the app

text
flutter run
Usage
Launch the app

Enter your desired website URL in the input field

Provide a name for your app

Customize the status bar and navigation bar colors using the color picker

Click "Generate App" to create your web-to-app conversion

Export or share your newly created app

Status Bar and Navigation Bar Customization
The app allows you to easily customize the appearance of the status bar and navigation bar using the following methods:

Using SystemChrome
text
SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  statusBarColor: Colors.blue, // Change status bar color
  statusBarIconBrightness: Brightness.light, // Change status bar icons color
  systemNavigationBarColor: Colors.blue, // Change navigation bar color
));
Screenshots
App Home Screen
URL Input
Color Customization
Final App

Requirements
Flutter SDK: 3.0.0 or higher

Dart: 2.17.0 or higher

Android: API 21+ (Android 5.0+)

iOS: 11.0+

Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

Fork the repository

Create your feature branch (git checkout -b feature/amazing-feature)

Commit your changes (git commit -m 'Add some amazing feature')

Push to the branch (git push origin feature/amazing-feature)

Open a Pull Request