import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class SearchBar extends StatelessComponent {
  final String classes;
  const SearchBar({this.classes = '', super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'search-bar-wrap $classes', [
      div(classes: 'search-bar__glow', []),
      div(classes: 'search-bar', [
        span(classes: 'material-symbols-outlined search-bar__icon', [Component.text('search')]),
        input(classes: 'search-bar__input', type: InputType.text, attributes: {'placeholder': 'Search components...'}),
        div(classes: 'search-bar__badge hide-mobile', [
          span(classes: 'search-bar__shortcut', [Component.text('⌘K')]),
        ]),
      ]),
    ]);
  }
}
