import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majorproject/utils.dart';

class DealerPostItemsList extends ConsumerStatefulWidget {
  @override
  ConsumerState<DealerPostItemsList> createState() =>
      _DealerPostItemsListState();
}

class _DealerPostItemsListState extends ConsumerState<DealerPostItemsList> {
  final CollectionReference items = FirebaseFirestore.instance.collection(
    "items",
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? selectedCategory;
  List<String> categories = [];

  @override
  void initState() {
    fetchCategories();
    super.initState();
  }

  Future<void> fetchCategories() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Category")
        .get();
    setState(() {
      categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  // ...

  // 🔹 Function to delete item
  Future<void> deleteItem(String id) async {
    try {
      await items.doc(id).delete();
      showAppSnackbar(
        context: context,
        type: SnackbarType.success,
        description: "Item deleted successfully",
      );
    } catch (e) {
      showAppSnackbar(
        context: context,
        type: SnackbarType.error,
        description: "Error deleting item: $e",
      );
    }
  }

  // 🔹 Function to edit (modify) item
  Future<void> editItem(
    BuildContext context,
    String id,
    Map<String, dynamic> item,
  ) async {
    TextEditingController nameController = TextEditingController(
      text: item['name'],
    );
    TextEditingController priceController = TextEditingController(
      text: item['price'].toString(),
    );
    TextEditingController descController = TextEditingController(
      text: item['description'] ?? "",
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Product"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Product Name"),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Price"),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Description"),
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
              onPressed: () async {
                await items.doc(id).update({
                  'name': nameController.text.trim(),
                  'price': double.tryParse(priceController.text) ?? 0,
                  'description': descController.text.trim(),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Item updated successfully")),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // 🔹 View product details dialog
  void viewItem(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item['name'] ?? "Product Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item['imageUrl'] != null &&
                item['imageUrl'].toString().isNotEmpty)
              CachedNetworkImage(
                imageUrl: item['imageUrl'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 10),
            Text("Price: ₹${item['price'] ?? 'N/A'}"),
            const SizedBox(height: 5),
            Text("Category: ${item['category'] ?? 'N/A'}"),
            const SizedBox(height: 5),
            Text("Description: ${item['description'] ?? 'No description'}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String uid = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Your Posts",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Category Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Filter by Category:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedCategory,
                    hint: const Text("All"),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text("All Categories"),
                      ),
                      ...categories.map((String category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    ],
                    icon: const Icon(Icons.tune),
                    underline: const SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Firestore Stream
            StreamBuilder<QuerySnapshot>(
              stream: selectedCategory == null
                  ? items.where("uploadedBy", isEqualTo: uid).snapshots()
                  : items
                        .where("uploadedBy", isEqualTo: uid)
                        .where('category', isEqualTo: selectedCategory)
                        .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(color: Colors.green),
                    ),
                  );
                }

                final documents = snapshot.data?.docs ?? [];

                if (documents.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "No items found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final doc = documents[index];
                    final item = doc.data() as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green.shade50,
                        elevation: 2,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                                (item['imageUrl'] != null &&
                                    item['imageUrl'].toString().isNotEmpty)
                                ? CachedNetworkImage(
                                    imageUrl: item['imageUrl'],
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                          "assets/placeholder.png",
                                          fit: BoxFit.cover,
                                          height: 60,
                                          width: 60,
                                        ),
                                  )
                                : Image.asset(
                                    "assets/placeholder.png",
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          title: Text(
                            item['name'] ?? "N/A",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                item['price'] != null
                                    ? "₹${item['price']}"
                                    : "N/A",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text("${item['category'] ?? "N/A"}"),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'view') {
                                viewItem(context, item);
                              } else if (value == 'edit') {
                                editItem(context, doc.id, item);
                              } else if (value == 'delete') {
                                deleteItem(doc.id);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'view',
                                child: Text('View'),
                              ),
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
