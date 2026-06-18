/// Data model for a widget showcase entry displayed in the
/// curated components section.
class WidgetShowcaseItem {
  final String id;
  final String title;
  final String category;
  final String rawCode;
  final String language;
  final String previewFile;
  final String description;
  final List<String> tags;
  final bool featured;
  final DateTime createdAt;

  const WidgetShowcaseItem({
    required this.id,
    required this.title,
    required this.category,
    required this.rawCode,
    required this.language,
    required this.previewFile,
    required this.description,
    required this.tags,
    required this.featured,
    required this.createdAt,
  });

  factory WidgetShowcaseItem.fromMap(Map<String, dynamic> map) {
    return WidgetShowcaseItem(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Untitled',
      category: map['category'] as String? ?? 'Uncategorized',
      rawCode: map['raw_code'] as String? ?? '',
      language: map['language'] as String? ?? 'dart',
      previewFile: map['preview_file'] as String? ?? map['preview_asset'] as String? ?? '',
      description: map['description'] as String? ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      featured: map['featured'] as bool? ?? false,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'] as String) : DateTime.now(),
    );
  }
}

