import 'supabase_service.dart';

/// Centralized service for dynamic Storage URL generation
class StorageService {
  static const String _bucket = 'widgets';
  static final RegExp _safePath = RegExp(
    r'^[a-zA-Z0-9][a-zA-Z0-9._/-]*\.(png|jpe?g|webp|gif|mp4|webm)$',
    caseSensitive: false,
  );

  /// Generates the public URL for a preview file.
  static String? getPreviewUrl(String previewFile) {
    var cleanPath = previewFile.trim().replaceFirst(RegExp(r'^/+'), '');
    if (cleanPath == 'interactons/badge.mp4') {
      cleanPath = 'interactions/badge.mp4';
    }
    if (cleanPath.contains('..') || !_safePath.hasMatch(cleanPath)) {
      return null;
    }
    return supabase.storage.from(_bucket).getPublicUrl(cleanPath);
  }

  static bool isVideo(String previewFile) {
    final path = previewFile.trim().toLowerCase();
    return path.endsWith('.mp4') || path.endsWith('.webm');
  }

  /// Future helper for thumbnail generation
  static String? getThumbnailUrl(String thumbnailFile) {
    return getPreviewUrl(thumbnailFile);
  }
}
