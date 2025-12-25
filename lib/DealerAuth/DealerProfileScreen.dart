import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:majorproject/utils.dart';
import '../HomeScreen/homeScreen.dart';

class DealerProfileScreen extends StatefulWidget {
  @override
  State<DealerProfileScreen> createState() => _DealerProfileScreenState();
}

class _DealerProfileScreenState extends State<DealerProfileScreen> {
  String dealerName = '';
  String dealerId = '';
  String bio = '';
  String email = '';
  int postCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDealerData();
  }

  /// 🔹 Fetch Dealer data using UID
  Future<void> fetchDealerData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        setState(() => isLoading = false);
        return;
      }

      // Fetch dealer document by UID
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Dealer')
          .doc(currentUser.uid)
          .get();

      if (doc.exists) {
        setState(() {
          dealerName = doc['Name'] ?? '';
          dealerId = doc['UserName'] ?? '';
          bio = doc['Bio'] ?? 'Hello! I\'m a dealer 👋';
          email = doc['Email'] ?? '';
          isLoading = false;
        });

        fetchPostCount(currentUser.uid); // Fetch posts by UID
      } else {
        setState(() => isLoading = false);
        print('Dealer document not found for UID: ${currentUser.uid}');
      }
    } catch (e) {
      print('Error fetching dealer data: $e');
      setState(() => isLoading = false);
    }
  }

  /// 🔹 Fetch Post Count by UID
  Future<void> fetchPostCount(String dealerUid) async {
    try {
      QuerySnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('DealerPosts')
          .where('dealerUid', isEqualTo: dealerUid)
          .get();

      setState(() {
        postCount = postSnapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching post count: $e');
    }
  }

  /// 🔹 Update Dealer Data (Name + Bio)
  Future<void> updateDealerData(String newName, String newBio) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    await FirebaseFirestore.instance
        .collection('Dealer')
        .doc(currentUser.uid)
        .update({'Name': newName, 'Bio': newBio});
  }

  /// 🔹 Show Update Dialog
  void _showUpdateDialog() {
    TextEditingController nameController = TextEditingController(
      text: dealerName,
    );
    TextEditingController bioController = TextEditingController(text: bio);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff122129),
          title: const Text(
            "Update Profile",
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  enabled: false,
                  style: const TextStyle(color: Colors.white54),
                  decoration: InputDecoration(
                    labelText: "Email (cannot be changed)",
                    labelStyle: const TextStyle(color: Colors.white54),
                    hintText: email,
                    hintStyle: const TextStyle(color: Colors.white54),
                    disabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bioController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Bio",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4B8B3B),
              ),
              onPressed: () async {
                String updatedName = nameController.text.trim();
                String updatedBio = bioController.text.trim();

                setState(() {
                  dealerName = updatedName;
                  bio = updatedBio;
                });

                // ... (existing imports)

                // ... inside updateDealerData callback ...
                await updateDealerData(updatedName, updatedBio);
                Navigator.pop(context);

                showAppSnackbar(
                  context: context,
                  type: SnackbarType.success,
                  description: "Profile updated successfully",
                );
              },
              child: const Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 🔹 UI
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
              MaterialPageRoute(builder: (context) => HomeScreen()),
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
                  // Banner
                  Container(
                    height: screenHeight * 0.25,
                    width: double.infinity,
                    child: Image.asset(
                      "assets/profile_banner.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Profile Card
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
                          // Profile Info
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
                                            dealerName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * 0.06,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                          onPressed: _showUpdateDialog,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      dealerId,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: screenWidth * 0.04,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Bio
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
                          // Stats
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
                          // Buttons
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

  /// 🔹 Helper widget for stats
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
