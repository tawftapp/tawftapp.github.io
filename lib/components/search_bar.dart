import 'dart:async';

import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../providers/search_provider.dart';

class SearchBar extends StatefulComponent {
  final String classes;

  const SearchBar({this.classes = '', super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Timer? _debounce;
  String _value = '';

  void _updateQuery(BuildContext context, String value) {
    final sanitizedValue = value
        .replaceAll(RegExp(r'[^a-zA-Z\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');

    setState(() => _value = sanitizedValue);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) {
        context.read(searchQueryProvider.notifier).state = sanitizedValue
            .trim();
      }
    });
  }

  void _clearQuery(BuildContext context) {
    _debounce?.cancel();
    setState(() => _value = '');
    context.read(searchQueryProvider.notifier).state = '';
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'search-bar-wrap ${component.classes}', [
      div(classes: 'search-bar__glow', []),
      div(classes: 'search-bar', [
        span(classes: 'material-symbols-outlined search-bar__icon', [
          Component.text('search'),
        ]),
        input<String>(
          id: 'component-search',
          classes: 'search-bar__input',
          type: InputType.search,
          value: _value,
          onInput: (value) => _updateQuery(context, value),
          attributes: {
            'placeholder': 'Search components...',
            'aria-label': 'Search components',
            'autocomplete': 'off',
            'spellcheck': 'false',
            'maxlength': '80',
            'pattern': '[A-Za-z ]*',
            'title': 'Use letters and spaces only',
          },
        ),
        if (_value.isNotEmpty)
          button(
            classes: 'search-bar__clear',
            type: ButtonType.button,
            attributes: {'aria-label': 'Clear search'},
            onClick: () => _clearQuery(context),
            [
              span(
                classes: 'material-symbols-outlined search-bar__clear-icon',
                [Component.text('close')],
              ),
            ],
          ),
      ]),
    ]);
  }
}
