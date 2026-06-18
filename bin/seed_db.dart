import 'dart:io';
import 'package:supabase/supabase.dart';
import 'package:tawft/supabase_options.dart';

// Run with: dart run bin/seed_db.dart
void main() async {
  print('Initializing Supabase connection...');
  final supabase = SupabaseClient(
    SupabaseOptions.url,
    SupabaseOptions.anonKey, // Use anon key or inject service role key securely via env vars for real production
  );

  print('Seeding demo categories...');
  final demoCategories = [
    {'name': 'Navigation', 'sort_order': 1},
    {'name': 'Buttons', 'sort_order': 2},
    {'name': 'Feedback', 'sort_order': 3},
    {'name': 'Data Display', 'sort_order': 4},
    {'name': 'Inputs', 'sort_order': 5},
    {'name': 'Layout', 'sort_order': 6},
  ];

  try {
    for (final cat in demoCategories) {
      await supabase.from('categories').upsert(cat, onConflict: 'name');
    }
    print('✅ Successfully seeded categories!');
  } catch (e) {
    print('❌ Failed to seed categories: $e');
  }

  print('Seeding demo widgets...');

  final demoWidgets = [
    {
      'title': 'Glassmorphic Navigation',
      'description': 'A beautiful, modern frosted glass navigation bar with subtle hover effects and smooth transitions.',
      'category': 'Navigation',
      'tags': ['glassmorphism', 'nav', 'header'],
      'language': 'dart',
      'raw_code': '''
Container(
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.1),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withOpacity(0.2)),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.search, color: Colors.white),
            Icon(Icons.person, color: Colors.white),
          ],
        ),
      ),
    ),
  ),
)
''',
      'preview_file': 'navigation/glass-nav.png',
      'featured': true,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    },
    {
      'title': 'Neumorphic Button',
      'description': 'Soft UI button with realistic shadows and press interactions.',
      'category': 'Buttons',
      'tags': ['neumorphism', 'button', 'interactive'],
      'language': 'dart',
      'raw_code': '''
Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: const Color(0xFFE0E5EC),
    borderRadius: BorderRadius.circular(15),
    boxShadow: const [
      BoxShadow(
        color: Color(0xFFA3B1C6),
        offset: Offset(9, 9),
        blurRadius: 16,
      ),
      BoxShadow(
        color: Colors.white,
        offset: Offset(-9, -9),
        blurRadius: 16,
      ),
    ],
  ),
  child: const Icon(Icons.favorite, color: Colors.pink, size: 30),
)
''',
      'preview_file': 'buttons/neumorphic-btn.png',
      'featured': false,
      'created_at': DateTime.now().subtract(const Duration(days: 1)).toUtc().toIso8601String(),
    },
    {
      'title': 'Skeleton Loader',
      'description': 'Animated shimmer effect for loading states, perfect for content placeholders.',
      'category': 'Feedback',
      'tags': ['loading', 'shimmer', 'skeleton'],
      'language': 'dart',
      'raw_code': '''
import 'package:shimmer/shimmer.dart';

Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(
    width: 200,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
''',
      'preview_file': 'feedback/skeleton.gif',
      'featured': true,
      'created_at': DateTime.now().subtract(const Duration(days: 2)).toUtc().toIso8601String(),
    }
  ];

  try {
    for (final widget in demoWidgets) {
      await supabase.from('widgets').insert(widget);
    }
    print('✅ Successfully seeded ${demoWidgets.length} widgets!');
  } catch (e) {
    print('❌ Failed to seed widgets: $e');
  }
  
  exit(0);
}
