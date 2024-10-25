import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePageCorporator extends StatelessWidget {
  const HomePageCorporator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> projects = [
      {
        'title': 'Road Repair Project',
        'description':
            'Ongoing road repair in Ward 12. Estimated completion in 3 months.',
      },
      {
        'title': 'Public Park Development',
        'description':
            'New park being developed in Greenfield area. Expected opening next year.',
      },
      {
        'title': 'Waste Management Initiative',
        'description':
            'Implementing new waste segregation bins across neighborhoods.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Corporator Dashboard'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Slider with ongoing civic projects
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
              items: projects.map((project) {
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
                              project['title']!,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              project['description']!,
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

          // Manage Complaints Button
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to complaint management page
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
                  'Manage Complaints',
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
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat with Citizens',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Navigate to Dashboard
          } else if (index == 1) {
            // Navigate to Chat page
          }
        },
      ),
    );
  }
}
