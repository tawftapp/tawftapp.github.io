import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../../components/floating_widget.dart';
import 'phone_mockup.dart';

class Hero3dArea extends StatelessComponent {
  const Hero3dArea({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'hero-3d perspective-area', [
      div(classes: 'hero-3d__glow animate-pulse-glow', []),
      const PhoneMockup(),
      const FloatingWidget(variant: FloatingVariant.infoCard, animationClass: 'animate-float-delayed', positionClass: 'fw-pos-info'),
      const FloatingWidget(variant: FloatingVariant.codeSnippet, animationClass: 'animate-float-fast', positionClass: 'fw-pos-code'),
      const FloatingWidget(variant: FloatingVariant.toggle, animationClass: 'animate-float', positionClass: 'fw-pos-toggle'),
      const FloatingWidget(variant: FloatingVariant.slider, animationClass: 'animate-float-delayed', positionClass: 'fw-pos-slider'),
      div(classes: 'hero-3d__ring hero-3d__ring--1 animate-spin-slow', []),
      div(classes: 'hero-3d__ring hero-3d__ring--2 animate-spin-slow-reverse', []),
    ]);
  }
}
