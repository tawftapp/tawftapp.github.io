import 'package:test/test.dart';
import 'package:tawft/services/storage_service.dart';

void main() {
  test('accepts known preview media extensions', () {
    expect(StorageService.getPreviewUrl('cards/example.png'), isNotNull);
    expect(StorageService.getPreviewUrl('/forms/input.mp4'), isNotNull);
    expect(
      StorageService.getPreviewUrl('interactons/badge.mp4'),
      contains('/interactions/badge.mp4'),
    );
    expect(StorageService.isVideo('forms/input.webm'), isTrue);
  });

  test('rejects traversal, external URLs, and executable files', () {
    expect(StorageService.getPreviewUrl('../secret.png'), isNull);
    expect(StorageService.getPreviewUrl('https://evil.example/x.mp4'), isNull);
    expect(StorageService.getPreviewUrl('widgets/payload.svg'), isNull);
    expect(StorageService.getPreviewUrl('widgets/payload.html'), isNull);
  });
}
