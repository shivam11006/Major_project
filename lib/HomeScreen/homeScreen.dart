import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Screen/IntroScreen.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Fetch user data (using phone number as document ID)
  Future<Map<String, dynamic>?> _getUserData() async {
    User? user = _auth.currentUser;
    // Check if the user is logged in AND has a phone number (which is used as the document ID)
    if (user != null && user.phoneNumber != null) {
      try {
        // Access the 'User' collection and use the user's phone number as the document ID
        DocumentSnapshot doc = await _firestore
            .collection('User')
            .doc(user.phoneNumber) // The document ID is now the phone number
            .get();

        if (doc.exists) {
          return doc.data() as Map<String, dynamic>;
        }
      } catch (e) {
        debugPrint("Error fetching user data: $e");
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getUserData(),
      builder: (context, snapshot) {
        // Default values before data loads
        String userName = "";
        String userPhoneNumber = ""; // Changed from userEmail

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: CircularProgressIndicator(color: Colors.green)),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          // Fetch 'name' and 'phone' fields from the document
          userName = snapshot.data!['name'] ?? userName;
          userPhoneNumber =
              snapshot.data!['phone'] ?? userPhoneNumber; // Fetching 'phone'
        }

        return Scaffold(
          backgroundColor: Colors.white,

          // ✅ Drawer showing user info
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration:
                  BoxDecoration(color: Colors.green.shade400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundImage:
                        AssetImage("assets/profile.png"),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        // Displaying phone number instead of email
                        userPhoneNumber,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(IconlyBroken.home),
                  title: const Text('Home'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(IconlyBroken.bag),
                  title: const Text('Your Orders'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(IconlyBroken.location),
                  title: const Text('Your Address'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(IconlyBroken.bag),
                  title: const Text('Sell Your Crops & Vegetables'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(IconlyBroken.location),
                  title: const Text('Find Nearest Seller'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.contact_emergency),
                  title: const Text('Contact Us'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.calculate),
                  title: const Text('Budget calculator'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(IconlyBroken.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    await _auth.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => IntroScreen()),
                          (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),

          // ✅ AppBar showing name only
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            title: Text(
              "Hi $userName 👋",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconlyBroken.notification,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // ✅ Body content
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search here...",
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(99),
                            borderSide: BorderSide(
                                color: Colors.green.shade300),
                          ),
                          prefixIcon: const Icon(IconlyBroken.search),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton.filled(
                        onPressed: () {},
                        icon: const Icon(IconlyLight.filter),
                      ),
                    ),
                  ],
                ),
              ),

              // Banner
              SizedBox(
                height: 170,
                child: Card(
                  color: Colors.green.shade50,
                  elevation: 0.1,
                  shadowColor: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Free Consultation",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                  "Get free support from our customer service"),
                              FilledButton(
                                onPressed: () {},
                                child: const Text("Call Us"),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          "assets/contact_us.png",
                          width: 100,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Featured Products",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  TextButton(
                    onPressed: () {},
                    child: const Text("See all"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}