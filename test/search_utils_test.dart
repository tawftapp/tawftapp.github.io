import 'package:test/test.dart';
import 'package:tawft/models/widget_showcase_item.dart';
import 'package:tawft/utils/search_utils.dart';

void main() {
  final widget = WidgetShowcaseItem(
    id: '1',
    title: 'Sliver App Bar',
    category: 'Slivers & Scroll Effects',
    rawCode: '',
    language: 'dart',
    previewFile: 'slivers/app-bar.mp4',
    description: 'A collapsible scrolling header.',
    tags: const ['animation', 'material'],
    featured: false,
    createdAt: DateTime.utc(2026),
  );

  test('normalizes punctuation and common sliver typo', () {
    expect(normalizeSearchText('  SILVERS & Scroll  '), 'sliver scroll');
  });

  test('matches title, category, description, language, and tags', () {
    expect(widgetMatchesSearch(widget, 'silver app'), isTrue);
    expect(widgetMatchesSearch(widget, 'scroll effects'), isTrue);
    expect(widgetMatchesSearch(widget, 'collapsible'), isTrue);
    expect(widgetMatchesSearch(widget, 'dart'), isTrue);
    expect(widgetMatchesSearch(widget, 'animation'), isTrue);
    expect(widgetMatchesSearch(widget, 'navigation drawer'), isFalse);
  });
}
