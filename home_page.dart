// HomePage.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import 'lock_history.dart';
import 'fingerprint_unlock_page.dart';
import 'keypad_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> saveLockAction(String action) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection("lock_history").add({
      "action": action,
      "method": "manual",
      "email": user?.email,
      "timestamp": DateTime.now().toIso8601String(),
    });
  }

  double _pressedScale = 1.0;

  void _onCardTapDown() => setState(() => _pressedScale = 0.985);
  void _onCardTapUp() => setState(() => _pressedScale = 1.0);

  Widget buildGlassCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTapDown: (_) => _onCardTapDown(),
      onTapUp: (_) {
        _onCardTapUp();
        onTap();
      },
      onTapCancel: () => _onCardTapUp(),
      child: AnimatedScale(
        scale: _pressedScale,
        duration: Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          height: 110,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF22E4AC).withOpacity(0.12),
                        blurRadius: 30,
                        spreadRadius: 4,
                        offset: Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Color(0xFF00FFC3).withOpacity(0.05),
                        blurRadius: 6,
                        spreadRadius: 0,
                        offset: Offset(-6, -6),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: Color(0xFF122B35).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color(0xFF22E4AC).withOpacity(0.08),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                center: Alignment(-0.3, -0.3),
                                radius: 0.9,
                                colors: [
                                  Color(0xFF22E4AC),
                                  Color(0xFF00FFC3),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF22E4AC).withOpacity(0.25),
                                  blurRadius: 18,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(icon, color: Colors.white, size: 30),
                          ),
                          SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    color: Color(0xFF22E4AC).withOpacity(0.95),
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Color(0xFF22E4AC).withOpacity(0.85)),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Smart Lock Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Welcome, ${user?.email ?? 'User'}",
                  style: TextStyle(
                    color: Color(0xFF22E4AC),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0xFF122B35).withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF22E4AC).withOpacity(0.08)),
              ),
              child: Icon(Icons.logout, color: Color(0xFF22E4AC)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;
    final crossAxisCount = isWide ? 2 : 1;
    final horizontalPadding = isWide ? 28.0 : 20.0;

    final List<Widget> cards = [
      buildGlassCard(
        icon: Icons.lock,
        title: "Lock",
        subtitle: "Secure your door instantly",
        onTap: () async {
          await saveLockAction("LOCK");
          Navigator.push(context, MaterialPageRoute(builder: (_) => LockHistoryPage()));
        },
      ),
      buildGlassCard(
        icon: Icons.lock_open,
        title: "Unlock",
        subtitle: "Open using manual control",
        onTap: () async {
          await saveLockAction("UNLOCK");
          Navigator.push(context, MaterialPageRoute(builder: (_) => LockHistoryPage()));
        },
      ),
      buildGlassCard(
        icon: Icons.fingerprint,
        title: "Fingerprint Unlock",
        subtitle: "Unlock using biometric authentication",
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => FingerprintUnlockPage()));
        },
      ),
      buildGlassCard(
        icon: Icons.dialpad,
        title: "Keypad",
        subtitle: "Enter PIN to unlock",
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => KeypadPage()));
        },
      ),
      buildGlassCard(
        icon: Icons.settings,
        title: "Settings",
        subtitle: "Configure lock systems",
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage()));
        },
      ),
      buildGlassCard(
        icon: Icons.history,
        title: "Lock History",
        subtitle: "View all lock/unlock records",
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => LockHistoryPage()));
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Color(0xFF0F262E),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 18),
          child: Column(
            children: [
              buildHeader(context),
              // Removed the search bar here
              Expanded(
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 8,
                    childAspectRatio: isWide ? 4.8 : 3.9,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return cards[index];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
