import 'package:flutter/material.dart';

import 'package:majorproject/HomeScreen/homeScreen.dart';

class ProfileScreen extends StatelessWidget {
  // 1. Add final variables to hold the user data
  final String userName;
  final String userUsername;

  // 2. Add constructor to require user data
  const ProfileScreen({
    Key? key,
    this.userName = 'Kishan Name', // Default value for testing
    this.userUsername = '@username', // Default value for testing
  }) : super(key: key);

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
      body: SingleChildScrollView(
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xff122129),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Picture
                        Container(
                          width: screenWidth * 0.2,
                          height: screenWidth * 0.2,
                          decoration: BoxDecoration(
                            color: Color(0xffa8c6db),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        SizedBox(width: 16),
                        // Profile info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      // 3. Use the dynamic userName
                                      userName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.06,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Image.asset(
                                    'assets/farmer_badge.png',
                                    width: screenWidth * 0.06,
                                    height: screenWidth * 0.06,
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                // 4. Use the dynamic userUsername
                                userUsername,
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
                    SizedBox(height: 16),
                    // Bio
                    Text(
                      'Bio',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildBioPoint('Hello! I\'m Farmer', screenWidth),
                    _buildBioPoint('I grows Falana things', screenWidth),
                    _buildBioPoint('I do hen ten... 👋', screenWidth),
                    SizedBox(height: 16),
                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatColumn('127', 'Posts', screenWidth),
                        _buildStatColumn('127', 'Orders', screenWidth),
                        _buildStatColumn('127', 'Connections', screenWidth),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff4B8B3B),
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
                        SizedBox(width: 16),
                        Container(
                          height: screenHeight * 0.065,
                          width: screenHeight * 0.065,
                          decoration: BoxDecoration(
                            color: Color(0xff4B8B3B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.chat_bubble_outline, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Bottom tabs
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTab('Products', screenWidth),
                  _buildTab('Blogs', screenWidth),
                  _buildTab('Post', screenWidth),
                ],
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
          Icon(Icons.circle, size: screenWidth * 0.02, color: Color(0xff4B8B3B)),
          SizedBox(width: 8),
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

  Widget _buildTab(String text, double screenWidth) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey,
        fontSize: screenWidth * 0.045,
      ),
    );
  }
}
