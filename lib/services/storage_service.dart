import 'supabase_service.dart';

/// Centralized service for dynamic Storage URL generation
class StorageService {
  static const String _bucket = 'widgets';

  /// Generates the public URL for a preview file.
  static String getPreviewUrl(String previewFile) {
    // Strip leading slash if it exists to prevent double slashes in the final URL
    final cleanPath = previewFile.startsWith('/') ? previewFile.substring(1) : previewFile;
    return supabase.storage.from(_bucket).getPublicUrl(cleanPath);
  }

  /// Future helper for thumbnail generation
  static String getThumbnailUrl(String thumbnailFile) {
    return supabase.storage.from(_bucket).getPublicUrl(thumbnailFile);
  }
}
