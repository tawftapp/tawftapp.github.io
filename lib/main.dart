import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'features/splash/splash_overlay.dart';
import 'features/background/ambient_background.dart';
import 'features/navbar/top_nav_bar.dart';
import 'features/footer/app_footer.dart';
import 'providers/pagination_provider.dart';
import 'routing/app_router.dart';

class App extends StatefulComponent {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _minimumSplashElapsed = false;
  bool _isSplashDismissed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        setState(() => _minimumSplashElapsed = true);
      }
    });
  }

  @override
  Component build(BuildContext context) {
    final paginationState = context.watch(paginationProvider);
    final isFirstPageReady =
        !paginationState.isInitialLoading &&
        (paginationState.widgets.isNotEmpty || paginationState.error != null);
    final canDismissSplash =
        !kIsWeb || (_minimumSplashElapsed && isFirstPageReady);
    if (canDismissSplash && !_isSplashDismissed) {
      Future.microtask(() {
        if (mounted) {
          setState(() => _isSplashDismissed = true);
        }
      });
    }
    final hideSplash = _isSplashDismissed || canDismissSplash;

    return Component.fragment([
      SplashOverlay(isHidden: hideSplash),
      const AmbientBackground(),

      const TopNavBar(),
      main_(classes: 'app-main ambient-bg', [const AppRouter()]),
      const AppFooter(),
    ]);
  }
}
