import 'dart:ui';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F262E), // dark teal background
      appBar: AppBar(
        backgroundColor: Color(0xFF122B35).withOpacity(0.9),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF22E4AC),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile picture
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFF22E4AC), Color(0xFF00FFC3)],
                  center: Alignment(-0.2, -0.2),
                  radius: 0.9,
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
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // User info card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF122B35).withOpacity(0.6),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFF22E4AC).withOpacity(0.08),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Info
                  Text(
                    'Personal Information',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF22E4AC)),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.person, color: Color(0xFF22E4AC)),
                    title: Text('Vinudi Lakmanthee', style: TextStyle(color: Colors.white70)),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: Color(0xFF22E4AC)),
                    title: Text('0769928289', style: TextStyle(color: Colors.white70)),
                  ),
                  ListTile(
                    leading: Icon(Icons.email, color: Color(0xFF22E4AC)),
                    title: Text('vinudi.lakmanthee@gmail.com', style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Back button
            ElevatedButton.icon(
              icon: Icon(Icons.arrow_back),
              label: Text('Back to Settings'),
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Color(0xFF22E4AC),
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
