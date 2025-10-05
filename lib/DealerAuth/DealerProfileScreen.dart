import 'package:flutter/material.dart';

import '../Widgets/uiHelper.dart';


class DealerProfileScreen extends StatelessWidget {
  // Controllers for the input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  // Define the background color once
  final Color _kBackgroundColor = const Color(0xff0E363E);
  final Color _kAccentColor = const Color(0xFF607D8B); // Dark slate blue for icons/borders

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundColor,
      appBar: AppBar(
        backgroundColor: _kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // Placeholder for the logo action
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset("assets/app_logo 1.png",),
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- 1. User Profile Picture Section ---
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Profile Circle
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _kAccentColor,
                      border: Border.all(color: Colors.white12, width: 2),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 90,
                      color: Color(0xFF90A4AE), // Lighter blue-gray for the inner icon
                    ),
                  ),
                  // Edit Button Overlay
                  Positioned(
                    bottom: -5,
                    right: -5,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: _kAccentColor, width: 2),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: _kAccentColor,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // --- 2. Input Fields Section ---
            // Name Field (Placeholder from image "Your Name")
            UiHelper.CustomTextField(
                controller: nameController,
                text: "Your Name",
                tohide: false
            ),
            const SizedBox(height: 15),

            // Mobile Number (New Field)
            UiHelper.CustomTextField(
              controller: mobileController,
              text: "Mobile Number",
              tohide: false,
            ),
            const SizedBox(height: 15),

            // Full Address (New Field, uses maxLines for a taller field)
            SizedBox(
              height: 100, // Taller field for address
              child: UiHelper.CustomTextField(
                controller: addressController,
                text: "Full Address",
                tohide: false,
              ),
            ),
            const SizedBox(height: 15),

            // Pin Code Field (Placeholder from image "Pin Code")
            UiHelper.CustomTextField(
                controller: pinCodeController,
                text: "Pin Code",
                tohide: false
            ),
            const SizedBox(height: 30),

            // --- 3. Save Button ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: UiHelper.CustomButton(
                buttonname: "Save Profile",
                callback: () {

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
