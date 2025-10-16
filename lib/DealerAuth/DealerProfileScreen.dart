import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../HomeScreen/homeScreen.dart';
import '../Widgets/uiHelper.dart'; // Assuming this import is necessary for other parts of your app


class DealerProfileScreen extends StatefulWidget {
  @override
  State<DealerProfileScreen> createState() => _DealerProfileScreenState();
}

class _DealerProfileScreenState extends State<DealerProfileScreen> {

  String dealerName = '';
  String dealerId = ''; // Changed variable name for consistency
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDealerData();
  }

  // ✅ MODIFIED: Function to fetch Dealer data using email query
  Future<void> fetchDealerData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.email == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // 1. Query the 'Dealer' collection where the 'Email' field matches the current user's email.
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Dealer')
          .where('Email', isEqualTo: currentUser.email)
          .limit(1) // Assuming one unique dealer per email
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // 2. Get the first matching document
        DocumentSnapshot doc = querySnapshot.docs.first;

        setState(() {
          // 3. Retrieve 'Name' and 'UserName' based on the database structure
          dealerName = doc['Name'] ?? '*';
          dealerId = doc['UserName'] ?? '@unknown';
          isLoading = false;
        });
      } else {
        // No dealer found with that email
        setState(() {
          isLoading = false;
        });
        print('Dealer document not found for email: ${currentUser.email}');
      }
    } catch (e) {
      print('Error fetching dealer data: $e');
      setState(() {
        isLoading = false;
      });
    }
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
            // NOTE: Consider using Navigator.pop(context) if this screen is pushed
            // instead of using pushReplacement back to HomeScreen
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
            // Banner Image
            Container(
              height: screenHeight * 0.25,
              width: double.infinity,
              child: Image.asset(
                "assets/profile_banner.png",
                fit: BoxFit.cover,
              ),
            ),
            // Main Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff122129),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Row
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
                                      // Display fetched Name
                                      dealerName,
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
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                // Display fetched UserName (as DealerId)
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
                    Text(
                      'Bio',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBioPoint('Hello! I\'m a dealer', screenWidth),
                    _buildBioPoint('Providing quality products', screenWidth),
                    _buildBioPoint('Glad to connect with farmers 👋', screenWidth),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatColumn('127', 'Posts', screenWidth),
                        _buildStatColumn('127', 'Orders', screenWidth),
                        _buildStatColumn('127', 'Connections', screenWidth),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                                  vertical: screenHeight * 0.015),
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
                          child: const Icon(Icons.chat_bubble_outline,
                              color: Colors.white),
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
  Widget _buildBioPoint(String text, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.circle, size: screenWidth * 0.02, color: const Color(0xff4B8B3B)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04),
            ),
          ),
        ],
      ),
    );
  }

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
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.035,
          ),
        ),
      ],
    );
  }
}
