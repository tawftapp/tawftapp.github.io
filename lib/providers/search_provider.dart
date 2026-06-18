import 'package:jaspr_riverpod/legacy.dart';

/// Provider for the current search query string.
final searchQueryProvider = StateProvider<String>((ref) => '');
