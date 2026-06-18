import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class CategoryChip extends StatelessComponent {
  final String label;
  final bool isSelected;
  final String classes;
  final Map<String, EventCallback>? events;

  const CategoryChip({
    required this.label, 
    this.isSelected = false, 
    this.classes = '', 
    this.events,
    super.key
  });

  @override
  Component build(BuildContext context) {
    final cls = isSelected ? 'category-chip category-chip--active $classes' : 'category-chip $classes';
    return button(
      classes: cls, 
      events: events,
      [Component.text(label)]
    );
  }
}
