import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'change_pin_page.dart';
import 'profile_page.dart'; 
import 'about_page.dart';   

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  Widget _buildOptionCard(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 200),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.translate(
                offset: Offset(0, 0),
                child: Container(
                  height: 120,
                  margin: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFF22E4AC).withOpacity(0.4),
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.1)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF22E4AC).withOpacity(0.2),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, color: Color(0xFF22E4AC), size: 40),
                          SizedBox(height: 10),
                          Text(title, style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F262E),
      appBar: AppBar(
        backgroundColor: Color(0xFF122B35).withOpacity(0.9),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF22E4AC),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            // Smart Bike Lock icon below AppBar
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF22E4AC).withOpacity(0.6),
                  width: 2,
                ),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF22E4AC).withOpacity(0.2),
                    Color(0xFF22E4AC).withOpacity(0.05)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF22E4AC).withOpacity(0.4),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.smart_toy, color: Color(0xFF22E4AC), size: 60),
            ),

            // Options row
            Row(
              children: [
                _buildOptionCard(
                  context, 
                  Icons.lock, 
                  'Change PIN', 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChangePinPage())),
                ),
                _buildOptionCard(
                  context, 
                  Icons.person, 
                  'Profile', 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage())),
                ),
                _buildOptionCard(
                  context, 
                  Icons.info, 
                  'About', 
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => AboutPage())),
                ),
              ],
            ),

            SizedBox(height: 40),

            // Back button with neon/glass style
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Color(0xFF22E4AC), width: 2),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.white.withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF22E4AC).withOpacity(0.4),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, color: Color(0xFF22E4AC)),
                      SizedBox(width: 10),
                      Text(
                        'Back to Home',
                        style: TextStyle(
                          color: Color(0xFF22E4AC),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
