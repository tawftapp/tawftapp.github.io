import 'package:jaspr/jaspr.dart';
import '../features/hero/hero_section.dart';
import '../features/showcase/showcase_section.dart';

class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      const HeroSection(),
      const ShowcaseSection(),
    ]);
  }
}
