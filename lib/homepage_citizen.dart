import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mumbaihacksfinal/loginpage.dart';
import 'registercomplaint.dart';
import 'profile.dart';
import 'viewall.dart';
import 'chatbotpage.dart';
import 'pdfchat.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageCitizen extends StatelessWidget {
  const HomePageCitizen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> schemes = [
      {
        'title': 'National Agriculture Market - eNAM',
        'description':
            'An online trading platform for agricultural commodities in India to help farmers with better price discovery.',
        'image': 'assets/enam.png',
        'url': 'https://enam.gov.in/web/',
      },
      {
        'title': 'Pradhan Mantri Kisan Sanman Nidhi',
        'description':
            'Income support of Rs.6,000 per year to farmer families with cultivable land.',
        'image': 'assets/kalpana-ubhe.jpg',
        'url': 'https://www.pmkisan.gov.in/',
      },
      {
        'title': 'Agricultural Pledge Loan Scheme',
        'description':
            'Get a loan against your produce stored in APMC godown to fetch higher prices.',
        'image': 'assets/pledgeLoan.jpg',
        'url': 'https://www.msamb.com/Schemes/PledgeFinance',
      },
      {
        'title': 'Export Subsidy for Agriculture Commodities',
        'description':
            'Subsidy of Rs. 50,000 per container for exporting agricultural commodities by sea route.',
        'image': 'assets/Subsidy.jpg',
        'url': 'https://www.msamb.com/Schemes/ExportScheme',
      },
      {
        'title': 'Fruit and Grain Festival Subsidy',
        'description':
            'Financial assistance for organizing festivals for selling seasonal fruits and grains directly.',
        'image': 'assets/fruit&grain.jpg',
        'url': 'https://www.msamb.com/Schemes/Fruitsandgrainfestival',
      },
      {
        'title': 'Road Transport Subsidy Scheme',
        'description':
            'Subsidy for direct sale of agricultural commodities transported by road from Maharashtra.',
        'image': 'assets/transportRoad.jpg',
        'url': 'https://www.msamb.com/Schemes/RoadTrasport',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Slider with the latest schemes
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.4,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: schemes.map((scheme) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () async {
                        final url = scheme['url']!;
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          // Use ScaffoldMessenger to show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch $url')),
                          );
                          print('Could not launch $url');
                        }
                      },
                      child: Card(
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.asset(
                                scheme['image']!,
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: double.infinity,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    scheme['title']!,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    scheme['description']!,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),

          // Register Complaint Button
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RegisterComplaintPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Register a Complaint',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),

                // Upvote Resolved Complaints Button
                const SizedBox(height: 10.0), // Add some space between buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ViewAllComplaintsPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Upvote Resolved Complaints',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
            icon: Icon(Icons.picture_as_pdf),
            label: 'PDF Chat',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
            );
          } else if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatBotPage(),
              ),
            );
          } else if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PdfChat(),
              ),
            );
          }
        },
      ),
    );
  }
}
