import 'package:majorproject/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../BottomNavigation/BottomNavigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
  String phoneNumber = '';
  String bio = '';
  int postCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchPostCount();
  }

  /// 🔹 Fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.phoneNumber == null) {
        setState(() => isLoading = false);
        return;
      }

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(currentUser.phoneNumber)
          .get();

      if (snapshot.exists) {
        setState(() {
          username = snapshot['name'] ?? '';
          phoneNumber = snapshot['phone'] ?? '';
          bio = snapshot['bio'] ?? 'Hello! I am a farmer 👋';
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() => isLoading = false);
    }
  }

  /// 🔹 Fetch post count from "items" collection
  Future<void> fetchPostCount() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('items')
          .where('uploadedBy', isEqualTo: currentUser.uid)
          .get();

      setState(() {
        postCount = snapshot.size;
      });
    } catch (e) {
      print('Error fetching post count: $e');
    }
  }

  /// 🔹 Update user profile (Name & Bio only — Phone number cannot be updated)
  Future<void> updateUserProfile() async {
    final nameController = TextEditingController(text: username);
    final phoneController = TextEditingController(text: phoneNumber);
    final bioController = TextEditingController(text: bio);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Update Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                enabled: false, // 🚫 Cannot edit phone number
                decoration: const InputDecoration(
                  labelText: "Phone Number (cannot be changed)",
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: bioController,
                decoration: const InputDecoration(labelText: "Bio"),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              final currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser == null || currentUser.phoneNumber == null)
                return;

              await FirebaseFirestore.instance
                  .collection('User')
                  .doc(currentUser.phoneNumber)
                  .update({
                    'name': nameController.text.trim(),
                    // phone not updated ❌
                    'bio': bioController.text.trim(),
                  });

              setState(() {
                username = nameController.text.trim();
                bio = bioController.text.trim();
              });

              Navigator.pop(context);
              showAppSnackbar(
                context: context,
                type: SnackbarType.success,
                description: "Profile updated successfully",
              );
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff030A0E),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigation()),
            );
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Banner
                  Container(
                    height: screenHeight * 0.25,
                    width: double.infinity,
                    child: Image.asset(
                      "assets/profile_banner.png",
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// 🔹 Profile Card
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xff122129),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Profile Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: screenWidth * 0.2,
                                height: screenWidth * 0.2,
                                decoration: BoxDecoration(
                                  color: const Color(0xffa8c6db),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            username,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * 0.06,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Image.asset(
                                          'assets/farmer_badge.png',
                                          width: screenWidth * 0.06,
                                          height: screenWidth * 0.06,
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                          onPressed: updateUserProfile,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      phoneNumber,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: screenWidth * 0.045,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          /// 🔹 Bio Section
                          Text(
                            'Bio',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            bio,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// 🔹 Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatColumn(
                                '$postCount',
                                'Posts',
                                screenWidth,
                              ),
                              _buildStatColumn('0', 'Orders', screenWidth),
                              _buildStatColumn('0', 'Connections', screenWidth),
                            ],
                          ),

                          const SizedBox(height: 16),

                          /// 🔹 Connect + Message Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff4B8B3B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.015,
                                    ),
                                    child: Text(
                                      'Connect',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                height: screenHeight * 0.065,
                                width: screenHeight * 0.065,
                                decoration: BoxDecoration(
                                  color: const Color(0xff4B8B3B),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// 🔹 Helper Widget
  Widget _buildStatColumn(String count, String label, double screenWidth) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.035),
        ),
      ],
    );
  }
}
