import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mumbaihacksfinal/loginpage.dart';
import 'registercomplaint.dart'; // Import the Register Complaint page
import 'profile.dart'; // Import the Profile Page

class HomePageCitizen extends StatelessWidget {
  const HomePageCitizen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> schemes = [
      {
        'title': 'Healthcare Assistance Program',
        'description':
            'Free or subsidized medical treatment for low-income families in community hospitals.',
      },
      {
        'title': 'Clean Neighborhood Initiative',
        'description':
            'Monthly sanitation drives and waste management support to keep neighborhoods clean.',
      },
      {
        'title': 'Employment Training Scheme',
        'description':
            'Skill development workshops and job placement support for unemployed youth.',
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
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Sign out from Firebase

              // Navigate to Login page
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        LoginPage()), // Adjust for your LoginPage
                (route) => false, // Remove all previous routes
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
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
                    return Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
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
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to complaint registration page
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
        ],
        onTap: (index) {
          if (index == 0) {
            // Navigate to Profile page
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(), // Adjust for your ProfilePage
              ),
            );
          } else if (index == 1) {
            // Implement navigation to Chatbot page if available
          }
        },
      ),
    );
  }
}
