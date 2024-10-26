import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'homepage_citizen.dart';
import 'pdfchat.dart';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  late InAppWebViewController _webViewController;
  bool _isLoading = true; // Loading state variable

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to HomePageCitizen when the back button is pressed
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePageCitizen(),
          ),
        );
        return false; // Prevent the default back action
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat Bot',
          style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(
                    'https://mediafiles.botpress.cloud/153183a5-f0a5-42c7-9571-6919715d9b6f/webchat/bot.html',
                  ),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    _isLoading = true; // Show loading indicator
                  });
                },
                onLoadStop: (controller, url) async {
                  setState(() {
                    _isLoading = false; // Hide loading indicator
                  });
                },
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true,
                    supportZoom: false,
                  ),
                ),
              ),
              if (_isLoading) // Show loading spinner when loading
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[900],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white70,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chatbot',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.picture_as_pdf), // Icon for PDF Chat
              label: 'PDF Chat',
            ),
          ],
          currentIndex: 1, // Set the selected index for the ChatBot page
          onTap: (index) {
            if (index == 0) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePageCitizen(),
                ),
              );
            } else if (index == 1) {
              // Current page, do nothing
            } else if (index == 2) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => PdfChat(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
