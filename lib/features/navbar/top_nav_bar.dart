import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class TopNavBar extends StatelessComponent {
  final String currentPath;
  const TopNavBar({this.currentPath = '/', super.key});

  @override
  Component build(BuildContext context) {
    return nav(classes: 'top-nav animate-reveal', [
      div(classes: 'top-nav__container container-max', [
        a(href: './', classes: 'top-nav__logo', [
          Component.text("TAWFT - There's a widget for that"),
        ]),
      ]),
    ]);
  }
}
