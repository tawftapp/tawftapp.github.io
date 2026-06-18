// ignore_for_file: deprecated_member_use
import 'dart:js' as js;
import 'dart:html' as html;

void highlightCode(String elementId) {
  try {
    html.window.requestAnimationFrame((_) {
      try {
        js.context.callMethod('eval', [
          '''
          if (typeof Prism !== "undefined") { 
            var el = document.getElementById("$elementId");
            if (el) {
              Prism.highlightElement(el);
            }
          }
          '''
        ]);
      } catch (_) {}
    });
  } catch (_) {
    // Fallback if requestAnimationFrame fails
    try {
      js.context.callMethod('eval', [
        '''
        if (typeof Prism !== "undefined") { 
          var el = document.getElementById("$elementId");
          if (el) {
            Prism.highlightElement(el);
          }
        }
        '''
      ]);
    } catch (_) {}
  }
}

void copyToClipboard(String text) {
  try {
    js.context['__copy_temp_text'] = text;
    js.context.callMethod('eval', [
      'if (navigator.clipboard) { navigator.clipboard.writeText(window.__copy_temp_text); }'
    ]);
  } catch (_) {}
}

