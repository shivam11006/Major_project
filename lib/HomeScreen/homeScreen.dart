import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Screen/IntroScreen.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Fetch Dealer data from Firestore using email as document ID
  Future<Map<String, dynamic>?> _getDealerData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('User').doc(user.email).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getDealerData(),
      builder: (context, snapshot) {
        String dealerName = "Dealer";
        String dealerEmail = "dealer@example.com";

        if (snapshot.connectionState == ConnectionState.waiting) {
          // ⏳ While loading Firestore data
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          dealerName = snapshot.data!['Name'] ?? dealerName;
          dealerEmail = snapshot.data!['Email'] ?? dealerEmail;
        }

        return Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.green.shade200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/profile.png"),
                      ),
                      SizedBox(height: 10),
                      Text(
                        dealerName,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        dealerEmail,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(IconlyBroken.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(IconlyBroken.location),
                  title: Text('Your Address'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(IconlyBroken.logout),
                  title: Text('Logout'),
                  onTap: () async {
                    await _auth.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => IntroScreen()),
                          (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),

          // 🔹 AppBar now dynamically shows dealer's name
          appBar: AppBar(
            centerTitle: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi $dealerName 👋",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Enjoy our services",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton.filledTonal(
                  onPressed: () {},
                  icon: Icon(IconlyBroken.notification),
                ),
              ),
            ],
          ),

          // 🔹 Body content
          body: ListView(
            padding: EdgeInsets.all(16),
            children: [
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
                            borderSide: BorderSide(color: Colors.green.shade300),
                          ),
                          prefixIcon: Icon(IconlyBroken.search),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton.filled(
                        onPressed: () {},
                        icon: Icon(IconlyLight.filter),
                      ),
                    ),
                  ],
                ),
              ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              Text("Get Free support from our customer services"),
                              FilledButton(
                                onPressed: () {},
                                child: Text("Call Us"),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Featured Product"),
                  TextButton(
                    onPressed: () {},
                    child: Text("See all"),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
