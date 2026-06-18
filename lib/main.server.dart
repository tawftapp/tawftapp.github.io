import 'package:jaspr/server.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'main.dart';

/// Application entry point.
void main() {
  Jaspr.initializeApp();

  runApp(
    Document(
      title: "TAWFT — There's A Widget For That",
      meta: {
        'description':
            'Premium Flutter widget gallery with live previews, production-ready code, and immersive UI components.',
        'viewport': 'width=device-width, initial-scale=1.0',
        'theme-color': '#131313',
        'robots': 'index, follow',
        'og:title': "TAWFT — There's A Widget For That",
        'og:description':
            'Premium Flutter widget gallery with live previews and production-ready code.',
        'og:type': 'website',
      },
      head: [
        // Google Fonts
        link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
        link(
          rel: 'preconnect',
          href: 'https://fonts.gstatic.com',
          attributes: {'crossorigin': ''},
        ),
        link(
          rel: 'stylesheet',
          href:
              'https://fonts.googleapis.com/css2?family=Geist:wght@400;600;700&family=Inter:wght@400&family=JetBrains+Mono:wght@400&display=swap',
        ),
        // Material Symbols Outlined
        link(
          rel: 'stylesheet',
          href:
              'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap',
        ),
        // External CSS
        link(rel: 'stylesheet', href: '/styles.css'),
        // Prism.js Syntax Highlighting CSS
        link(rel: 'stylesheet', href: '/css/prism.css'),
        link(rel: 'stylesheet', href: '/css/prism-line-numbers.css'),
        // Prism.js JS and Plugins
        script(src: '/js/prism.js', defer: true),
        script(src: '/js/prism-dart.js', defer: true),
        script(src: '/js/prism-line-numbers.js', defer: true),
        script(src: 'main.client.dart.js', defer: true),
      ],
      body: ProviderScope(child: const App()),
    ),
  );
}
