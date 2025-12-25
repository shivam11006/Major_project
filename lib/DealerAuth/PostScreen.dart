import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Controller/add_iterms.controller.dart';
import '../Services/TranslationService.dart';
import 'package:majorproject/utils.dart';

class PostScreen extends ConsumerWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addItemProvider);
    final notifier = ref.read(addItemProvider.notifier);
    final currentLang = ref.watch(languageProvider);
    String tr(String key) => AppLocalizations.of(currentLang, key);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          tr('post_your_products'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // ✅ Allows the screen to resize when the keyboard opens
      resizeToAvoidBottomInset: true,

      // ✅ Safe scrolling layout
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: state.imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(state.imagePath!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GestureDetector(
                          onTap: notifier.pickImage,
                          child: const Icon(Icons.camera_alt, size: 50),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Product Name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: tr('product_name'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ✅ Price
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: tr('price'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ✅ Description
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: tr('description'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: notifier.setDescription,
              ),
              const SizedBox(height: 12),

              // ✅ Category Dropdown
              DropdownButtonFormField<String>(
                value: state.selectedCategory,
                decoration: InputDecoration(
                  labelText: tr('select_category'),
                  border: const OutlineInputBorder(),
                ),
                onChanged: notifier.setSelectedCategory,
                items: state.categories?.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // ✅ Quantity
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: tr('quantity_kg'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: notifier.setQuantity,
              ),
              const SizedBox(height: 12),

              // ✅ Discount Section
              Row(
                children: [
                  Checkbox(
                    value: state.isDiscounted,
                    onChanged: notifier.toggleDiscount,
                  ),
                  Text(tr('apply_discount')),
                ],
              ),

              if (state.isDiscounted)
                TextField(
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: tr('discount_percentage'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: notifier.setDiscountPercentage,
                ),

              const SizedBox(height: 100), // 👈 Extra bottom space for scroll
            ],
          ),
        ),
      ),

      // ✅ Bottom button (stays visible)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: state.isLoading
                ? null
                : () async {
                    try {
                      await notifier.uploadAndSaveItem(
                        _nameController.text.trim(),
                        _priceController.text.trim(),
                      );

                      showAppSnackbar(
                        context: context,
                        type: SnackbarType.success,
                        description: tr('upload_success'),
                      );

                      // Clear all fields after success
                      _nameController.clear();
                      _priceController.clear();
                      _descriptionController.clear();
                      _quantityController.clear();
                      _discountController.clear();
                    } catch (e) {
                      showAppSnackbar(
                        context: context,
                        type: SnackbarType.error,
                        description: tr('all_fields_required'),
                      );
                    }
                  },
            child: state.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    tr('post_product_btn'),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }
}
