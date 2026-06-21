import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../../core/constants.dart';
import '../../components/search_bar.dart';
import 'hero_3d_area.dart';

class HeroSection extends StatelessComponent {
  const HeroSection({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'hero-section container-max', [
      div(classes: 'hero-left animate-reveal reveal-delay-1', [
        div(classes: 'hero-badge', [span(classes: 'hero-badge__dot', []), Component.text(AppConstants.versionBadge)]),
        h1(classes: 'hero-title', [
          Component.text('Find the perfect '),
          Component.element(tag: 'br'),
          span(classes: 'gradient-text', [Component.text('Flutter widget')]),
          Component.element(tag: 'br'),
          Component.text('instantly.'),
        ]),
        p(classes: 'hero-subtitle', [Component.text(AppConstants.tagline)]),
        const SearchBar(),
      ]),
      div(classes: 'hero-right hide-mobile animate-reveal reveal-delay-2', [const Hero3dArea()]),
    ]);
  }
}
