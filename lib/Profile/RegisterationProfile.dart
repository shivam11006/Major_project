import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../BottomNavigation/BottomNavigation.dart';

class RegistrationScreen extends StatefulWidget {
  final String phoneNumber;
  RegistrationScreen({required this.phoneNumber});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _saving = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveData() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      await _firestore.collection('User').doc(widget.phoneNumber).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': widget.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() => _saving = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavigation()),
      );
    } catch (e) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error saving data: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030A0E),
      appBar: AppBar(
        title: Text("Complete Registration"),
        backgroundColor: const Color(0xff030A0E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saving ? null : _saveData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 55),
              ),
              child: _saving
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Save & Continue"),
            )
          ],
        ),
      ),
    );
  }
}
