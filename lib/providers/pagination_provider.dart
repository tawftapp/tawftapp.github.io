import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr/jaspr.dart' show kIsWeb;
import '../models/widget_showcase_item.dart';
import '../services/supabase_service.dart';
import 'search_provider.dart';
import 'category_provider.dart';

class PaginationState {
  final List<WidgetShowcaseItem> widgets;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isInitialLoading;
  final String? error;

  const PaginationState({
    this.widgets = const [],
    this.hasMore = true,
    this.isLoadingMore = false,
    this.isInitialLoading = false,
    this.error,
  });

  PaginationState copyWith({
    List<WidgetShowcaseItem>? widgets,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isInitialLoading,
    String? error,
    bool clearError = false,
  }) {
    return PaginationState(
      widgets: widgets ?? this.widgets,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class PaginationNotifier extends Notifier<PaginationState> {
  static const int _limit = 10;
  bool _hasFetched = false;

  @override
  PaginationState build() {
    // Watch category so changing it resets this provider automatically.
    ref.watch(selectedCategoryProvider);
    
    // We can't safely perform side-effects directly inside build.
    // Run this only on the client side (kIsWeb) because server-side rendering
    // cannot handle asynchronous state updates after the build phase.
    if (kIsWeb) {
      Future.microtask(() => fetchInitial());
    }
    
    return const PaginationState();
  }

  Future<void> fetchInitial() async {
    if (_hasFetched || state.isInitialLoading) return;
    _hasFetched = true;

    state = state.copyWith(isInitialLoading: true, clearError: true);
    
    // Read the current category
    final category = ref.read(selectedCategoryProvider);
    
    try {
      final newWidgets = await SupabaseService.fetchInitialWidgets(
        limit: _limit,
        category: category,
      );

      state = state.copyWith(
        widgets: newWidgets,
        isInitialLoading: false,
        hasMore: newWidgets.length == _limit,
      );
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        error: e.toString(),
      );
      _hasFetched = false; // Allow retry
    }
  }

  Future<void> fetchMore() async {
    if (state.isLoadingMore || !state.hasMore || state.widgets.isEmpty) return;

    state = state.copyWith(isLoadingMore: true, clearError: true);
    final category = ref.read(selectedCategoryProvider);
    final lastItem = state.widgets.last;

    try {
      final nextBatch = await SupabaseService.fetchMoreWidgets(
        lastCreatedAt: lastItem.createdAt,
        lastId: lastItem.id,
        limit: _limit,
        category: category,
      );

      // Prevent duplicates by checking IDs
      final existingIds = state.widgets.map((e) => e.id).toSet();
      final uniqueNew = nextBatch.where((w) => !existingIds.contains(w.id)).toList();

      state = state.copyWith(
        widgets: [...state.widgets, ...uniqueNew],
        isLoadingMore: false,
        hasMore: nextBatch.length == _limit,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// Resets state and fetches from scratch when category changes
  void refreshForCategory() {
    _hasFetched = false;
    state = const PaginationState();
    fetchInitial();
  }
}

final paginationProvider = NotifierProvider<PaginationNotifier, PaginationState>(
  () => PaginationNotifier(),
);

/// Derived provider for client-side search filtering
final filteredWidgetsProvider = Provider<List<WidgetShowcaseItem>>((ref) {
  final paginationState = ref.watch(paginationProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  if (query.isEmpty) return paginationState.widgets;

  return paginationState.widgets.where((widget) {
    final titleMatch = widget.title.toLowerCase().contains(query);
    final descMatch = widget.description.toLowerCase().contains(query);
    final tagMatch = widget.tags.any((tag) => tag.toLowerCase().contains(query));
    return titleMatch || descMatch || tagMatch;
  }).toList();
});
