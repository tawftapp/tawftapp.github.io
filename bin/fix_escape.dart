import 'dart:io';

void main() {
  final file = File('lib/features/showcase/showcase_item.dart');
  var content = file.readAsStringSync();
  content = content.replaceAll(r'\$videoId', r'$videoId');
  content = content.replaceAll(r'\$url', r'$url');
  file.writeAsStringSync(content);
}
