import 'package:supabase/supabase.dart';
import '../models/widget_showcase_item.dart';
import '../supabase_options.dart';

/// Global Supabase instance (moved here to avoid SSR import issues)
final supabase = SupabaseClient(
  SupabaseOptions.url,
  SupabaseOptions.anonKey,
);

/// Service for interacting with the Supabase `widgets` table.
class SupabaseService {
  static const String _table = 'widgets';

  /// Fetches the initial batch of widgets, optionally filtered by category.
  static Future<List<WidgetShowcaseItem>> fetchInitialWidgets({
    int limit = 10,
    String? category,
  }) async {
    var query = supabase.from(_table).select();

    if (category != null && category != 'All Components') {
      query = query.eq('category', category);
    }

    final response = await query
        .order('created_at', ascending: false)
        .order('id', ascending: false)
        .limit(limit);

    return (response as List).map((row) => WidgetShowcaseItem.fromMap(row)).toList();
  }

  /// Fetches the next batch of widgets using keyset pagination (created_at + id).
  static Future<List<WidgetShowcaseItem>> fetchMoreWidgets({
    required DateTime lastCreatedAt,
    required String lastId,
    int limit = 10,
    String? category,
  }) async {
    final formattedDate = lastCreatedAt.toUtc().toIso8601String();
    
    var query = supabase
        .from(_table)
        .select()
        .or('created_at.lt.$formattedDate,and(created_at.eq.$formattedDate,id.lt.$lastId)');

    if (category != null && category != 'All Components') {
      query = query.eq('category', category);
    }

    final response = await query
        .order('created_at', ascending: false)
        .order('id', ascending: false)
        .limit(limit);

    return (response as List).map((row) => WidgetShowcaseItem.fromMap(row)).toList();
  }

  /// Fetches only featured widgets (e.g. for a hero section).
  static Future<List<WidgetShowcaseItem>> fetchFeaturedWidgets({int limit = 3}) async {
    final response = await supabase
        .from(_table)
        .select()
        .eq('featured', true)
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List).map((row) => WidgetShowcaseItem.fromMap(row)).toList();
  }

  /// Fetches all dynamic categories ordered by sort_order
  static Future<List<String>> fetchCategories() async {
    final response = await supabase
        .from('categories')
        .select('name')
        .order('sort_order', ascending: true);
        
    return (response as List).map((row) => row['name'] as String).toList();
  }
}
