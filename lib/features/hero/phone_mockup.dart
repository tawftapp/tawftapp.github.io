import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class PhoneMockup extends StatelessComponent {
  const PhoneMockup({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'phone-mockup rotate-3d animate-float', [
      div(classes: 'phone-mockup__overlay', []),
      div(classes: 'phone-mockup__screen', [
        div(classes: 'phone-mockup__header', [
          div(classes: 'phone-mockup__header-bar', []),
          div(classes: 'phone-mockup__header-icon', [
            span(
              classes: 'material-symbols-outlined',
              styles: Styles(raw: {'font-size': '12px', 'color': 'rgba(255,255,255,0.5)'}),
              [Component.text('notifications')],
            ),
          ]),
        ]),
        div(classes: 'phone-mockup__hero', [div(classes: 'phone-mockup__shimmer', [])]),
        _buildListItem('rgba(220,184,255,0.1)', 75, 50),
        _buildListItem('rgba(255,184,106,0.1)', 66, 33),
        div(classes: 'phone-mockup__bottom-nav', [
          div(classes: 'phone-mockup__nav-dot phone-mockup__nav-dot--active', []),
          div(classes: 'phone-mockup__nav-dot', []),
          div(classes: 'phone-mockup__nav-dot', []),
        ]),
      ]),
    ]);
  }

  Component _buildListItem(String accentColor, int bar1, int bar2) {
    return div(classes: 'phone-mockup__list-item', [
      div(classes: 'phone-mockup__list-icon', styles: Styles(raw: {'background': accentColor}), []),
      div(classes: 'phone-mockup__list-text', [
        div(classes: 'phone-mockup__list-bar', styles: Styles(raw: {'width': '$bar1%'}), []),
        div(classes: 'phone-mockup__list-bar phone-mockup__list-bar--dim', styles: Styles(raw: {'width': '$bar2%'}), []),
      ]),
    ]);
  }
}
