import 'plan_data.dart';

abstract class PlanRepository {
  Future<List<PlanTierData>> fetchTiers();
}
