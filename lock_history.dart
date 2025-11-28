import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// --- Color and Style Constants from LoginPage ---
const Color _neonGreen = Color(0xFF22E4AC);
const Color _darkBackground = Color(0xFF0F262E);
const Color _appBarBackground = Color(0xFF122B35);
const Color _textWhite = Colors.white;
const Color _redFailure = Color(0xFFFF5252); // Accent for failed attempts
// ------------------------------------------------

class LockHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBackground, // Set dark background
      appBar: AppBar(
        title: Text(
          'Lock History',
          style: TextStyle(color: _neonGreen, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _appBarBackground, // Dark AppBar color
        iconTheme: IconThemeData(color: _neonGreen), // Back button color
        elevation: 10, // Add slight elevation for depth
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lock_history')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: _neonGreen), // Neon loading indicator
            );
          }
          
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No lock history found.',
                style: TextStyle(color: _neonGreen.withOpacity(0.7), fontSize: 18),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final timestamp = data['timestamp'] != null
                  ? data['timestamp'] as String
                  : 'Unknown';
              final action = data['action'] as String? ?? 'N/A';
              
              // Determine color based on action
              final bool isSuccess = action.contains('UNLOCK') && !action.contains('FAILED');
              final Color actionColor = isSuccess ? _neonGreen : _redFailure;
              final IconData actionIcon = isSuccess ? Icons.lock_open : Icons.lock;


              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _appBarBackground, // Darker container background
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: actionColor.withOpacity(0.15), // Subtle glow based on status
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                    border: Border.all(color: actionColor.withOpacity(0.5), width: 1.5),
                  ),
                  child: ListTile(
                    leading: Icon(
                      actionIcon,
                      color: actionColor,
                      size: 30,
                    ),
                    title: Text(
                      "${action} via ${data['method']}",
                      style: TextStyle(
                        color: actionColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "User: ${data['email']}\nTime: ${timestamp.substring(0, 10)} ${timestamp.substring(11, 19)}",
                      style: TextStyle(color: _textWhite.withOpacity(0.7)),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: _textWhite.withOpacity(0.5),
                      size: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}