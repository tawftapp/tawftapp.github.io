// ignore_for_file: deprecated_member_use
import 'dart:js' as js;
import 'dart:html' as html;

void highlightCode(String elementId) {
  try {
    html.window.requestAnimationFrame((_) {
      try {
        final prism = js.context['Prism'];
        final element = html.document.getElementById(elementId);
        if (prism != null && element != null) {
          prism.callMethod('highlightElement', [element]);
        }
      } catch (_) {}
    });
  } catch (_) {
    try {
      final prism = js.context['Prism'];
      final element = html.document.getElementById(elementId);
      if (prism != null && element != null) {
        prism.callMethod('highlightElement', [element]);
      }
    } catch (_) {}
  }
}

void copyToClipboard(String text) {
  try {
    final clipboard = js.context['navigator']['clipboard'];
    clipboard?.callMethod('writeText', [text]);
  } catch (_) {}
}
