import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class WidgetPreview extends StatelessComponent {
  final List<Component> children;
  final String classes;

  const WidgetPreview({required this.children, this.classes = '', super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'widget-preview $classes', [
      div(classes: 'widget-preview__content', children),
    ]);
  }
}
