import 'food_item.dart';

/// Contract for searching the food dataset. Swap [MockFoodSearchRepository]
/// for a real implementation once the actual dataset is available —
/// depending on its size/format that might be:
///   - A bundled JSON/CSV asset, loaded + filtered in-memory (fine for
///     up to a few thousand rows).
///   - A local SQLite database (via `sqflite`) for a larger dataset,
///     queried with a `LIKE` search.
///   - A remote API/Firestore search endpoint.
/// None of that matters to callers — they only ever see [search].
abstract class FoodSearchRepository {
  /// Returns foods whose name matches [query] (case-insensitive substring
  /// match in the mock; a real dataset would likely want proper
  /// full-text/fuzzy search). Empty [query] returns no results.
  Future<List<FoodItem>> search(String query);
}
