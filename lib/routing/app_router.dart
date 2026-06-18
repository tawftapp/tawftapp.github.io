import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import '../pages/home_page.dart';

class AppRouter extends StatelessComponent {
  const AppRouter({super.key});

  @override
  Component build(BuildContext context) {
    return Router(
      routes: [
        Route(path: '/', title: "TAWFT — There's A Widget For That", builder: (context, state) => const HomePage()),
      ],
    );
  }
}
