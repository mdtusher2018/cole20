import 'package:cole20/features/home/domain/i_ritual_repository.dart';
import 'package:cole20/features/home/domain/ritual_category_model.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'homepage_state.dart';

class HomePageNotifier extends StateNotifier<HomepageState> {
  final IRitualRepository _repository;
  final Map<int, List<RitualCategory>> _cachedRituals = {};

  HomePageNotifier(this._repository) : super(HomepageState.initial());

  Future<int?> fetchCurrentDay() async {
     return 1;
    // try {
    //   // Don’t reset everything — just show subtle loading if needed
    //   state = state.copyWith(status: HomePageStatus.loading);

    //   final currentDayResponse = await _repository.fetchCurrentDay();
    //   final today = currentDayResponse.days;

    //   // Keep the current data, only update today
    //   state = state.copyWith(today: today);

    //   // Fetch rituals for the current day
    //   await fetchRituals(day: today);

    //   return today;
    // } catch (e) {
    //   state = HomepageState.error(e.toString());
    //   return null;
    // }
  }

Future<void> fetchRituals({required int day}) async {
  // ✅ Check cache first
  if (_cachedRituals.containsKey(day)) {
    state = state.copyWith(
      status: HomePageStatus.loaded,
      categories: _cachedRituals[day],
      today: day,
    );
    return;
  }

  try {
    state = state.copyWith(status: HomePageStatus.loading);
    final categories = await _repository.fetchRituals(day);

    // 🔹 Store in cache
    _cachedRituals[day] = categories;

    state = state.copyWith(
      status: HomePageStatus.loaded,
      categories: categories,
      today: day,
    );
  } catch (e) {
    state = HomepageState.error(e.toString());
  }
}

}
