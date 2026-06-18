import 'package:jaspr_riverpod/jaspr_riverpod.dart';

import 'package:jaspr/jaspr.dart' show kIsWeb;
import '../services/supabase_service.dart';

class CategoriesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    if (kIsWeb) {
      Future.microtask(() => _fetchCategories());
    }
    return ['All Components'];
  }

  Future<void> _fetchCategories() async {
    try {
      final dbCategories = await SupabaseService.fetchCategories();
      state = ['All Components', ...dbCategories];
    } catch (e) {
      print('Failed to fetch categories: $e');
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
final selectedCategoryProvider = NotifierProvider<SelectedCategoryNotifier, String>(SelectedCategoryNotifier.new);
