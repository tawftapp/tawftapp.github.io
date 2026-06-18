import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import 'features/splash/splash_overlay.dart';
import 'features/background/ambient_background.dart';
import 'features/navbar/top_nav_bar.dart';
import 'features/footer/app_footer.dart';
import 'routing/app_router.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      const SplashOverlay(),
      const AmbientBackground(),
      
      const TopNavBar(),
      main_(classes: 'app-main ambient-bg', [const AppRouter()]),
      const AppFooter(),
    ]);
  }
}
