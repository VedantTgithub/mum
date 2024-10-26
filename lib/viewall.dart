import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewAllComplaintsPage extends StatelessWidget {
  ViewAllComplaintsPage({Key? key}) : super(key: key);

  final CollectionReference complaintsRef =
      FirebaseFirestore.instance.collection('complaints');

  Future<void> ensureCountFieldExists(DocumentSnapshot complaint) async {
    if (!(complaint.data() as Map<String, dynamic>).containsKey('count')) {
      await complaintsRef.doc(complaint.id).update({'count': 0});
    }
  }

  Future<bool> hasUserVoted(String complaintId, String userId) async {
    final userVoteDoc = await complaintsRef
        .doc(complaintId)
        .collection('votes')
        .doc(userId)
        .get();
    return userVoteDoc.exists;
  }

  Future<void> upvoteComplaint(String complaintId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final complaintRef = complaintsRef.doc(complaintId);

    if (await hasUserVoted(complaintId, userId)) {
      return;
    }

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final complaintSnapshot = await transaction.get(complaintRef);

      if (!complaintSnapshot.exists) {
        throw Exception("Complaint does not exist!");
      }

      await ensureCountFieldExists(complaintSnapshot);

      final currentCount = complaintSnapshot.data() != null &&
              (complaintSnapshot.data() as Map<String, dynamic>)
                  .containsKey('count')
          ? (complaintSnapshot.data() as Map<String, dynamic>)['count']
          : 0;

      final newCount = currentCount + 1;
      transaction.update(complaintRef, {'count': newCount});

      // Check if new count exceeds 5 and update completion status
      if (newCount > 5) {
        transaction.update(complaintRef, {'completionStatus': 1});
      }

      final userVoteRef = complaintRef.collection('votes').doc(userId);
      transaction.set(userVoteRef, {'voted': true});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Complaints'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: complaintsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final complaints = snapshot.data!.docs;

          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              final complaintId = complaint.id;
              final userId = FirebaseAuth.instance.currentUser!.uid;

              return FutureBuilder<bool>(
                future: hasUserVoted(complaintId, userId),
                builder: (context, snapshot) {
                  final hasVoted = snapshot.data ?? false;

                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (complaint['imageUrl'] != null)
                            Image.network(complaint['imageUrl']),
                          const SizedBox(height: 10.0),
                          Text(
                            complaint['description'] ?? '',
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Location: ${complaint['location']}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            'Completion Status: ${complaint['completionStatus'] == 1 ? 'Resolved' : 'Unresolved'}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Votes: ${complaint['count'] ?? 0}',
                            style: const TextStyle(color: Colors.blueAccent),
                          ),
                          const SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: hasVoted
                                ? null
                                : () async {
                                    await upvoteComplaint(complaintId);
                                  },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  hasVoted ? Colors.grey : Colors.blue,
                            ),
                            child: Text(
                              hasVoted ? 'Voted' : 'Upvote',
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
