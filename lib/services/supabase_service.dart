import 'package:supabase/supabase.dart';
import '../models/widget_showcase_item.dart';
import '../supabase_options.dart';
import '../utils/search_utils.dart';

/// Global Supabase instance (moved here to avoid SSR import issues)
final supabase = SupabaseClient(SupabaseOptions.url, SupabaseOptions.anonKey);

/// Service for interacting with the Supabase `widgets` table.
class SupabaseService {
  static const String _table = 'widgets';
  static const int _legacySearchScanLimit = 1000;

  /// Includes known legacy values that exist in the widgets table so a
  /// category chip does not silently hide records due to old spelling/data.
  static List<String> _categoryValues(String category) {
    return switch (category) {
      'Navigation' => const ['Navigation', 'Navigaton'],
      'Cards' => const ['Cards', ' Cards'],
      'Forms & Input' => const ['Forms & Input', 'Forms & Inputs'],
      _ => [category],
    };
  }

  /// Fetches the initial batch of widgets, optionally filtered by category.
  static Future<List<WidgetShowcaseItem>> fetchInitialWidgets({
    int limit = 10,
    String? category,
    String searchQuery = '',
  }) async {
    var query = supabase.from(_table).select();

    if (category != null && category != 'All Components') {
      query = query.inFilter('category', _categoryValues(category));
    }
    if (searchQuery.isNotEmpty) {
      query = query.ilike('search_text', '%$searchQuery%');
    }

    try {
      final response = await query
          .order('created_at', ascending: false)
          .order('id', ascending: false)
          .limit(limit);

      return (response as List)
          .map((row) => WidgetShowcaseItem.fromMap(row))
          .toList();
    } on PostgrestException catch (error) {
      if (searchQuery.isEmpty || error.code != '42703') rethrow;
      return _legacySearchInitial(
        limit: limit,
        category: category,
        searchQuery: searchQuery,
      );
    }
  }

  /// Fetches the next batch of widgets using keyset pagination (created_at + id).
  static Future<List<WidgetShowcaseItem>> fetchMoreWidgets({
    required DateTime lastCreatedAt,
    required String lastId,
    int limit = 10,
    String? category,
    String searchQuery = '',
  }) async {
    final formattedDate = lastCreatedAt.toUtc().toIso8601String();

    var query = supabase
        .from(_table)
        .select()
        .or(
          'created_at.lt.$formattedDate,and(created_at.eq.$formattedDate,id.lt.$lastId)',
        );

    if (category != null && category != 'All Components') {
      query = query.inFilter('category', _categoryValues(category));
    }
    if (searchQuery.isNotEmpty) {
      query = query.ilike('search_text', '%$searchQuery%');
    }

    try {
      final response = await query
          .order('created_at', ascending: false)
          .order('id', ascending: false)
          .limit(limit);

      return (response as List)
          .map((row) => WidgetShowcaseItem.fromMap(row))
          .toList();
    } on PostgrestException catch (error) {
      if (searchQuery.isEmpty || error.code != '42703') rethrow;
      return _legacySearchMore(
        lastCreatedAt: lastCreatedAt,
        lastId: lastId,
        limit: limit,
        category: category,
        searchQuery: searchQuery,
      );
    }
  }

  /// Fetches only featured widgets (e.g. for a hero section).
  static Future<List<WidgetShowcaseItem>> fetchFeaturedWidgets({
    int limit = 3,
  }) async {
    final response = await supabase
        .from(_table)
        .select()
        .eq('featured', true)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((row) => WidgetShowcaseItem.fromMap(row))
        .toList();
  }

  /// Fetches all dynamic categories ordered by sort_order
  static Future<List<String>> fetchCategories() async {
    final response = await supabase
        .from('categories')
        .select('name')
        .order('sort_order', ascending: true);

    return (response as List).map((row) => row['name'] as String).toList();
  }

  static Future<List<WidgetShowcaseItem>> _legacySearchInitial({
    required int limit,
    required String? category,
    required String searchQuery,
  }) async {
    var query = supabase.from(_table).select();
    if (category != null && category != 'All Components') {
      query = query.inFilter('category', _categoryValues(category));
    }

    final response = await query
        .order('created_at', ascending: false)
        .order('id', ascending: false)
        .limit(_legacySearchScanLimit);

    return (response as List)
        .map((row) => WidgetShowcaseItem.fromMap(row))
        .where((widget) => widgetMatchesSearch(widget, searchQuery))
        .take(limit)
        .toList();
  }

  static Future<List<WidgetShowcaseItem>> _legacySearchMore({
    required DateTime lastCreatedAt,
    required String lastId,
    required int limit,
    required String? category,
    required String searchQuery,
  }) async {
    final formattedDate = lastCreatedAt.toUtc().toIso8601String();
    var query = supabase
        .from(_table)
        .select()
        .or(
          'created_at.lt.$formattedDate,'
          'and(created_at.eq.$formattedDate,id.lt.$lastId)',
        );
    if (category != null && category != 'All Components') {
      query = query.inFilter('category', _categoryValues(category));
    }

    final response = await query
        .order('created_at', ascending: false)
        .order('id', ascending: false)
        .limit(_legacySearchScanLimit);

    return (response as List)
        .map((row) => WidgetShowcaseItem.fromMap(row))
        .where((widget) => widgetMatchesSearch(widget, searchQuery))
        .take(limit)
        .toList();
  }
}
