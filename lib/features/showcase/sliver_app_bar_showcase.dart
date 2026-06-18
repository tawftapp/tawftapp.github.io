import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../../components/code_preview.dart';

class SliverAppBarShowcase extends StatelessComponent {
  const SliverAppBarShowcase({super.key});

  static const _rawCode = r'''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SliverAppBarShowcase extends StatefulWidget {
  const SliverAppBarShowcase({super.key});

  @override
  State<SliverAppBarShowcase> createState() => _SliverAppBarShowcaseState();
}

class _SliverAppBarShowcaseState extends State<SliverAppBarShowcase> {
  late final ScrollController _scrollController;
  double _scrollProgress = 0.0;
  String? _toastMessage;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      const maxScroll = 240.0 - kToolbarHeight; // 184.0
      final offset = _scrollController.offset.clamp(0.0, maxScroll);
      setState(() {
        _scrollProgress = offset / maxScroll;
      });
    }
  }

  void _showToast(String message) {
    HapticFeedback.mediumImpact();
    setState(() {
      _toastMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF17213A);

    // Dynamic colors based on scroll progress
    final appBarBgColor = Color.lerp(
      Colors.transparent,
      Colors.white,
      _scrollProgress,
    )!;
    final appBarIconColor = Color.lerp(
      Colors.white,
      navy,
      _scrollProgress,
    )!;

    final destinations = [
      (
        'Lake Braies, Italy',
        'An alpine lake in the Dolomites, famous for its turquoise water and rustic wooden boats.',
        '★ 4.9 (124 reviews)',
        ['Romantic', 'Boating'],
        '\$15/hr',
      ),
      (
        'Alpine Ridge, Switzerland',
        'Scale the panoramic ridges of the Swiss Alps, witnessing majestic glaciers and towering peaks.',
        '★ 4.8 (89 reviews)',
        ['Hiking', 'Adventure'],
        'Free',
      ),
      (
        'Redwood Forest, Canada',
        'Lose yourself in the towering redwood forests of British Columbia, featuring serene woodland trails.',
        '★ 4.7 (62 reviews)',
        ['Nature', 'Cycling'],
        'Free',
      ),
      (
        'Emerald Valley, Austria',
        'Wander through a lush green valley punctuated by gushing waterfalls and historic stone bridges.',
        '★ 4.9 (95 reviews)',
        ['Waterfalls', 'Scenic'],
        '\$5 Entry',
      ),
    ];

    final mediaQuery = MediaQuery.of(context);

    return MediaQuery(
      data: mediaQuery.copyWith(
        padding: mediaQuery.padding.copyWith(top: 44.0), // Simulate status bar padding
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Immersion collapsible header
                SliverAppBar(
                  expandedHeight: 240.0,
                  pinned: true,
                  stretch: true,
                  backgroundColor: appBarBgColor,
                  elevation: _scrollProgress > 0.9 ? 3.0 : 0.0,
                  shadowColor: Colors.black.withValues(alpha: 0.1),
                  leading: IconButton(
                    icon: const Icon(Icons.menu_rounded),
                    color: appBarIconColor,
                    onPressed: () => _showToast('Menu Tapped'),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search_rounded),
                      color: appBarIconColor,
                      onPressed: () => _showToast('Search Tapped'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded),
                      color: appBarIconColor,
                      onPressed: () => _showToast('Notifications Tapped'),
                    ),
                  ],
                  // Sticky Title when collapsed
                  title: AnimatedOpacity(
                    opacity: _scrollProgress > 0.7 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 150),
                    child: const Text(
                      'Explore Nature',
                      style: TextStyle(
                        color: navy,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                    ],
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Immersive Sunset Landscape from Unsplash
                        Image.network(
                          'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=800&q=80',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: const Color(0xFF17213A),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xFF3B1E7E), Color(0xFF8B4FA9)],
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.wifi_off_rounded,
                                  color: Colors.white30,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),
                        // Gradient cover overlay for readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.25),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.55),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                        // Scroll indicator arrow (only visible when expanded)
                        Positioned(
                          right: 18,
                          bottom: 84,
                          child: Opacity(
                            opacity: (1.0 - _scrollProgress * 2.0).clamp(0.0, 1.0),
                            child: const _PulseScrollIndicator(),
                          ),
                        ),
                        // Hero Content: Bottom-aligned expanded title & subtitle
                        Positioned(
                          left: 20,
                          bottom: 18,
                          right: 20,
                          child: Opacity(
                            opacity: (1.0 - _scrollProgress * 1.5).clamp(0.0, 1.0),
                            child: Transform.translate(
                              offset: Offset(0, 12 * _scrollProgress),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Explore Nature',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Discover beautiful places',
                                    style: TextStyle(
                                      color: Color(0xFFE2E8F0),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Destination Feed content list
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final dest = destinations[index];
                        return _DestinationCard(
                          title: dest.$1,
                          description: dest.$2,
                          rating: dest.$3,
                          tags: dest.$4,
                          price: dest.$5,
                          onTap: () => _showToast('Selected: ${dest.$1}'),
                          onBook: () => _showToast('Booking: ${dest.$1}'),
                        );
                      },
                      childCount: destinations.length,
                    ),
                  ),
                ),
                // Centered App Branding Footer Label
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 40),
                    child: Center(
                      child: Text(
                        'Tawft - SliverAppBar',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF94A3B8),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Custom iOS-Style Status Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _StatusBar(scrollProgress: _scrollProgress),
            ),
            // Success Toast
            if (_toastMessage != null)
              Positioned(
                bottom: 34,
                left: 20,
                right: 20,
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
    );
  }
}



class _PulseScrollIndicator extends StatefulWidget {
  const _PulseScrollIndicator();

  @override
  State<_PulseScrollIndicator> createState() => _PulseScrollIndicatorState();
}

class _PulseScrollIndicatorState extends State<_PulseScrollIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.45),
                width: 1.0,
              ),
            ),
            child: const Icon(
              Icons.arrow_downward_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        );
      },
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final String title;
  final String description;
  final String rating;
  final List<String> tags;
  final String price;
  final VoidCallback onTap;
  final VoidCallback onBook;

  const _DestinationCard({
    required this.title,
    required this.description,
    required this.rating,
    required this.tags,
    required this.price,
    required this.onTap,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6C63FF);
    const navy = Color(0xFF17213A);
    const slate = Color(0xFF64748B);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          overlayColor: WidgetStateProperty.all(purple.withValues(alpha: 0.05)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      rating,
                      style: const TextStyle(
                        color: Color(0xFFF59E0B),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: slate,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          for (final tag in tags)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: slate,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Starts from',
                          style: TextStyle(
                            color: slate,
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          price,
                          style: const TextStyle(
                            color: purple,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFF1F5F9), height: 1.0),
                const SizedBox(height: 12),
                _BookButton(onPressed: onBook),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BookButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _BookButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6C63FF);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [purple, Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onPressed,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Book Destination',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final double scrollProgress;
  const _StatusBar({required this.scrollProgress});

  @override
  Widget build(BuildContext context) {
    final color = Color.lerp(
      Colors.white,
      const Color(0xFF17213A),
      scrollProgress,
    )!;

    return Container(
      height: 44,
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_4_bar_rounded, size: 14, color: color),
              const SizedBox(width: 4),
              Icon(Icons.wifi_rounded, size: 14, color: color),
              const SizedBox(width: 4),
              Icon(Icons.battery_5_bar_rounded, size: 16, color: color),
            ],
          ),
        ],
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
''';

  @override
  Component build(BuildContext context) {
    return section(classes: 'sliver-showcase container-max animate-reveal reveal-delay-2', [
      div(classes: 'sliver-showcase__intro', [
        span(classes: 'sliver-showcase__eyebrow', [Component.text('Widget Preview')]),
        h1(classes: 'sliver-showcase__title', [Component.text('SliverAppBar')]),
        p(classes: 'sliver-showcase__subtitle', [
          Component.text('Collapsible app bar that shrinks on scroll'),
        ]),
      ]),
      div(classes: 'sliver-showcase__grid', [
        div(classes: 'sliver-gallery-card', [
          div(classes: 'sliver-gallery-card__header', [
            div(classes: 'sliver-gallery-card__heading', [
              h2(classes: 'sliver-gallery-card__title', [Component.text('1️⃣ SliverAppBar')]),
              p(classes: 'sliver-gallery-card__subtitle', [
                Component.text('Collapsible app bar that shrinks on scroll'),
              ]),
            ]),
            span(classes: 'sliver-gallery-card__badge', [Component.text('Interactive')]),
          ]),
          div(classes: 'sliver-preview-stage', [
            div(classes: 'sliver-phone', [
              div(classes: 'sliver-phone__topbar', [
                div(classes: 'sliver-phone__pill', []),
                div(classes: 'sliver-phone__avatar', []),
              ]),
              div(classes: 'sliver-phone__surface', [
                // Renders the generated preview image in the mock phone frame
                img(
                  src: '/assets/sliver_app_bar_preview.png',
                  classes: 'sliver-phone__preview-img',
                  alt: 'SliverAppBar Preview',
                )
              ]),
            ]),
          ]),
          div(classes: 'sliver-feature-strip', [
            _featureChip('SliverAppBar.large'),
            _featureChip('Pinned header'),
            _featureChip('Floating support'),
            _featureChip('Snap support'),
            _featureChip('FlexibleSpaceBar'),
            _featureChip('Stretch effects'),
          ]),
        ]),
        CodePreview(
          title: 'SliverAppBar',
          rawCode: _rawCode,
          classes: 'sliver-showcase__code',
        ),
      ]),
    ]);
  }

  Component _featureChip(String label) {
    return span(classes: 'sliver-feature-chip', [Component.text(label)]);
  }
}
