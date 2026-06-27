import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class AmbientBackground extends StatelessComponent {
  const AmbientBackground({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'ambient-bg-container', []);
  }
}
