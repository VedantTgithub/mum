import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  Widget build(BuildContext context) {
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
            subtitle: Text(
              'Location: ${widget.complaintData['location'] ?? 'Unknown'}',
              style: const TextStyle(color: Colors.white70),
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
                  // Remove the resolve button
                ],
              ),
            ),
        ],
      ),
    );
  }
}
