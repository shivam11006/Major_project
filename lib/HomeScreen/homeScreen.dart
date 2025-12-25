import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../DealerAuth/DealerPolicy.dart';
import '../DealerAuth/DealerPostItemsList.dart';
import '../Screen/IntroScreen.dart';
import '../Screen/OrderScreen.dart';
import '../Screen/AddressListScreen.dart';
import '../Services/TranslationService.dart';
import '../Screen/AllProductsScreen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String? _selectedFilter; // 'low_to_high', 'high_to_low'
  Timer? _debounce;
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

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

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Filter by Price",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text("Price: Low to High"),
                leading: Radio<String>(
                  value: 'low_to_high',
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text("Price: High to Low"),
                leading: Radio<String>(
                  value: 'high_to_low',
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text("Clear Filter"),
                leading: const Icon(Icons.clear, color: Colors.red),
                onTap: () {
                  setState(() {
                    _selectedFilter = null;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = ref.watch(languageProvider);
    String tr(String key) => AppLocalizations.of(currentLang, key);

    return FutureBuilder<Map<String, dynamic>?>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        // Default values before data loads
        String userName = "";
        String userPhoneNumber = ""; // Changed from userEmail

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator(color: Colors.green)),
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
                  decoration: BoxDecoration(color: Colors.green.shade400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundImage: AssetImage("assets/profile.png"),
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
                  leading: const Icon(IconlyBroken.home, color: Colors.green),
                  title: Text(tr('home')),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(IconlyBroken.bag, color: Colors.green),
                  title: Text(tr('your_orders')),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderScreen(
                          userPhone: userPhoneNumber,
                        ), // Pass phone number if needed
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    IconlyBroken.location,
                    color: Colors.green,
                  ),
                  title: Text(tr('your_address')),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddressListScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(IconlyBroken.bag, color: Colors.green),
                  title: Text(tr('sell_crops')),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(IconlyBroken.show, color: Colors.green),
                  title: Text(tr('your_post')),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DealerPostItemsList()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.contact_emergency,
                    color: Colors.green,
                  ),
                  title: Text(tr('contact_us')),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.policy, color: Colors.green),
                  title: Text(tr('privacy_policy')),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DealerPolicy()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    IconlyBroken.logout,
                    color: Colors.redAccent,
                  ),
                  title: Text(tr('logout')),
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

          // ✅ AppBar showing name only
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            title: Text(
              "${tr('hi_greeting')} $userName 👋",
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
                        controller: _searchController,
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce = Timer(
                            const Duration(milliseconds: 500),
                            () {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          );
                        },
                        decoration: InputDecoration(
                          hintText: tr('search_hint'),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(99),
                            borderSide: BorderSide(
                              color: Colors.green.shade300,
                            ),
                          ),
                          prefixIcon: const Icon(IconlyBroken.search),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton.filled(
                        onPressed: _showFilterBottomSheet,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr('free_consultation'),
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(tr('get_free_support')),
                              FilledButton(
                                onPressed: () {},
                                child: Text(tr('call_us')),
                              ),
                            ],
                          ),
                        ),
                        Image.asset("assets/contact_us.png", width: 100),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr('featured_products'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllProductsScreen(),
                        ),
                      );
                    },
                    child: Text(tr('see_all')),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: () {
                  Query query = _firestore.collection('items');

                  if (_searchQuery.isNotEmpty) {
                    // search is handled client side for flexibility (case insensitive)
                    // We fetch all products when searching to filter them in Dart
                  } else {
                    // Only limit if NOT searching
                    query = query.limit(10);
                  }

                  if (_selectedFilter == 'low_to_high') {
                    query = query.orderBy('price', descending: false);
                  } else if (_selectedFilter == 'high_to_low') {
                    query = query.orderBy('price', descending: true);
                  }

                  return query.snapshots();
                }(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No products available",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  }

                  // 🔍 Client-side filtering for Case-Insensitive Search
                  final products = snapshot.data!.docs.where((doc) {
                    if (_searchQuery.isEmpty) return true;
                    final data = doc.data() as Map<String, dynamic>;
                    final name = (data['name'] ?? '').toString().toLowerCase();
                    return name.startsWith(_searchQuery.toLowerCase());
                  }).toList();

                  if (products.isEmpty) {
                    return Center(
                      child: Text(
                        "No products found",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product =
                          products[index].data() as Map<String, dynamic>;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: product['imageUrl'] ?? '',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.green,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: Colors.grey[100],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'] ?? 'Unknown',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // ✅ Price Display Logic
                                      if (product['isDiscounted'] == true)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "₹${product['originalPrice'] ?? product['price']}",
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              "₹${product['price'] ?? 0}",
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        )
                                      else
                                        Text(
                                          "₹${product['price'] ?? 0}",
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      InkWell(
                                        onTap: () {
                                          // Add to cart logic will go here
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  "Make for ❤️ INDIA",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                    fontSize: 64,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
