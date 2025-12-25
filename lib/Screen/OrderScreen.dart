import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Services/TranslationService.dart';

class OrderScreen extends ConsumerStatefulWidget {
  final String? userPhone;

  const OrderScreen({Key? key, this.userPhone}) : super(key: key);

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final currentLang = ref.watch(languageProvider);
    String tr(String key) => AppLocalizations.of(currentLang, key);

    // Use the passed phone number or fallback to current user's phone if available
    final String? phoneNumber =
        widget.userPhone ?? _auth.currentUser?.phoneNumber;

    if (phoneNumber == null) {
      return Scaffold(
        appBar: AppBar(title: Text(tr('your_orders'))),
        body: Center(child: Text(tr('user_not_identified'))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          tr('your_orders'),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('userId', isEqualTo: phoneNumber)
            // .orderBy('orderDate', descending: true) // Requires Firestore Index
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }

          if (snapshot.hasError) {
            // Handle the case where the index might be missing or other errors
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(IconlyBroken.bag, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 20),
                  Text(
                    tr('no_orders'),
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var orderData = orders[index].data() as Map<String, dynamic>;
              // Defensive coding for fields
              String orderId = orders[index].id;
              var totalAmount = orderData['totalAmount'] ?? 0;
              var status = orderData['status'] ?? 'Pending';
              Timestamp? timestamp = orderData['orderDate'];
              String dateStr = timestamp != null
                  ? DateFormat('MMM dd, yyyy').format(timestamp.toDate())
                  : 'Date unknown';

              // Depending on your data structure, you might have 'items' as a list
              List<dynamic> items = orderData['items'] ?? [];
              String itemsSummary = items.isNotEmpty
                  ? "${items.length} items"
                  : "Items info not available";

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order #...${orderId.substring(orderId.length > 6 ? orderId.length - 6 : 0)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: _getStatusColor(status),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Date: $dateStr",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Total: ₹$totalAmount",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Colors.grey[300]),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            IconlyLight.bag,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              itemsSummary,
                              style: TextStyle(color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
