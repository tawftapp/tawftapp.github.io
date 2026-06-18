import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class SplashOverlay extends StatelessComponent {
  const SplashOverlay({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'splash-overlay animate-splash', [
      div(classes: 'splash-overlay__inner', [
        div(classes: 'splash-overlay__glow animate-pulse-glow', []),
        h1(classes: 'splash-overlay__logo', [Component.text('TAWFT.')]),
        div(classes: 'splash-overlay__author', [Component.text('By Himanshu Khare')]),
        div(classes: 'splash-overlay__line', [div(classes: 'splash-overlay__line-fill', [])]),
      ]),
    ]);
  }
}
