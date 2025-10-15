import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Authen/PhoneNumberScreen.dart';
import '../BottomNavigation/BottomNavigation.dart';
import '../FirebaseServices/node_model.dart';

class RegistrationProfile extends StatefulWidget {
  @override
  _RegistrationProfileState createState() => _RegistrationProfileState();
}

class _RegistrationProfileState extends State<RegistrationProfile> {
  File? _image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _termsAccepted = false;
  bool _isSaving = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate() || !_termsAccepted) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Create user object using your model
      UserSignUp newUser = UserSignUp(
        _nameController.text.trim(),
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _mobileController.text.trim(),
      );

      String emailId = _emailController.text.trim();
      await FirebaseFirestore.instance
          .collection('User')
          .doc(emailId) // <-- set email as document ID
          .set(UserSignUp.toMap(newUser));
      print("Account Logged successfully");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigation()),
      );
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030A0E),
      appBar: AppBar(
        backgroundColor: const Color(0xff030A0E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => PhoneNumberScreen()));
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              "assets/app_logo.png",
              height: 40,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xff4B8B3B).withOpacity(0.5),
                          image: _image != null
                              ? DecorationImage(
                            image: FileImage(_image!),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: _image == null
                            ? Icon(Icons.person, size: 100, color: Color(0xffA8C6DB))
                            : null,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffA8C6DB),
                      ),
                      child: Icon(Icons.edit, size: 24, color: Color(0xff030A0E)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buildTextField(_nameController, 'Your Name', false),
                SizedBox(height: 16),
                _buildTextField(_emailController, 'Email', true),
                SizedBox(height: 16),
                _buildTextField(_mobileController, 'Mobile No.', false, isNumber: true),
                SizedBox(height: 16),
                _buildTextField(_usernameController, 'Username', false),
                SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (bool? value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                      activeColor: Color(0xff4B8B3B),
                    ),
                    Expanded(
                      child: Text(
                        'I accept the Terms and Conditions',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _termsAccepted && !_isSaving ? _saveData : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _termsAccepted ? Color(0xff4B8B3B) : Colors.grey,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSaving
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      'Finished',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, bool isEmail,
      {bool isNumber = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffA8C6DB).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber
            ? TextInputType.number
            : isEmail
            ? TextInputType.emailAddress
            : TextInputType.text,
        style: TextStyle(color: Colors.white),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $hintText';
          }
          if (isEmail && !RegExp(r'\S+@\S+\.\S+').hasMatch(value.trim())) {
            return 'Please enter a valid email';
          }
          if (isNumber && value.trim().length < 10) {
            return 'Please enter a valid mobile number';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white54),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
