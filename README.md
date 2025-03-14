# Portfolio App

This Flutter app allows you to easily transform your existing portfolio website into a mobile app. If you already have a portfolio website, you can quickly turn it into a Flutter-based mobile application by following the steps below.

## Features

- Easy integration with your existing portfolio website.
- Dynamic WebView that loads your website within the app.
- Customizable app bar with your branding.
- Offline caching to ensure your portfolio is accessible even without an internet connection.
- PDF viewer integration to view any PDFs directly within the app.
- Navigation buttons for going back and returning to the homepage.

## Prerequisites

Before you start, ensure you have the following:

- [Flutter](https://flutter.dev/docs/get-started/install) installed.
- Your portfolio website (HTML/CSS/JavaScript) live and accessible.
- A text editor like [VS Code](https://code.visualstudio.com/).
- Basic understanding of Flutter and Dart.

## How to Set Up

### 1. Clone the Repository

Clone this repository to your local machine using the following command:

```bash
git clone https://github.com/Rian445/My-Portfolio-App


Set Up Your Project

Navigate to the project directory:
cd portfolio-app

3. Update the URL in main.dart

In the lib/main.dart file, replace the URL 'https://portfolio-rian-islams-projects.vercel.app/' with the URL of your own portfolio website.
url: 'https://your-portfolio-website.com',  // Replace with your website's URL

4. Customize the App Bar (Optional)

If you want to change the app’s title or the icon in the app bar, you can customize it by modifying the AppBar widget in lib/webview_screen.dart.

For example, to change the title:

title: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      "Your Portfolio", // Change this to your portfolio name
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    SizedBox(width: 8),
    Icon(Icons.rocket_launch, color: Colors.white),
  ],
),

Run the App

After making the necessary changes, you can run the app on Android or iOS using the following command:

flutter run

6. Build the App for Deployment

Once you’re happy with how the app looks, you can build the APK for Android or the app for iOS.

For Android:
flutter build apk

For iOS:
flutter build ios