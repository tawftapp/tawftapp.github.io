import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../../components/code_preview.dart';

class ContextMenuShowcase extends StatelessComponent {
  const ContextMenuShowcase({super.key});

  static const _rawCode = r'''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContextMenuShowcase extends StatefulWidget {
  const ContextMenuShowcase({super.key});

  @override
  State<ContextMenuShowcase> createState() => _ContextMenuShowcaseState();
}

class _ContextMenuShowcaseState extends State<ContextMenuShowcase> {
  static const navy = Color(0xFF17213A);
  static const purple = Color(0xFF7357FF);
  bool _isOpen = true;
  String? _toastMessage;

  void _closeMenu() {
    if (_isOpen) {
      setState(() => _isOpen = false);
    }
  }

  void _openMenu() {
    if (!_isOpen) {
      setState(() => _isOpen = true);
    }
  }

  void _handleItemTap(String label) {
    HapticFeedback.mediumImpact();
    setState(() {
      _isOpen = false;
      _toastMessage = 'Action selected: $label';
    });
  }

  @override
  Widget build(BuildContext context) {
    const danger = Color(0xFFFF5A6E);
    final items = [
      (Icons.edit_outlined, 'Edit', navy),
      (Icons.copy_rounded, 'Duplicate', navy),
      (Icons.share_outlined, 'Share', navy),
      (Icons.delete_outline_rounded, 'Delete', danger),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: _closeMenu,
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              const _StatusBar(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                  padding: const EdgeInsets.all(18),
                  decoration: _box(
                    Colors.white,
                    16,
                    Colors.black.withValues(alpha: .06),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: _Header(),
                      ),
                      // Trigger Button
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _isOpen = !_isOpen);
                        },
                        onLongPress: () {
                          HapticFeedback.mediumImpact();
                          _openMenu();
                        },
                        child: Container(
                          width: 58,
                          height: 58,
                          alignment: Alignment.center,
                          decoration: _box(
                            const Color(0xFFF1EDFF),
                            17,
                            purple.withValues(alpha: .15),
                            border: const Color(0xFFE0D7FF),
                          ),
                          child: const Icon(
                            Icons.more_horiz_rounded,
                            color: purple,
                            size: 30,
                          ),
                        ),
                      ),
                      // Floating Context Menu Card
                      Positioned(
                        child: Transform.translate(
                          offset: const Offset(0, -148),
                          child: AnimatedScale(
                            scale: _isOpen ? 1.0 : 0.92,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutBack,
                            child: AnimatedOpacity(
                              opacity: _isOpen ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 150),
                              child: IgnorePointer(
                                ignoring: !_isOpen,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      width: 210,
                                      padding: const EdgeInsets.all(8),
                                      decoration: _box(
                                        Colors.white,
                                        18,
                                        navy.withValues(alpha: .12),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          for (final item in items)
                                            _ContextMenuItem(
                                              icon: item.$1,
                                              label: item.$2,
                                              color: item.$3,
                                              onTap: () => _handleItemTap(item.$2),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // Pointer Arrow
                                    Positioned(
                                      bottom: -6,
                                      child: Transform.rotate(
                                        angle: 0.785, // 45 degrees
                                        child: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: const Color(0xFFE8ECF4),
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Arrow Cover
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        width: 20,
                                        height: 8,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Animated Toast Feedback
                      if (_toastMessage != null)
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: _AnimatedToast(
                            key: ValueKey(_toastMessage),
                            message: _toastMessage!,
                            onDismissed: () {
                              setState(() => _toastMessage = null);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Tawft - Context Menu',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static BoxDecoration _box(
    Color color,
    double radius,
    Color shadow, {
    Color border = const Color(0xFFE8ECF4),
  }) =>
      BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border, width: 1.2),
        boxShadow: [
          BoxShadow(
            blurRadius: 32,
            offset: const Offset(0, 16),
            color: shadow,
          ),
        ],
      );
}

class _ContextMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ContextMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ContextMenuItem> createState() => _ContextMenuItemState();
}

class _ContextMenuItemState extends State<_ContextMenuItem> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: _isPressed
                ? const Color(0xFFF1EDFF)
                : (_isHovered
                    ? const Color(0xFFF1EDFF).withValues(alpha: 0.4)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 20, color: widget.color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedToast extends StatefulWidget {
  final String message;
  final VoidCallback onDismissed;

  const _AnimatedToast({
    super.key,
    required this.message,
    required this.onDismissed,
  });

  @override
  State<_AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<_AnimatedToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) widget.onDismissed();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF17213A),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Context Menu',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Actions on long press / click',
            style: TextStyle(
              color: Color(0xFF667085),
              fontSize: 13,
            ),
          ),
        ],
      );
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.fromLTRB(22, 10, 22, 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '9:41',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              children: [
                Icon(Icons.signal_cellular_4_bar_rounded, size: 14),
                SizedBox(width: 4),
                Icon(Icons.wifi_rounded, size: 14),
                SizedBox(width: 4),
                Icon(Icons.battery_5_bar_rounded, size: 16),
              ],
            ),
          ],
        ),
      );
}
''';

  @override
  Component build(BuildContext context) {
    return section(classes: 'context-showcase container-max animate-reveal reveal-delay-2', [
      div(classes: 'context-showcase__intro', [
        span(classes: 'context-showcase__eyebrow', [Component.text('Widget Preview')]),
        h1(classes: 'context-showcase__title', [Component.text('Context Menu')]),
        p(classes: 'context-showcase__subtitle', [
          Component.text('Actions on long press / click'),
        ]),
      ]),
      div(classes: 'context-showcase__grid', [
        div(classes: 'context-gallery-card', [
          div(classes: 'context-gallery-card__header', [
            div(classes: 'context-gallery-card__heading', [
              h2(classes: 'context-gallery-card__title', [Component.text('🔟 Context Menu')]),
              p(classes: 'context-gallery-card__subtitle', [
                Component.text('Actions on long press / click'),
              ]),
            ]),
            span(classes: 'context-gallery-card__badge', [Component.text('Open')]),
          ]),
          div(classes: 'context-preview-stage', [
            div(classes: 'context-phone', [
              div(classes: 'context-phone__topbar', [
                div(classes: 'context-phone__pill', []),
                div(classes: 'context-phone__avatar', []),
              ]),
              div(classes: 'context-phone__surface', [
                div(classes: 'context-menu-wrap', [
                  _menuCard(),
                  button(
                    classes: 'context-trigger',
                    attributes: {
                      'aria-label': 'Open context menu',
                      'title': 'Open context menu',
                    },
                    [
                      span(classes: 'material-symbols-outlined context-trigger__icon', [
                        Component.text('more_horiz'),
                      ]),
                    ],
                  ),
                ]),
              ]),
            ]),
          ]),
          div(classes: 'context-feature-strip', [
            _featureChip('Long press'),
            _featureChip('Tap support'),
            _featureChip('Smart edges'),
            _featureChip('Nested actions'),
            _featureChip('Custom items'),
          ]),
        ]),
        CodePreview(
          title: 'Context Menu',
          rawCode: _rawCode,
          classes: 'context-showcase__code',
        ),
      ]),
    ]);
  }

  Component _menuCard() {
    return div(classes: 'context-menu-card', [
      _menuItem('edit', 'Edit'),
      _menuItem('content_copy', 'Duplicate'),
      _menuItem('share', 'Share'),
      _menuItem('delete', 'Delete', isDanger: true),
      div(classes: 'context-menu-card__arrow', []),
    ]);
  }

  Component _menuItem(String icon, String label, {bool isDanger = false}) {
    return div(classes: 'context-menu-item ${isDanger ? 'context-menu-item--danger' : ''}', [
      span(classes: 'material-symbols-outlined context-menu-item__icon', [
        Component.text(icon),
      ]),
      span(classes: 'context-menu-item__label', [Component.text(label)]),
    ]);
  }

  Component _featureChip(String label) {
    return span(classes: 'context-feature-chip', [Component.text(label)]);
  }
}
