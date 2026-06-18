import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../utils/js_utils.dart';

class CodePreview extends StatefulComponent {
  final String title;
  final String rawCode;
  final String classes;

  const CodePreview({
    required this.title,
    required this.rawCode,
    this.classes = '',
    super.key,
  });

  @override
  State<CodePreview> createState() => _CodePreviewState();
}

class _CodePreviewState extends State<CodePreview> {
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _triggerHighlight();
  }

  @override
  void didUpdateComponent(CodePreview oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (oldComponent.rawCode != component.rawCode) {
      _triggerHighlight();
    }
  }

  void _triggerHighlight() {
    // Safely trigger syntax highlighting post-render on the browser
    highlightCode(_elementId);
  }

  void _copyCode() {
    copyToClipboard(component.rawCode);
    setState(() {
      _copied = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });
  }

  String get _filename => '${component.title.toLowerCase().replaceAll(' ', '_')}.dart';
  String get _elementId => 'code-${component.key?.hashCode ?? component.hashCode}';

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'code-editor-wrapper ${component.classes}',
      [
        div(classes: 'code-editor-container', [
          // macOS window top bar
          div(classes: 'mac-titlebar', [
            div(classes: 'mac-dots', [
              div(classes: 'mac-dot mac-dot-red', []),
              div(classes: 'mac-dot mac-dot-yellow', []),
              div(classes: 'mac-dot mac-dot-green', []),
            ]),
            span(classes: 'mac-filename', [Component.text(_filename)]),
            button(
              classes: 'copy-btn ${_copied ? 'copy-btn--success' : ''}',
              events: {
                'click': (_) => _copyCode(),
              },
              [
                span(
                  classes: 'material-symbols-outlined copy-icon',
                  [Component.text(_copied ? 'check' : 'content_copy')],
                ),
              ],
            ),
          ]),
          // Pre & Code sections for Prism.js
          div(classes: 'code-editor-body', [
            Component.element(
              tag: 'pre',
              classes: 'line-numbers code-editor-pre',
              children: [
                Component.element(
                  tag: 'code',
                  id: _elementId,
                  classes: 'language-dart code-editor-code',
                  children: [Component.text(component.rawCode)],
                ),
              ],
            ),
          ]),
        ]),
      ],
    );
  }
}

