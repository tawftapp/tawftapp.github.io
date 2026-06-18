import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class FloatingWidget extends StatelessComponent {
  final FloatingVariant variant;
  final String animationClass;
  final String positionClass;

  const FloatingWidget({required this.variant, this.animationClass = 'animate-float', this.positionClass = '', super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'floating-widget $animationClass $positionClass', [_buildVariant()]);
  }

  Component _buildVariant() {
    switch (variant) {
      case FloatingVariant.infoCard: return _buildInfoCard();
      case FloatingVariant.codeSnippet: return _buildCodeSnippet();
      case FloatingVariant.toggle: return _buildToggle();
      case FloatingVariant.slider: return _buildSlider();
    }
  }

  Component _buildInfoCard() {
    return div(classes: 'fw-info', [
      div(classes: 'fw-info__header', [
        div(classes: 'fw-info__icon-wrap', [
          span(classes: 'material-symbols-outlined fw-info__icon', [Component.text('widgets')]),
        ]),
        div([
          div(classes: 'fw-info__title', [Component.text('Interactive Card')]),
          div(classes: 'fw-info__sub', [Component.text('Glassmorphism')]),
        ]),
      ]),
      div(classes: 'fw-info__bar', [div(classes: 'fw-info__bar-fill', [])]),
    ]);
  }

  Component _buildCodeSnippet() {
    return div(classes: 'fw-code', [
      div(classes: 'fw-code__header', [
        span(classes: 'fw-code__filename', [Component.text('GlassCard.dart')]),
        div(classes: 'fw-code__dots', [span(classes: 'fw-code__dot', []), span(classes: 'fw-code__dot', [])]),
      ]),
      div(classes: 'fw-code__body', [
        div([span(classes: 'syn-type', [Component.text('Container')]), span(classes: 'syn-base', [Component.text('(')])]),
        div(classes: 'fw-code__indent', [span(classes: 'syn-base', [Component.text('decoration: ')]), span(classes: 'syn-val', [Component.text('BoxDecoration')]), span(classes: 'syn-base', [Component.text('(')])]),
        div(classes: 'fw-code__indent-2', [span(classes: 'syn-base', [Component.text('color: ')]), span(classes: 'syn-str', [Component.text('Colors.white10')]), span(classes: 'syn-base', [Component.text(',')])]),
        div(classes: 'fw-code__indent', [span(classes: 'syn-base', [Component.text('),')])]),
        div([span(classes: 'syn-type', [Component.text(')')])]),
      ]),
    ]);
  }

  Component _buildToggle() {
    return div(classes: 'fw-toggle', [
      span(classes: 'fw-toggle__label', [Component.text('Dark Mode')]),
      div(classes: 'fw-toggle__track', [div(classes: 'fw-toggle__thumb', [])]),
    ]);
  }

  Component _buildSlider() {
    return div(classes: 'fw-slider', [
      div(classes: 'fw-slider__header', [
        span(classes: 'fw-slider__label', [Component.text('Opacity')]),
        span(classes: 'fw-slider__value', [Component.text('85%')]),
      ]),
      div(classes: 'fw-slider__track', [div(classes: 'fw-slider__fill', []), div(classes: 'fw-slider__thumb', [])]),
    ]);
  }
}

enum FloatingVariant { infoCard, codeSnippet, toggle, slider }
