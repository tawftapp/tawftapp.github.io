import 'package:jaspr_riverpod/jaspr_riverpod.dart';

import '../services/supabase_service.dart';

class CategoriesNotifier extends Notifier<List<String>> {
  static const fallbackCategories = [
    'All Components',
    'Navigation',
    'Cards',
    'Micro Interactions',
    'Slivers & Scroll Effects',
    'Buttons',
    'Forms & Inputs',
    'Chat & Messaging',
  ];

  @override
  List<String> build() => ['All Components'];

  Future<void> load() async {
    try {
      final dbCategories = await SupabaseService.fetchCategories();
      state = [
        'All Components',
        ...dbCategories
            .map((category) => category.trim())
            .map(
              (category) =>
                  category == 'Forms & Input' ? 'Forms & Inputs' : category,
            )
            .toSet(),
      ];
    } catch (e) {
      state = fallbackCategories;
    }
  }
}

/// Provides a list of available categories for filtering.
final categoriesProvider = NotifierProvider<CategoriesNotifier, List<String>>(
  () => CategoriesNotifier(),
);

class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'All Components';

  void setCategory(String category) {
    state = category;
  }
}

/// Tracks the currently selected category.
final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(
      SelectedCategoryNotifier.new,
    );
