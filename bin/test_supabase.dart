import 'package:supabase/supabase.dart';
import 'package:tawft/models/widget_showcase_item.dart';
import 'package:tawft/supabase_options.dart';

void main() async {
  final supabase = SupabaseClient(SupabaseOptions.url, SupabaseOptions.anonKey);

  try {
    print('Testing widgets...');
    final res1 = await supabase.from('widgets').select().limit(1);
    final map = res1.first;
    print('Map title: ${map['title']}');
    final item = WidgetShowcaseItem.fromMap(map);
    print('Success: ${item.title}');
  } catch (e, st) {
    print('ERROR: $e\n$st');
  }
}
