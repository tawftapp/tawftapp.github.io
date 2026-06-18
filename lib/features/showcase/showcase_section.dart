import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import '../../components/section_heading.dart';
import '../../components/category_chip.dart';
import '../../providers/category_provider.dart';
import '../../providers/pagination_provider.dart';
import 'showcase_item.dart';

class ShowcaseSection extends StatelessComponent {
  const ShowcaseSection({super.key});

  @override
  Component build(BuildContext context) {
    final categories = context.watch(categoriesProvider);
    final selectedCategory = context.watch(selectedCategoryProvider);
    
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
                span(classes: 'chip-label', [Component.text('Loading...')])
              ])
          else
            for (final category in categories)
              CategoryChip(
                label: category, 
                isSelected: category == selectedCategory,
                events: {
                  'click': (_) {
                    context.read(selectedCategoryProvider.notifier).setCategory(category);
                  }
                },
              ),
        ]),
      ]),
      
      if (paginationState.error != null && filteredWidgets.isEmpty)
        _buildErrorCard(context, paginationState.error!)
      else if (paginationState.isInitialLoading)
        _buildLoadingSkeletons()
      else if (filteredWidgets.isEmpty)
        _buildEmptyState(selectedCategory)
      else ...[
        for (var i = 0; i < filteredWidgets.length; i++)
          div(classes: 'animate-reveal reveal-delay-${4 + (i % 4)}', [
            ShowcaseItem(item: filteredWidgets[i], isReversed: i.isOdd),
          ]),
          
        if (paginationState.hasMore)
          div(classes: 'load-more-wrap', [
            button(
              classes: "premium-btn load-more-btn ${paginationState.isLoadingMore ? 'loading' : ''}",
              events: {
                'click': (_) {
                  context.read(paginationProvider.notifier).fetchMore();
                }
              },
              [
                if (paginationState.isLoadingMore)
                  span(classes: 'spinner material-symbols-outlined', [Component.text('sync')])
                else
                  Component.text('Load More Components'),
              ],
            )
          ]),
      ]
    ]);
  }

  Component _buildLoadingSkeletons() {
    return div(classes: 'skeleton-grid', [
      for (var i = 0; i < 2; i++)
        div(classes: 'shimmer-card', [
          div(classes: 'shimmer-img shimmer', []),
          div(classes: 'shimmer-content', [
            div(classes: 'shimmer-title shimmer', []),
            div(classes: 'shimmer-desc shimmer', []),
          ]),
        ]),
    ]);
  }

  Component _buildEmptyState(String category) {
    return div(classes: 'empty-state glass-panel', [
      div(classes: 'empty-state__icon-wrap', [
        span(classes: 'material-symbols-outlined empty-state__icon', [Component.text('search_off')]),
      ]),
      h3(classes: 'empty-state__title', [Component.text('No Components Found')]),
      p(classes: 'empty-state__desc', [
        Component.text(
          category == 'All Components' 
            ? "We couldn't find any components matching your search." 
            : "We couldn't find any components in the \"$category\" category matching your search."
        )
      ]),
    ]);
  }

  Component _buildErrorCard(BuildContext context, String error) {
    return div(classes: 'error-card-wrap', [
      div(classes: 'error-card', [
        div(classes: 'error-card__icon-wrap', [
          span(classes: 'material-symbols-outlined error-card__icon', [Component.text('warning')]),
        ]),
        h3(classes: 'error-card__title', [Component.text('Failed to Load Components')]),
        p(classes: 'error-card__message', [
          Component.text('Something went wrong: $error')
        ]),
        button(
          classes: 'error-card__btn',
          events: {
            'click': (_) {
              context.read(paginationProvider.notifier).fetchInitial();
            }
          },
          [
            span(classes: 'material-symbols-outlined error-card__btn-icon', [Component.text('refresh')]),
            Component.text('Try Again'),
          ],
        ),
      ]),
    ]);
  }
}
