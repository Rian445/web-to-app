import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String appName;
  final Color appBarColor; // Add appBarColor parameter

  const WebViewScreen({
    super.key,
    required this.url,
    required this.appName,
    required this.appBarColor, // Add appBarColor parameter
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  bool isPDFView = false;
  bool isHomePage = true;
  bool isLoading = true;
  bool isOffline = false;
  final CacheManager cacheManager = DefaultCacheManager();

  Future<void> _launchUrl(String urlString) async {
    try {
      if (urlString.startsWith('mailto:')) {
        final Uri emailUrl = Uri.parse(
          'https://mail.google.com/mail/?view=cm&fs=1&to=rianislam445@gmail.com'
        );
        
        if (await canLaunchUrl(emailUrl)) {
          await launchUrl(
            emailUrl,
            mode: LaunchMode.externalApplication,
          );
        } else {
          throw Exception('Could not launch email client');
        }
      } else {
        final Uri url = Uri.parse(urlString);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          throw Exception('Could not launch $url');
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open email client. Please try again.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _checkIfHomePage(String url) {
    if (mounted) {
      setState(() {
        isHomePage = url == widget.url;
      });
    }
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isOffline = connectivityResult == ConnectivityResult.none;
    });
  }

  Future<void> _loadCachedPage() async {
    try {
      final file = await cacheManager.getSingleFile(widget.url);
      if (await file.exists()) {
        final content = await file.readAsString();
        controller.loadHtmlString(content); // Load cached HTML content
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No cached content available. Please check your internet connection.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading cached page: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load cached content.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize the controller directly in initState
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('mailto:')) {
              await _launchUrl(request.url);
              return NavigationDecision.prevent;
            }
            if (request.url.toLowerCase().endsWith('.pdf')) {
              final String pdfUrl = Uri.encodeFull(request.url);
              final String googleDocsUrl = 'https://docs.google.com/viewer?url=$pdfUrl&embedded=true';
              controller.loadRequest(Uri.parse(googleDocsUrl));
              if (mounted) {
                setState(() {
                  isPDFView = true;
                  isHomePage = false;
                });
              }
              return NavigationDecision.prevent;
            }
            _checkIfHomePage(request.url);
            if (mounted) {
              setState(() {
                isPDFView = false;
              });
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) async {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
            _checkIfHomePage(url);

            if (!isOffline) {
              try {
                // Fetch the HTML content of the page
                final response = await http.get(Uri.parse(url));
                if (response.statusCode == 200) {
                  final htmlContent = response.body;

                  // Cache the HTML content
                  final file = await cacheManager.getSingleFile(url);
                  await file.writeAsString(htmlContent);
                }
              } catch (e) {
                debugPrint('Error caching page: $e');
              }
            }
          },
        ),
      );

    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isOffline = result == ConnectivityResult.none;
      });
    });

    if (isOffline) {
      _loadCachedPage();
    } else {
      controller.loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isPDFView) {
          controller.loadRequest(Uri.parse(widget.url));
          setState(() {
            isPDFView = false;
          });
          return false;
        }
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.rocket_launch, color: Colors.white),
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: widget.appBarColor, // Use user-provided color
          toolbarHeight: 40,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(
                controller: controller,
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !isHomePage
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(bottom: isPDFView ? 30 : 20),
                height: 45,
                decoration: BoxDecoration(
                  color: widget.appBarColor.withOpacity(0.9), // Match app bar color
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                      onPressed: () async {
                        if (isPDFView) {
                          setState(() {
                            isPDFView = false;
                          });
                          if (await controller.canGoBack()) {
                            controller.goBack();
                          }
                        } else if (await controller.canGoBack()) {
                          controller.goBack();
                        }
                      },
                    ),
                    Container(
                      height: 25,
                      width: 1,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    IconButton(
                      icon: Icon(Icons.home, color: Colors.white, size: 22),
                      onPressed: () {
                        setState(() {
                          isPDFView = false;
                        });
                        controller.loadRequest(Uri.parse(widget.url));
                      },
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}