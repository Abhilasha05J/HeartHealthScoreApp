import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_food_search_repository.dart';
import '../domain/food_item.dart';
import '../domain/food_search_repository.dart';

final foodSearchRepositoryProvider = Provider<FoodSearchRepository>((ref) {
  return MockFoodSearchRepository();
});

class FoodSearchState {
  const FoodSearchState({this.query = '', this.results = const [], this.isSearching = false});

  final String query;
  final List<FoodItem> results;
  final bool isSearching;

  FoodSearchState copyWith({String? query, List<FoodItem>? results, bool? isSearching}) {
    return FoodSearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

/// Debounces search-as-you-type so every keystroke doesn't hit the
/// repository — waits 300ms after the last change before actually
/// searching. Matters more once this is backed by a real
/// database/API call instead of the in-memory mock list.
class FoodSearchController extends StateNotifier<FoodSearchState> {
  FoodSearchController(this._repository) : super(const FoodSearchState());

  final FoodSearchRepository _repository;
  Timer? _debounce;

  void updateQuery(String query) {
    state = state.copyWith(query: query);
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      state = state.copyWith(results: [], isSearching: false);
      return;
    }

    state = state.copyWith(isSearching: true);
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final results = await _repository.search(query);
      if (mounted) state = state.copyWith(results: results, isSearching: false);
    });
  }

  void clear() {
    _debounce?.cancel();
    state = const FoodSearchState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final foodSearchControllerProvider = StateNotifierProvider<FoodSearchController, FoodSearchState>((ref) {
  return FoodSearchController(ref.watch(foodSearchRepositoryProvider));
});
