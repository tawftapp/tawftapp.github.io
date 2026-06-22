/// App-wide constants for the TAWFT application.
abstract class AppConstants {
  AppConstants._();

  // ─── Brand ──────────────────────────────────────────────────
  static const String brandName = 'TAWFT.';
  static const String brandFullName = "There's A Widget For That";
  static const String tagline =
      'Immersive UI components. Live previews. '
      'Production-ready code. Engineered for modern applications.';
  static const String heroTitle = 'Find the perfect Flutter widget instantly.';
  static const String copyright =
      '© 2024 There\'s A Widget For That. Built for Flutter developers.';

  // ─── Navigation ─────────────────────────────────────────────
  static const List<String> navLabels = [
    'Explore',
    'Components',
    'Templates',
    'Pricing',
    'Docs',
  ];

  static const List<String> navPaths = [
    '/',
    '/components',
    '/templates',
    '/pricing',
    '/docs',
  ];

  // ─── Social / Footer Links ─────────────────────────────────
  static const List<String> socialLabels = [
    'Twitter',
    'GitHub',
    'Discord',
    'Status',
    'Terms',
  ];

  static const List<String> socialUrls = [
    'https://twitter.com',
    'https://github.com',
    'https://discord.com',
    'https://status.tawft.dev',
    '/terms',
  ];

  // ─── Categories ─────────────────────────────────────────────
  static const List<String> defaultCategories = [
    'All Components',
    'Navigation',
    'Data Display',
    'Input',
    'Layout',
    'Feedback',
  ];
}
