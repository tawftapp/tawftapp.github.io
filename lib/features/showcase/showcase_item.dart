import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../../models/widget_showcase_item.dart';
import '../../components/code_preview.dart';
import '../../components/widget_preview.dart';
import '../../services/storage_service.dart';

class ShowcaseItem extends StatefulComponent {
  final WidgetShowcaseItem item;
  final bool isReversed;

  const ShowcaseItem({required this.item, this.isReversed = false, super.key});

  @override
  State<ShowcaseItem> createState() => _ShowcaseItemState();
}

class _ShowcaseItemState extends State<ShowcaseItem> {
  bool _isCodeExpanded = false;
  bool _isPreviewLoaded = false;

  @override
  void didUpdateComponent(ShowcaseItem oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (oldComponent.item.previewFile != component.item.previewFile) {
      _isPreviewLoaded = false;
    }
  }

  void _toggleCode() {
    setState(() => _isCodeExpanded = !_isCodeExpanded);
  }

  void _markPreviewLoaded() {
    if (!_isPreviewLoaded) {
      setState(() => _isPreviewLoaded = true);
    }
  }

  @override
  Component build(BuildContext context) {
    final isVideo = StorageService.isVideo(component.item.previewFile);
    final preview = WidgetPreview(
      classes:
          'showcase-item__preview '
          '${_isPreviewLoaded ? 'widget-preview--loaded' : ''}',
      children: _buildPreviewContent(),
    );
    final code = CodePreview(
      title: component.item.title,
      rawCode: component.item.rawCode,
      classes: 'showcase-item__code',
    );

    return div(
      classes:
          'showcase-item '
          '${component.isReversed ? 'showcase-item--reversed ' : ''}'
          '${isVideo ? 'showcase-item--mobile-code-toggle ' : ''}'
          '${_isCodeExpanded ? 'showcase-item--code-expanded' : ''}',
      component.isReversed ? [code, preview] : [preview, code],
    );
  }

  List<Component> _buildPreviewContent() {
    final item = component.item;
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
            preload: Preload.auto,
            attributes: {
              'playsinline': '',
              'aria-label': '${item.title} preview',
            },
            events: {
              'canplay': (_) => _markPreviewLoaded(),
              'loadeddata': (_) => _markPreviewLoaded(),
              'playing': (_) => _markPreviewLoaded(),
              'error': (_) => _markPreviewLoaded(),
            },
          ),
          div(classes: 'widget-preview__video-overlay', [
            span(classes: 'widget-preview__video-title', [
              Component.text(item.title),
            ]),
          ]),
          button(
            classes:
                'widget-preview__code-toggle '
                '${_isCodeExpanded ? 'widget-preview__code-toggle--expanded' : ''}',
            type: ButtonType.button,
            attributes: {
              'aria-label': _isCodeExpanded
                  ? 'Collapse code for ${item.title}'
                  : 'Expand code for ${item.title}',
              'aria-expanded': _isCodeExpanded.toString(),
            },
            onClick: _toggleCode,
            [
              span(
                classes: 'material-symbols-outlined widget-preview__code-icon',
                [Component.text('code')],
              ),
              span(
                classes:
                    'material-symbols-outlined widget-preview__code-chevron',
                [
                  Component.text(
                    _isCodeExpanded ? 'keyboard_arrow_up' : 'keyboard_arrow_down',
                  ),
                ],
              ),
            ],
          ),
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
        events: {
          'load': (_) => _markPreviewLoaded(),
          'error': (_) => _markPreviewLoaded(),
        },
        alt: item.title,
      ),
    ];
  }
}
