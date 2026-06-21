import 'package:test/test.dart';
import 'package:tawft/models/widget_showcase_item.dart';

void main() {
  test('supports both current and legacy preview column names', () {
    final common = <String, dynamic>{
      'id': '1',
      'title': 'Example',
      'category': 'Cards',
      'raw_code': '',
      'language': 'dart',
      'description': '',
      'tags': <String>[],
      'featured': false,
      'created_at': '2026-01-01T00:00:00Z',
    };

    expect(
      WidgetShowcaseItem.fromMap({
        ...common,
        'preview_file': 'cards/current.png',
      }).previewFile,
      'cards/current.png',
    );
    expect(
      WidgetShowcaseItem.fromMap({
        ...common,
        'preview_asset': 'cards/legacy.png',
      }).previewFile,
      'cards/legacy.png',
    );
  });
}
