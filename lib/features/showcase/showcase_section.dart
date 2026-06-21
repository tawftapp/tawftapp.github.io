import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../../components/section_heading.dart';
import '../../components/category_chip.dart';
import '../../providers/category_provider.dart';
import '../../providers/pagination_provider.dart';
import '../../providers/search_provider.dart';
import 'showcase_item.dart';

class ShowcaseSection extends StatefulComponent {
  const ShowcaseSection({super.key});

  @override
  State<ShowcaseSection> createState() => _ShowcaseSectionState();
}

class _ShowcaseSectionState extends State<ShowcaseSection> {
  bool _startedLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (kIsWeb && !_startedLoading) {
      _startedLoading = true;
      Future.microtask(() {
        if (!mounted) return;
        context.read(categoriesProvider.notifier).load();
        context.read(paginationProvider.notifier).fetchInitial();
      });
    }
  }

  @override
  Component build(BuildContext context) {
    final categories = context.watch(categoriesProvider);
    final selectedCategory = context.watch(selectedCategoryProvider);
    final searchQuery = context.watch(searchQueryProvider).trim();

    // Watch the pagination state directly
    final paginationState = context.watch(paginationProvider);
    // Watch the derived list of widgets (includes search filter)
    final filteredWidgets = context.watch(filteredWidgetsProvider);

    return section(classes: 'showcase-section container-max', [
      div(classes: 'animate-reveal reveal-delay-3', [
        const SectionHeading(title: 'Curated Components'),
        div(classes: 'showcase-chips', [
          if (categories.length == 1) // Only 'All Components' is loaded
            for (var i = 0; i < 4; i++)
              div(classes: 'chip shimmer', [
                span(classes: 'chip-label', [Component.text('Loading...')]),
              ])
          else
            for (final category in categories)
              CategoryChip(
                label: category,
                isSelected: category == selectedCategory,
                events: {
                  'click': (_) {
                    context
                        .read(selectedCategoryProvider.notifier)
                        .setCategory(category);
                  },
                },
              ),
        ]),
      ]),

      if (paginationState.error != null && filteredWidgets.isEmpty)
        _buildErrorCard(context, paginationState.error!)
      else if (paginationState.isInitialLoading)
        _buildCategoryLoader(selectedCategory, searchQuery)
      else if (filteredWidgets.isEmpty)
        _buildEmptyState(selectedCategory, searchQuery)
      else ...[
        for (var i = 0; i < filteredWidgets.length; i++)
          div(classes: 'animate-reveal reveal-delay-${4 + (i % 4)}', [
            ShowcaseItem(item: filteredWidgets[i], isReversed: i.isOdd),
          ]),

        if (paginationState.hasMore)
          div(classes: 'load-more-wrap', [
            button(
              classes:
                  "load-more-btn ${paginationState.isLoadingMore ? 'loading' : ''}",
              attributes: {
                'type': 'button',
                'aria-label': paginationState.isLoadingMore
                    ? 'Loading more components'
                    : 'Load more components',
                if (paginationState.isLoadingMore) 'disabled': '',
              },
              events: {
                'click': (_) {
                  context.read(paginationProvider.notifier).fetchMore();
                },
              },
              [
                if (paginationState.isLoadingMore)
                  span(classes: 'load-more-btn__spinner', [])
                else ...[
                  span(classes: 'load-more-btn__label', [
                    Component.text('Load More Components'),
                  ]),
                  span(
                    classes: 'material-symbols-outlined load-more-btn__icon',
                    [Component.text('south')],
                  ),
                ],
              ],
            ),
          ]),
      ],
    ]);
  }

  Component _buildCategoryLoader(String category, String searchQuery) {
    final categoryLabel = searchQuery.isNotEmpty
        ? 'results for "$searchQuery"'
        : category == 'All Components'
        ? 'components'
        : category;

    return div(
      classes: 'category-loader',
      attributes: {
        'role': 'status',
        'aria-live': 'polite',
        'aria-label': 'Loading $categoryLabel',
      },
      [
        div(classes: 'category-loader__visual', [
          span(classes: 'category-loader__ring', []),
          span(classes: 'material-symbols-outlined category-loader__icon', [
            Component.text('widgets'),
          ]),
        ]),
        p(classes: 'category-loader__title', [
          Component.text('Loading $categoryLabel'),
        ]),
        p(classes: 'category-loader__hint', [
          Component.text('Curating the best widgets for you'),
        ]),
      ],
    );
  }

  Component _buildEmptyState(String category, String searchQuery) {
    return div(classes: 'empty-state glass-panel', [
      div(classes: 'empty-state__icon-wrap', [
        span(classes: 'material-symbols-outlined empty-state__icon', [
          Component.text('search_off'),
        ]),
      ]),
      h3(classes: 'empty-state__title', [
        Component.text('No Components Found'),
      ]),
      p(classes: 'empty-state__desc', [
        Component.text(
          searchQuery.isNotEmpty
              ? 'No components match "$searchQuery". Try another keyword.'
              : category == 'All Components'
              ? "We couldn't find any components matching your search."
              : "We couldn't find any components in the \"$category\" category matching your search.",
        ),
      ]),
    ]);
  }

  Component _buildErrorCard(BuildContext context, String error) {
    return div(classes: 'error-card-wrap', [
      div(classes: 'error-card', [
        div(classes: 'error-card__icon-wrap', [
          span(classes: 'material-symbols-outlined error-card__icon', [
            Component.text('warning'),
          ]),
        ]),
        h3(classes: 'error-card__title', [
          Component.text('Failed to Load Components'),
        ]),
        p(classes: 'error-card__message', [Component.text(error)]),
        button(
          classes: 'error-card__btn',
          events: {
            'click': (_) {
              context.read(paginationProvider.notifier).fetchInitial();
            },
          },
          [
            span(classes: 'material-symbols-outlined error-card__btn-icon', [
              Component.text('refresh'),
            ]),
            Component.text('Try Again'),
          ],
        ),
      ]),
    ]);
  }
}
