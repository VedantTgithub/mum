import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'homepage_citizen.dart';
import 'chatbotpage.dart';

class PdfChat extends StatefulWidget {
  @override
  _PdfChatState createState() => _PdfChatState();
}

class _PdfChatState extends State<PdfChat> {
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
          title: const Text('PDF Chat', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri('https://thisisrishi-chat-with-pdf.hf.space/'),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true,
                    supportZoom: false,
                  ),
                ),
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
                onLoadError: (controller, url, code, message) {
                  // Handle load error here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error loading PDF: $message')),
                  );
                },
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
          currentIndex: 2, // Set the selected index for the PdfChat page
          onTap: (index) {
            if (index == 0) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePageCitizen(),
                ),
              );
            } else if (index == 1) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ChatBotPage(),
                ),
              );
            } else if (index == 2) {
              // Current page, do nothing
            }
          },
        ),
      ),
    );
  }
}
