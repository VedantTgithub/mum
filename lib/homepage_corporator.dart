import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'loginpage.dart'; // Import the login page
import 'profile_corp.dart'; // Import the profile page

class HomePageCorporator extends StatefulWidget {
  @override
  _HomePageCorporatorState createState() => _HomePageCorporatorState();
}

class _HomePageCorporatorState extends State<HomePageCorporator> {
  late String? corporatorLocation;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCorporatorLocation();
  }

  Future<void> _fetchCorporatorLocation() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      setState(() {
        corporatorLocation = userDoc['location'];
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut(); // Sign out from Firebase
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Redirect to LoginPage
    );
  }

  void _navigateToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProfilePage(), // Navigate to ProfilePage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Corporator - Complaints',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white), // Logout icon
            onPressed: _logout, // Call logout function on press
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('complaints')
                  .where('completionStatus', isEqualTo: 0)
                  .where('location', isEqualTo: corporatorLocation)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No complaints available.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final complaints = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = complaints[index];
                    return ComplaintCard(complaintData: complaint);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToProfile, // Navigate to profile page on press
        child: const Icon(Icons.person), // Profile icon
        backgroundColor: Colors.blue, // Set your preferred color
      ),
    );
  }
}

class ComplaintCard extends StatefulWidget {
  final QueryDocumentSnapshot complaintData;

  ComplaintCard({required this.complaintData});

  @override
  _ComplaintCardState createState() => _ComplaintCardState();
}

class _ComplaintCardState extends State<ComplaintCard> {
  bool isExpanded = false;
  bool isUpvoted = false; // Track if the complaint has already been upvoted
  String? proofImageUrl; // Image URL will be set after upload

  Future<void> _uploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera, // Open camera to capture image
    );

    if (image != null) {
      // Get the image file
      File file = File(image.path);

      try {
        // Create a reference to Firebase Storage
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        // Upload the file
        await storageRef.putFile(file);

        // Get the download URL
        proofImageUrl = await storageRef.getDownloadURL();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image proof uploaded successfully!')),
        );

        // Enable the submit button after upload
        setState(() {});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected!')),
      );
    }
  }

  Future<void> _submitForUpvoting() async {
    final complaintRef = FirebaseFirestore.instance
        .collection('complaints')
        .doc(widget.complaintData.id);

    if (!isUpvoted && proofImageUrl != null) {
      try {
        // Update the complaint with new fields
        await complaintRef.update({
          'count': FieldValue.increment(1),
          'completionStatus': 1, // Update to under review
          'imageUrl': proofImageUrl, // Save uploaded image URL
        });

        final complaintDoc = await complaintRef.get();
        if (complaintDoc.exists && complaintDoc['count'] >= 5) {
          await complaintRef.update(
              {'completionStatus': 2}); // Mark as resolved if count >= 5
        }

        setState(() {
          isUpvoted = true; // Mark as upvoted
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Submitted for upvote!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else if (proofImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload image proof first!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Already submitted for upvote!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.complaintData['completionStatus'] == 0
        ? 'Pending'
        : widget.complaintData['completionStatus'] == 1
            ? 'Under Review'
            : 'Resolved';

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.complaintData['description'] ?? 'No description',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location: ${widget.complaintData['location'] ?? 'Unknown'}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Status: $status',
                  style: const TextStyle(color: Colors.greenAccent),
                ),
                Text(
                  'Upvotes: ${widget.complaintData['count'] ?? 0}',
                  style: const TextStyle(color: Colors.orangeAccent),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description: ${widget.complaintData['description']}',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  if (widget.complaintData['imageUrl'] != null)
                    Image.network(
                      widget.complaintData['imageUrl'],
                      height: 200,
                    ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _uploadImage,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                    child: const Text('Upload Image Proof'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed:
                        proofImageUrl != null ? _submitForUpvoting : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                    child: const Text('Submit for Upvoting'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
