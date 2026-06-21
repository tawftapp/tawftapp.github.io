import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr/jaspr.dart' show kIsWeb;
import '../models/widget_showcase_item.dart';
import '../services/supabase_service.dart';
import '../utils/search_utils.dart';
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
  int _requestVersion = 0;

  @override
  PaginationState build() {
    ref.watch(selectedCategoryProvider);
    ref.watch(searchQueryProvider);
    _requestVersion++;
    return PaginationState(isInitialLoading: kIsWeb);
  }

  Future<void> fetchInitial() {
    final requestVersion = ++_requestVersion;
    return _fetchInitial(
      requestVersion,
      ref.read(selectedCategoryProvider),
      ref.read(searchQueryProvider).trim(),
    );
  }

  Future<void> _fetchInitial(
    int requestVersion,
    String category,
    String searchQuery,
  ) async {
    state = state.copyWith(isInitialLoading: true, clearError: true);

    try {
      final newWidgets = await SupabaseService.fetchInitialWidgets(
        limit: _limit,
        category: category,
        searchQuery: searchQuery,
      );

      if (_requestVersion != requestVersion ||
          ref.read(selectedCategoryProvider) != category ||
          ref.read(searchQueryProvider).trim() != searchQuery) {
        return;
      }

      state = state.copyWith(
        widgets: newWidgets,
        isInitialLoading: false,
        hasMore: newWidgets.length == _limit,
      );
    } catch (e) {
      if (_requestVersion != requestVersion ||
          ref.read(selectedCategoryProvider) != category ||
          ref.read(searchQueryProvider).trim() != searchQuery) {
        return;
      }

      state = state.copyWith(
        isInitialLoading: false,
        error: 'Unable to load components. Please try again.',
      );
    }
  }

  Future<void> fetchMore() async {
    if (state.isLoadingMore || !state.hasMore || state.widgets.isEmpty) return;

    state = state.copyWith(isLoadingMore: true, clearError: true);
    final requestVersion = _requestVersion;
    final category = ref.read(selectedCategoryProvider);
    final searchQuery = ref.read(searchQueryProvider).trim();
    final lastItem = state.widgets.last;

    try {
      final nextBatch = await SupabaseService.fetchMoreWidgets(
        lastCreatedAt: lastItem.createdAt,
        lastId: lastItem.id,
        limit: _limit,
        category: category,
        searchQuery: searchQuery,
      );

      if (_requestVersion != requestVersion ||
          ref.read(selectedCategoryProvider) != category ||
          ref.read(searchQueryProvider).trim() != searchQuery) {
        return;
      }

      // Prevent duplicates by checking IDs
      final existingIds = state.widgets.map((e) => e.id).toSet();
      final uniqueNew = nextBatch
          .where((w) => !existingIds.contains(w.id))
          .toList();

      state = state.copyWith(
        widgets: [...state.widgets, ...uniqueNew],
        isLoadingMore: false,
        hasMore: nextBatch.length == _limit,
      );
    } catch (e) {
      if (_requestVersion != requestVersion) return;
      state = state.copyWith(
        isLoadingMore: false,
        error: 'Unable to load more components. Please try again.',
      );
    }
  }

  /// Resets state and fetches from scratch when category changes
  void refreshForCategory() {
    fetchInitial();
  }
}

final paginationProvider =
    NotifierProvider<PaginationNotifier, PaginationState>(
      () => PaginationNotifier(),
    );

/// Derived provider for client-side search filtering
final filteredWidgetsProvider = Provider<List<WidgetShowcaseItem>>((ref) {
  final paginationState = ref.watch(paginationProvider);
  final query = normalizeSearchText(ref.watch(searchQueryProvider));

  if (query.isEmpty) return paginationState.widgets;

  return paginationState.widgets.where((widget) {
    return widgetMatchesSearch(widget, query);
  }).toList();
});
