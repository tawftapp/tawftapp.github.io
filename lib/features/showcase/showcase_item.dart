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
    final isVideo = item.previewFile.toLowerCase().endsWith('.mp4') || 
                    item.previewFile.toLowerCase().endsWith('.webm');

    if (isVideo) {
      final videoId = 'vid-\${url.hashCode}';
      return [
        RawText('''
          <video 
            id="$videoId" 
            class="widget-preview__img" 
            src="$url" 
            autoplay 
            loop 
            muted 
            playsinline 
            oncanplay="this.muted=true; this.play();"
          ></video>
        ''')
      ];
    }

    return [
      img(
        src: url, 
        classes: 'widget-preview__img',
        attributes: {'loading': 'lazy'},
        alt: item.title,
      )
    ];
  }
}

