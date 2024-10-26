import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _fetchComplaints(), // Updated method name
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No complaints found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final complaints = snapshot.data!.docs;

          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                color: Colors.grey[850], // Dark grey background for the card
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        complaint['description'] ?? 'No description',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Location: ${complaint['location'] ?? 'Unknown'}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Status: ${complaint['completionStatus'] == 2 ? 'Resolved' : 'Pending'}',
                        style: TextStyle(
                          color: complaint['completionStatus'] == 2
                              ? Colors.green
                              : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<QuerySnapshot> _fetchComplaints() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    // Fetch user document to get location
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      print('User document does not exist');
      return FirebaseFirestore.instance
          .collection('complaints')
          .where('location', isEqualTo: '')
          .get(); // Return empty snapshot if user document is not found
    }

    final userLocation = userDoc['location'];
    print('User Location: $userLocation');

    final complaintsSnapshot = await FirebaseFirestore.instance
        .collection('complaints')
        .where('location', isEqualTo: userLocation) // Filter by user's location
        .get();

    print('Number of complaints found: ${complaintsSnapshot.docs.length}');

    return complaintsSnapshot;
  }
}
