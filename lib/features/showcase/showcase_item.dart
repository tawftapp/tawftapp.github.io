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

    return div(
      classes: 'showcase-item ${isReversed ? 'showcase-item--reversed' : ''}',
      isReversed ? [code, preview] : [preview, code],
    );
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
        div(classes: 'widget-preview__video-wrap', [
          video(
            [],
            src: url,
            classes: 'widget-preview__img',
            autoplay: true,
            loop: true,
            muted: true,
            preload: Preload.metadata,
            attributes: {
              'playsinline': '',
              'aria-label': '${item.title} preview',
            },
          ),
          div(classes: 'widget-preview__video-overlay', [
            span(classes: 'widget-preview__video-title', [
              Component.text(item.title),
            ]),
          ]),
        ]),
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
