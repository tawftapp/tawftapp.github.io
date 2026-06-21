import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../../models/widget_showcase_item.dart';
import '../../components/code_preview.dart';
import '../../components/widget_preview.dart';
import '../../services/storage_service.dart';

class ShowcaseItem extends StatelessComponent {
  final WidgetShowcaseItem item;
  final bool isReversed;

  const ShowcaseItem({required this.item, this.isReversed = false, super.key});

  @override
  Component build(BuildContext context) {
    final preview = WidgetPreview(
      classes: 'showcase-item__preview',
      children: _buildPreviewContent(),
    );
    final code = CodePreview(
      title: item.title,
      rawCode: item.rawCode,
      classes: 'showcase-item__code',
    );

    return article(classes: 'showcase-item', [
      header(classes: 'showcase-item__header', [
        div(classes: 'showcase-item__eyebrow', [Component.text(item.category)]),
        h3(classes: 'showcase-item__title', [Component.text(item.title)]),
        p(classes: 'showcase-item__description', [
          Component.text(item.description),
        ]),
      ]),
      div(
        classes:
            'showcase-item__content ${isReversed ? 'showcase-item__content--reversed' : ''}',
        isReversed ? [code, preview] : [preview, code],
      ),
    ]);
  }

  List<Component> _buildPreviewContent() {
    final url = StorageService.getPreviewUrl(item.previewFile);
    final isVideo = StorageService.isVideo(item.previewFile);

    if (url == null) {
      return [
        div(classes: 'widget-preview__unavailable', [
          span(
            classes:
                'material-symbols-outlined widget-preview__unavailable-icon',
            [Component.text('broken_image')],
          ),
          Component.text('Preview unavailable'),
        ]),
      ];
    }

    if (isVideo) {
      return [
        video(
          [],
          src: url,
          classes: 'widget-preview__img',
          autoplay: false,
          controls: true,
          loop: false,
          muted: true,
          preload: Preload.none,
          attributes: {
            'playsinline': '',
            'aria-label': '${item.title} preview',
          },
        ),
      ];
    }

    return [
      img(
        src: url,
        classes: 'widget-preview__img',
        attributes: {
          'loading': 'lazy',
          'decoding': 'async',
          'referrerpolicy': 'no-referrer',
        },
        alt: item.title,
      ),
    ];
  }
}
