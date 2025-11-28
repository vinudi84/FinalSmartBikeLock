import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lock_history.dart'; // Navigate after unlocking

// --- Color and Style Constants from LoginPage ---
const Color _neonGreen = Color(0xFF22E4AC);
const Color _darkBackground = Color(0xFF0F262E);
const Color _keypadBackground = Color(0xFF122B35);
const Color _lightNeonGreen = Color(0xFF00FFC3);
// ------------------------------------------------

class KeypadPage extends StatefulWidget {
  const KeypadPage({Key? key}) : super(key: key);

  @override
  _KeypadPageState createState() => _KeypadPageState();
}

class _KeypadPageState extends State<KeypadPage> {
  String enteredPin = '';
  static const String fallbackPin = "258369"; // Fallback PIN if Firestore fails

  Future<void> saveUnlockAction(String pin, {bool success = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection("lock_history").add({
        "action": success ? "UNLOCK" : "FAILED_UNLOCK",
        "method": "keypad",
        "email": user.email,
        "pin": pin,
        "timestamp": DateTime.now().toIso8601String(),
      });
    }
  }

  void _appendDigit(String digit) {
    if (enteredPin.length < 6) {
      setState(() {
        enteredPin += digit;
      });
    }
  }

  void _clearPin() {
    setState(() {
      enteredPin = '';
    });
  }

  void _submitPin() async {
    if (enteredPin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter 6 digits')),
      );
      return;
    }

    try {
      // Get PIN from Firestore
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('lock_settings')
          .doc('main_lock')
          .get();

      String correctPin = fallbackPin;
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        correctPin = data?['pin']?.toString() ?? fallbackPin;
      }

      if (enteredPin == correctPin) {
        await saveUnlockAction(enteredPin, success: true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lock Unlocked!'),
            duration: Duration(seconds: 1),
          ),
        );
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LockHistoryPage()),
          );
        });
      } else {
        await saveUnlockAction(enteredPin, success: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect PIN!'),
            backgroundColor: Colors.red,
          ),
        );
        _clearPin();
      }
    } catch (e) {
      // Fallback PIN if Firestore fails
      if (enteredPin == fallbackPin) {
        await saveUnlockAction(enteredPin, success: true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lock Unlocked! (Fallback PIN)'), duration: Duration(seconds: 1)),
        );
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LockHistoryPage()),
          );
        });
      } else {
        await saveUnlockAction(enteredPin, success: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect PIN!'), backgroundColor: Colors.red),
        );
        _clearPin();
      }
    }
  }

  Widget _buildKey(String digit) {
    return Container(
      width: 70, // Matches minimumSize width
      height: 70, // Matches minimumSize height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _neonGreen.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _appendDigit(digit),
        child: Text(
          digit,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(70, 70),
          backgroundColor: _keypadBackground.withOpacity(0.7), // Keypad button background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: _neonGreen, width: 2), // Neon border
          ),
          padding: EdgeInsets.zero,
          elevation: 0, // Disable default elevation
        ),
      ),
    );
  }

  // Helper widget for non-digit keys (Backspace and Check)
  Widget _buildActionKey(IconData icon, VoidCallback onPressed, {bool isSubmit = false}) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: isSubmit ? [
          BoxShadow(
            color: _lightNeonGreen.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 3,
            offset: Offset(0, 5),
          ),
        ] : [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Icon(
          icon,
          color: isSubmit ? _lightNeonGreen : Colors.white, // Green for check, white for backspace
          size: 30,
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(70, 70),
          backgroundColor: _keypadBackground.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSubmit ? _lightNeonGreen : Colors.white.withOpacity(0.5),
              width: 2,
            ),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBackground, // Dark background color from Login Page
      appBar: AppBar(
        title: Text(
          'Keypad Unlock',
          style: TextStyle(color: _neonGreen, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _keypadBackground, // AppBar color
        iconTheme: IconThemeData(color: _neonGreen), // Back button color
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            enteredPin.isEmpty ? "Enter 6-Digit PIN" : enteredPin.padRight(6, '•').replaceAll(RegExp(r'[0-9]'), '•'),
            style: TextStyle(
              fontSize: 36,
              letterSpacing: 10,
              color: _neonGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 50), // Increased spacing
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _keypadBackground.withOpacity(0.5), // Inner container color
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: _neonGreen.withOpacity(0.3)), // Subtle neon outline
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 30,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['1', '2', '3'].map(_buildKey).toList(),
                  ),
                  SizedBox(height: 20), // Increased spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['4', '5', '6'].map(_buildKey).toList(),
                  ),
                  SizedBox(height: 20), // Increased spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['7', '8', '9'].map(_buildKey).toList(),
                  ),
                  SizedBox(height: 20), // Increased spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionKey(
                        Icons.backspace,
                        _clearPin,
                        isSubmit: false,
                      ),
                      _buildKey('0'),
                      _buildActionKey(
                        Icons.check,
                        _submitPin,
                        isSubmit: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}