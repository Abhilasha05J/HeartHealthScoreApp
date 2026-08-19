import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_plan_repository.dart';
import '../domain/plan_data.dart';
import '../domain/plan_repository.dart';

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return MockPlanRepository();
});

final planTiersProvider = FutureProvider<List<PlanTierData>>((ref) async {
  final repo = ref.watch(planRepositoryProvider);
  return repo.fetchTiers();
});

/// Which tab is active — transient UI state, independent of the fetched
/// tier data itself. Defaults to the first tab; the screenshots show all
/// three states so there's no clear signal on the intended initial tab.
final selectedPlanTierProvider = StateProvider<PlanTierKey>((ref) => PlanTierKey.basic);
