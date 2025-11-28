import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lock_history.dart'; // Navigate after unlocking

class FingerprintUnlockPage extends StatelessWidget {
  FingerprintUnlockPage({Key? key}) : super(key: key);

  Future<void> saveUnlockAction() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection("lock_history").add({
        "action": "UNLOCK",
        "method": "fingerprint",
        "email": user.email,
        "timestamp": DateTime.now().toIso8601String(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F262E), // dark teal background
      appBar: AppBar(
        backgroundColor: Color(0xFF122B35).withOpacity(0.9),
        title: Text(
          'Fingerprint Unlock',
          style: TextStyle(
            color: Color(0xFF22E4AC), // neon text
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xFF122B35).withOpacity(0.6), // slightly darker interior
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Color(0xFF22E4AC).withOpacity(0.08), // neon border
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF22E4AC).withOpacity(0.15),
                blurRadius: 30,
                spreadRadius: 4,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fingerprint icon circle
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment(-0.2, -0.2),
                    radius: 0.9,
                    colors: [
                      Color(0xFF22E4AC),
                      Color(0xFF00FFC3),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF22E4AC).withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(120),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Center(
                      child: Icon(
                        Icons.fingerprint,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Instruction text
              Text(
                'Place your finger on the sensor',
                style: TextStyle(
                  color: Color(0xFF22E4AC), // neon text
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40),

              // Glass-style button with cursor change
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    await saveUnlockAction();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Fingerprint recognized! Lock Unlocked.'),
                        duration: Duration(seconds: 1),
                        backgroundColor: Color(0xFF22E4AC),
                      ),
                    );

                    await Future.delayed(Duration(seconds: 1));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LockHistoryPage()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF122B35).withOpacity(0.6),
                      border: Border.all(
                        color: Color(0xFF22E4AC).withOpacity(0.08),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF22E4AC).withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Simulate Fingerprint Scan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
