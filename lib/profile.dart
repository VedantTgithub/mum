import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile - Complaints',
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No complaints registered.',
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
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location: ${widget.complaintData['location'] ?? 'Unknown'}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Status: ${widget.complaintData['completionStatus'] == 1 ? 'Completed' : 'Pending'}',
                  style: TextStyle(
                    color: widget.complaintData['completionStatus'] == 1
                        ? Colors.green
                        : Colors.red,
                  ),
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
                ],
              ),
            ),
        ],
      ),
    );
  }
}
