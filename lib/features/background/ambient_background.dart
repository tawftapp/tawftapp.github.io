import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class AmbientBackground extends StatelessComponent {
  const AmbientBackground({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'ambient-bg-container', [
      div(classes: 'ambient-mesh ambient-mesh--primary animate-pulse-glow', []),
      div(classes: 'ambient-mesh ambient-mesh--secondary animate-pulse-glow', styles: Styles(raw: {'animation-delay': '2s'}), []),
      _particle('rgba(137,206,255,0.3)', '25%', null, null, '25%', '0s'),
      _particle('rgba(220,184,255,0.3)', '75%', null, '25%', null, '1s'),
      _particle('rgba(255,184,106,0.3)', null, '25%', null, '33%', '2s'),
      _particle('rgba(137,206,255,0.2)', '50%', null, '33%', null, '3s'),
      _particle('rgba(255,255,255,0.3)', '66%', null, null, '20%', '4s'),
      _particle('rgba(137,206,255,0.2)', null, '20%', '20%', null, '5s'),
    ]);
  }

  Component _particle(String color, String? top, String? bottom, String? right, String? left, String delay) {
    final raw = <String, String>{'background': color, 'animation-delay': delay};
    if (top != null) raw['top'] = top;
    if (bottom != null) raw['bottom'] = bottom;
    if (right != null) raw['right'] = right;
    if (left != null) raw['left'] = left;
    return div(classes: 'ambient-particle animate-drift', styles: Styles(raw: raw), []);
  }
}
