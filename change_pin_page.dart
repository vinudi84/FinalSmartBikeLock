import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangePinPage extends StatefulWidget {
  @override
  _ChangePinPageState createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  Future<void> updatePin() async {
    String newPin = _pinController.text.trim();
    String confirmPin = _confirmPinController.text.trim();

    if (newPin.isEmpty || confirmPin.isEmpty) {
      showMessage("Please fill both fields");
      return;
    }

    if (newPin != confirmPin) {
      showMessage("PINs do not match!");
      return;
    }

    if (newPin.length != 6) {
      showMessage("PIN must be 6 digits");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('lock_settings')
          .doc('main_lock')
          .set({
        'pin': newPin,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      showMessage("PIN updated successfully!", success: true);
      _pinController.clear();
      _confirmPinController.clear();
    } catch (e) {
      showMessage("Error: $e");
    }
  }

  void showMessage(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Lock PIN"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              decoration: InputDecoration(
                labelText: "Enter New PIN",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _confirmPinController,
              decoration: InputDecoration(
                labelText: "Confirm PIN",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: updatePin,
              child: Text("Save PIN"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                textStyle: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
