import '../models/widget_showcase_item.dart';

String normalizeSearchText(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'\bsilvers?\b'), 'sliver')
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

bool widgetMatchesSearch(WidgetShowcaseItem widget, String query) {
  final normalizedQuery = normalizeSearchText(query);
  if (normalizedQuery.isEmpty) return true;

  return normalizeSearchText(widget.title).contains(normalizedQuery) ||
      normalizeSearchText(widget.description).contains(normalizedQuery) ||
      normalizeSearchText(widget.category).contains(normalizedQuery) ||
      normalizeSearchText(widget.language).contains(normalizedQuery) ||
      widget.tags.any(
        (tag) => normalizeSearchText(tag).contains(normalizedQuery),
      );
}
