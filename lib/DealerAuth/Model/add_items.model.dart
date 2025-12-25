class AddItemState {
  final String? imagePath;
  final bool isLoading;
  final String? selectedCategory;
  final List<String>? categories;
  final String? description;
  final String? quantity;
  final bool isDiscounted;
  final String? discountPercentage;

  AddItemState({
    this.imagePath,
    this.isLoading = false,
    this.selectedCategory,
    this.categories = const [],
    this.description,
    this.quantity,
    this.isDiscounted = false,
    this.discountPercentage,
  });
  AddItemState copyWith({
    String? imagePath,
    bool? isLoading,
    String? selectedCategory,
    List<String>? categories,
    String? description,
    String? quantity,
    bool? isDiscounted,
    String? discountPercentage,
  }) {
    return AddItemState(
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      isDiscounted: isDiscounted ?? this.isDiscounted,
      discountPercentage: discountPercentage ?? this.discountPercentage,
    );
  }
}