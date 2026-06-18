import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class SectionHeading extends StatelessComponent {
  final String title;
  final String classes;
  const SectionHeading({required this.title, this.classes = '', super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'section-heading $classes', [
      h2(classes: 'section-heading__title', [Component.text(title)]),
    ]);
  }
}
