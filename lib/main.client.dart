import 'package:jaspr/client.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'main.dart';
import 'main.client.options.dart';
import 'utils/js_utils.dart';

void main() async {
  Jaspr.initializeApp(options: defaultClientOptions);

  runApp(
    ProviderScope(
      child: const App(),
    ),
  );

  enablePreviewVideoPlayback();
}
