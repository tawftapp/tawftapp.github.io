import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import '../../components/code_preview.dart';

class SliverPersistentHeaderShowcase extends StatelessComponent {
  const SliverPersistentHeaderShowcase({super.key});

  static const _rawCode = r'''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SliverPersistentHeaderShowcase extends StatefulWidget {
  const SliverPersistentHeaderShowcase({super.key});

  @override
  State<SliverPersistentHeaderShowcase> createState() => _SliverPersistentHeaderShowcaseState();
}

class _SliverPersistentHeaderShowcaseState extends State<SliverPersistentHeaderShowcase>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final TabController _tabController;
  double _scrollProgress = 0.0;
  String _selectedCategory = 'All';
  String? _toastMessage;

  final List<(String, String, String, String)> _destinations = const [
    (
      'Mountain Lake',
      'Alpine lake with crystal clear water',
      'Mountains',
      'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=150&q=80',
    ),
    (
      'Forest Trail',
      'Scenic trail through tall pine trees',
      'Forests',
      'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=150&q=80',
    ),
    (
      'Emerald Peaks',
      'Majestic rugged snowy summits',
      'Mountains',
      'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=150&q=80',
    ),
    (
      'Redwood Sanctuary',
      'Walk among the giant redwood trees',
      'Forests',
      'https://images.unsplash.com/photo-1518837695005-2083093ee35b?auto=format&fit=crop&w=150&q=80',
    ),
    (
      'Crater Lake',
      'Volcanic crater with deep blue water',
      'Lakes',
      'https://images.unsplash.com/photo-1433832597046-4f10e10ac764?auto=format&fit=crop&w=150&q=80',
    ),
    (
      'Mirror Lake',
      'Perfect reflections of mountain ranges',
      'Lakes',
      'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=150&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      // Pin transitions at 130px scroll offset
      final offset = _scrollController.offset.clamp(0.0, 130.0);
      setState(() {
        _scrollProgress = offset / 130.0;
      });
    }
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      HapticFeedback.lightImpact();
      final categories = ['All', 'Mountains', 'Forests', 'Lakes'];
      setState(() {
        _selectedCategory = categories[_tabController.index];
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
    const green = Color(0xFF16A34A);
    const navy = Color(0xFF17213A);

    final filteredDestinations = _selectedCategory == 'All'
        ? _destinations
        : _destinations.where((d) => d.$3 == _selectedCategory).toList();

    final mediaQuery = MediaQuery.of(context);

    return MediaQuery(
      data: mediaQuery.copyWith(
        padding: mediaQuery.padding.copyWith(top: 44.0),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Top Padding to clear status bar notch
                const SliverToBoxAdapter(
                  child: SizedBox(height: 54),
                ),
                // Welcome and Search Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Discover',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: green,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Discover the World',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: navy,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Mock Search Bar
                        GestureDetector(
                          onTap: () => _showToast('Search tapped'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x03000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Search beautiful destinations...',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Collapsing Sticky Tab & Category Header
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyCategoryHeaderDelegate(
                    minExtentHeight: 56.0,
                    maxExtentHeight: 116.0,
                    scrollProgress: _scrollProgress,
                    tabController: _tabController,
                  ),
                ),
                // Destination Cards Grid
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final dest = filteredDestinations[index];
                        return _DestinationCard(
                          title: dest.$1,
                          subtitle: dest.$2,
                          imageUrl: dest.$4,
                          onTap: () => _showToast('Selected: ${dest.$1}'),
                        );
                      },
                      childCount: filteredDestinations.length,
                    ),
                  ),
                ),
                // Footer Brand text
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 40),
                    child: Center(
                      child: Text(
                        'Tawft - SliverPersistentHeader',
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
            // Custom Overlaid Status Bar
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

class _StickyCategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minExtentHeight;
  final double maxExtentHeight;
  final double scrollProgress;
  final TabController tabController;

  const _StickyCategoryHeaderDelegate({
    required this.minExtentHeight,
    required this.maxExtentHeight,
    required this.scrollProgress,
    required this.tabController,
  });

  @override
  double get minExtent => minExtentHeight;

  @override
  double get maxExtent => maxExtentHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    const green = Color(0xFF16A34A);

    // Calculate dynamic opacity for the Category Title
    // Fades out as the header reaches collapsed height (shrinkOffset goes up to 60.0)
    final double titleOpacity = (1.0 - (shrinkOffset / 60.0)).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          if (shrinkOffset > 10)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          // Green Collapsible Header Section
          Container(
            height: (60.0 - shrinkOffset).clamp(0.0, 60.0),
            color: green,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Opacity(
              opacity: titleOpacity,
              child: const Text(
                'Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
          // Sticky Tab Navigation Bar
          SizedBox(
            height: 56.0,
            child: TabBar(
              controller: tabController,
              indicatorColor: green,
              labelColor: green,
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3.0,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Mountains'),
                Tab(text: 'Forests'),
                Tab(text: 'Lakes'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyCategoryHeaderDelegate oldDelegate) {
    return oldDelegate.scrollProgress != scrollProgress ||
        oldDelegate.tabController != tabController ||
        oldDelegate.minExtentHeight != minExtentHeight ||
        oldDelegate.maxExtentHeight != maxExtentHeight;
  }
}

class _DestinationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;

  const _DestinationCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF17213A);
    const slate = Color(0xFF64748B);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x03000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          overlayColor: WidgetStateProperty.all(const Color(0xFF16A34A).withValues(alpha: 0.05)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Left Image Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: const Color(0xFFF1F5F9),
                          child: const Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
                              ),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF1F5F9),
                          child: const Icon(
                            Icons.landscape_rounded,
                            color: Color(0xFF94A3B8),
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Right Text Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: slate,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF94A3B8),
                  size: 20,
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
    // Starts navy Color(0xFF17213A) over white background
    // Transition to pure white when Categories Header pins at the top
    final color = Color.lerp(
      const Color(0xFF17213A),
      Colors.white,
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
        h1(classes: 'sliver-showcase__title', [Component.text('SliverPersistentHeader')]),
        p(classes: 'sliver-showcase__subtitle', [
          Component.text('Keep header visible while scrolling content'),
        ]),
      ]),
      div(classes: 'sliver-showcase__grid', [
        div(classes: 'sliver-gallery-card', [
          div(classes: 'sliver-gallery-card__header', [
            div(classes: 'sliver-gallery-card__heading', [
              h2(classes: 'sliver-gallery-card__title', [Component.text('2ï¸âƒ£ SliverPersistentHeader')]),
              p(classes: 'sliver-gallery-card__subtitle', [
                Component.text('Keep header visible while scrolling content'),
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
                img(
                  src: '/assets/sliver_persistent_header_preview.png',
                  classes: 'sliver-phone__preview-img',
                  alt: 'SliverPersistentHeader Preview',
                )
              ]),
            ]),
          ]),
          div(classes: 'sliver-feature-strip', [
            _featureChip('SliverPersistentHeader'),
            _featureChip('SliverPersistentHeaderDelegate'),
            _featureChip('Pinned header'),
            _featureChip('Dynamic height'),
            _featureChip('Category tabs'),
            _featureChip('Interactive filtering'),
          ]),
        ]),
        CodePreview(
          title: 'SliverPersistentHeader',
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