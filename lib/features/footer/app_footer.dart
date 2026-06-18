import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../../core/constants.dart';

class AppFooter extends StatelessComponent {
  const AppFooter({super.key});

  @override
  Component build(BuildContext context) {
    return footer(classes: 'app-footer', [
      div(classes: 'app-footer__container container-max', [
        div(classes: 'app-footer__brand', [
          div(classes: 'app-footer__logo', [Component.text(AppConstants.brandName)]),
          div(classes: 'app-footer__copyright', [Component.text(AppConstants.copyright)]),
        ]),
        div(classes: 'app-footer__links', [
          for (var i = 0; i < AppConstants.socialLabels.length; i++)
            a(href: AppConstants.socialUrls[i], classes: 'app-footer__link', [Component.text(AppConstants.socialLabels[i])]),
        ]),
      ]),
    ]);
  }
}
