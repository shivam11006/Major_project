import 'package:flutter/material.dart';
import 'package:majorproject/HomeScreen/homeScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:majorproject/auth/authScreen.dart';
import 'dart:io';

import 'package:majorproject/auth/otpScreen.dart';

import '../BottomNavigation/BottomNavigation.dart';

class RegistrationProfile extends StatefulWidget {
  @override
  _RegistrationProfileState createState() => _RegistrationProfileState();
}

class _RegistrationProfileState extends State<RegistrationProfile> {
  File? _image;

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
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Photo Library'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AuthScreen()));
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
              _buildTextField('Your Name'),
              SizedBox(height: 16),
              _buildTextField('Pin Code'),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (bool? value) {},
                    activeColor: Color(0xff4B8B3B),
                  ),
                  Text(
                    'Terms and Conditions',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 5 ? Colors.white : Colors.grey,
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BottomNavigation()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff4B8B3B),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
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
    );
  }

  Widget _buildTextField(String hintText) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffA8C6DB).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        style: TextStyle(color: Colors.white),
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
