import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:majorproject/DealerAuth/Model/add_items.model.dart';

final addItemProvider = StateNotifierProvider<AddItemNotifier, AddItemState>((
  ref,
) {
  return AddItemNotifier();
});

class AddItemNotifier extends StateNotifier<AddItemState> {
  AddItemNotifier() : super(AddItemState()) {
    fetchCategories();
  }

  final CollectionReference items = FirebaseFirestore.instance.collection(
    "items",
  );

  final CollectionReference categoriesCollection = FirebaseFirestore.instance
      .collection("Category");

  // Pick image (optional, local only)
  void pickImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage != null) {
        state = state.copyWith(imagePath: pickedImage.path, isLoading: false);
      }
    } catch (e) {
      throw Exception("Error picking image $e");
    }
  }

  void setSelectedCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
  }

  void toggleDiscount(bool? isDiscounted) {
    state = state.copyWith(isDiscounted: isDiscounted);
  }

  void setDiscountPercentage(String? discountPercentage) {
    state = state.copyWith(discountPercentage: discountPercentage);
  }

  void setDescription(String? description) {
    state = state.copyWith(description: description);
  }

  void setQuantity(String? quantity) {
    state = state.copyWith(quantity: quantity);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  // ✅ Fetch categories from Firestore
  Future<void> fetchCategories() async {
    try {
      QuerySnapshot snapshot = await categoriesCollection.get();
      List<String> categories = snapshot.docs
          .map((doc) => doc["name"] as String)
          .toList();

      state = state.copyWith(categories: categories);
    } catch (e) {
      throw Exception("Error fetching categories $e");
    }
  }

  // ✅ Upload and save item (NO Firebase Storage)
  Future<void> uploadAndSaveItem(String name, String price) async {
    if (name.isEmpty ||
        price.isEmpty ||
        state.selectedCategory == null ||
        state.description == null ||
        state.quantity == null ||
        (state.isDiscounted && state.discountPercentage == null)) {
      throw Exception("All fields are required");
    }

    state = state.copyWith(isLoading: true);

    try {
      // Get current user ID
      final String uid = FirebaseAuth.instance.currentUser?.uid ?? "anonymous";

      // ✅ Instead of uploading to Firebase Storage, just store local path or placeholder
      final String imageUrl = state.imagePath != null
          ? state.imagePath!
          : "no_image";

      // ✅ Calculate Prices
      double inputPrice = double.tryParse(price) ?? 0.0;
      double sellingPrice = inputPrice;
      double originalPrice = inputPrice;
      int discountPercent = 0;

      if (state.isDiscounted && state.discountPercentage != null) {
        discountPercent = int.tryParse(state.discountPercentage!) ?? 0;
        if (discountPercent > 0) {
          // Calculate discounted price
          sellingPrice = inputPrice - (inputPrice * discountPercent / 100);
          originalPrice = inputPrice;
        }
      }

      // ✅ Save item directly to Firestore
      await items.add({
        'name': name,
        'price': sellingPrice.toStringAsFixed(
          0,
        ), // Sorting works on this (Actual Cost)
        'originalPrice': originalPrice.toStringAsFixed(0), // Display purpose
        'imageUrl': imageUrl, // local path or placeholder
        'uploadedBy': uid,
        'category': state.selectedCategory,
        'description': state.description,
        'quantity': state.quantity,
        'isDiscounted': state.isDiscounted,
        'discountPercentage': discountPercent,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // ✅ Reset state after success
      state = AddItemState();
    } catch (e) {
      throw Exception("Error saving item: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
