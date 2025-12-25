import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Screen/IntroScreen.dart';
import 'DealerPolicy.dart';
import 'DealerPostItemsList.dart';
import 'DealerProfileScreen.dart';
import '../Services/TranslationService.dart';
import '../Screen/AllProductsScreen.dart';

class DearHomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<DearHomeScreen> createState() => _DearHomeScreenState();
}

class _DearHomeScreenState extends ConsumerState<DearHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String? _selectedFilter; // 'low_to_high', 'high_to_low'
  Timer? _debounce;
  late Future<Map<String, dynamic>?> _dealerDataFuture;

  @override
  void initState() {
    super.initState();
    _dealerDataFuture = _getDealerData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // 🚀 Fetch Dealer data using email to query the collection
  Future<Map<String, dynamic>?> _getDealerData() async {
    User? user = _auth.currentUser;
    if (user != null && user.email != null) {
      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection('Dealer')
            .where('Email', isEqualTo: user.email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first.data() as Map<String, dynamic>;
        }
      } catch (e) {
        debugPrint("Error fetching dealer data: $e");
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
      future: _dealerDataFuture,
      builder: (context, snapshot) {
        String dealerName = "Dealer";
        String dealerPhoneNumber = "";
        String dealerEmail = "dealer@example.com";
        // String dealerImage = "assets/profile.png"; // Unused

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator(color: Colors.green)),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          dealerName = snapshot.data!['Name'] ?? dealerName;
          dealerEmail = snapshot.data!['Email'] ?? dealerEmail;
          dealerPhoneNumber = snapshot.data!['Number'] ?? "";
        }

        return Scaffold(
          drawer: Drawer(
            backgroundColor: Colors.grey.shade100,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 29,
                          backgroundImage: AssetImage("assets/profile.png"),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dealerName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              dealerPhoneNumber.isNotEmpty
                                  ? dealerPhoneNumber
                                  : dealerEmail,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _buildDrawerTile(
                        icon: IconlyBroken.home,
                        title: tr('home'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      _buildDrawerTile(
                        icon: Icons.shopping_bag_outlined,
                        title: tr('your_orders'),
                        onTap: () {},
                      ),
                      _buildDrawerTile(
                        icon: Icons.shopping_bag_outlined,
                        title: tr('your_post'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DealerPostItemsList(),
                            ),
                          );
                        },
                      ),
                      _buildDrawerTile(
                        icon: Icons.pin_drop,
                        title: tr('your_address'),
                        onTap: () {},
                      ),
                      _buildDrawerTile(
                        icon: Icons.shopping_basket_outlined,
                        title: tr('buy_crops'),
                        onTap: () {},
                      ),
                      _buildDrawerTile(
                        icon: IconlyBroken.profile,
                        title: tr('your_profile'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DealerProfileScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDrawerTile(
                        icon: Icons.policy,
                        title: tr('privacy_policy'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DealerPolicy(),
                            ),
                          );
                        },
                      ),
                      _buildDrawerTile(
                        icon: IconlyBroken.logout,
                        title: tr('logout'),
                        color: Colors.red.shade600,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "© 2025 Agri Shakti",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 AppBar
          appBar: AppBar(
            centerTitle: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${tr('hi_greeting')} $dealerName 👋",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  tr('enjoy_services'),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
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
                          prefixIcon: Icon(IconlyBroken.search),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton.filled(
                        onPressed: _showFilterBottomSheet,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tr('featured_products')),
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
                    // search is handled client side
                  } else {
                    query = query.limit(10);
                  }

                  if (_selectedFilter == 'low_to_high') {
                    query = query.orderBy('price', descending: false);
                  } else if (_selectedFilter == 'high_to_low') {
                    query = query.orderBy('price', descending: true);
                  }

                  return query.snapshots();
                }(),
                // Only show dealer's own products? The user said "Dealer product. like eccomerce app product list".
                // Actually the user prompt says: "Fetch only the product which is posted by the Dealer product." check existing code:
                // "Fetch only the product which is posted by the Dealer product. like eccomerce app product list."
                // Wait, if this is THE Dealer app, showing THEIR OWN posts makes sense (Your Posts).
                // However, the prompt says "like eccomerce app product list" which implies seeing what OTHERS see.
                // But looking at the previous file content, there is already "Your Post" in drawer pointing to `DealerPostItemsList`.
                // And the previous `DealerPostItemsList` allows editing/deleting.
                // The HOME screen usually shows a dashboard or general feed.
                // If I look at the main HomeScreen implementation, it fetches ALL items.
                // The prompt says "Fetch only the product which is posted by the Dealer product." - this phrasing is slightly ambiguous.
                // "Fetch only the products which ARE posted by Dealers" (meaning all products)?
                // OR "Fetch only the products posted by THIS dealer"?
                // Given "like eccomerce app product list", it usually suggests a marketplace view.
                // But usually a Dealer wants to see their sales or their own inventory on home.
                // Let's re-read: "Fetch only the product which is posted by the Dealer product. like eccomerce app product list."
                // I will fetch ALL items for now as it simulates the "Marketplace" look requested in the previous turn for the User App.
                // BUT, wait, this is `DealerAuth/HomeScreen.dart`.
                // If this is the Dealer's dashboard, maybe they want to see their own items.
                // Let's look at `DealerPostItemsList.dart` (viewed in step 407). It filters `items` by `uploadedBy`.
                // If I use the same filter here, it's just a duplicate of "Your Posts".
                // If I show ALL items, it's a marketplace.
                // Let's assume the user wants to see HOW their products look to others, OR this is a shared marketplace view.
                // "Fetch only the product which is posted by the Dealer product" -> "Fetch only the products created by dealers" (which is all items).
                // I will stick to fetching ALL `items` as per `_firestore.collection('items').snapshots()` in the user app.
                // If the user meant "My Products", they would usually say "My products".
                // I will use `_firestore.collection('items').snapshots()` first.
                // Actually, let's look at the instruction again.
                // "Fetch only the product which is posted by the Dealer product."
                // The collection is `items`. And `DealerPostItemsList` adds to `items`.
                // So fetching `items` gives "products posted by Dealer".
                // So `_firestore.collection('items').snapshots()` satisfies "Fetch products posted by Dealer".
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
                    fontSize: 28,
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

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color ?? Colors.green.shade800, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
