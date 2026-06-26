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

void enablePreviewVideoPlayback() {
  const selector = 'video';
  const boundAttribute = 'data-preview-playback-bound';

  void silenceVideo(html.VideoElement video) {
    video
      ..muted = true
      ..defaultMuted = true
      ..volume = 0
      ..controls = false;
    video.setAttribute('muted', '');
  }

  void playVideo(html.VideoElement video) {
    silenceVideo(video);
    video
      ..autoplay = true
      ..loop = true;
    video.setAttribute('playsinline', '');
    video.setAttribute('preload', 'auto');
    video.play().catchError((_) {});
  }

  void bindVideo(html.VideoElement video) {
    if (!video.hasAttribute(boundAttribute)) {
      video.setAttribute(boundAttribute, '');
      video.onCanPlay.listen((_) => playVideo(video));
      video.onLoadedMetadata.listen((_) => playVideo(video));
      video.onPlay.listen((_) => silenceVideo(video));
      video.onVolumeChange.listen((_) {
        if (!video.muted || video.volume != 0) {
          silenceVideo(video);
        }
      });
      video.onEnded.listen((_) {
        video.currentTime = 0;
        playVideo(video);
      });
    }
    playVideo(video);
  }

  void bindAllVideos() {
    for (final element in html.document.querySelectorAll(selector)) {
      if (element is html.VideoElement) {
        bindVideo(element);
      }
    }
  }

  bindAllVideos();

  html.MutationObserver((_, __) => bindAllVideos()).observe(
    html.document.documentElement!,
    childList: true,
    subtree: true,
  );

  html.document.onVisibilityChange.listen((_) {
    if (!html.document.hidden!) {
      bindAllVideos();
    }
  });
}
