import 'package:cole20/features/rituals/domain/i_ritual_repository.dart';
import 'package:cole20/features/rituals/domain/ritual_category_model.dart';
import 'package:cole20/features/rituals/domain/ritual_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'homepage_state.dart';

class HomePageNotifier extends StateNotifier<HomepageState> {
  final IRitualRepository _repository;
  final Map<int, List<RitualCategory>> _cachedRituals = {};

  HomePageNotifier(this._repository) : super(HomepageState.initial()){
    fetchCategoryName();
  }

  Future<int?> fetchCurrentDay() async {
    if (kDebugMode) return 3;
    try {
      // Don’t reset everything — just show subtle loading if needed
      state = state.copyWith(status: HomePageStatus.loading);

      final currentDayResponse = await _repository.fetchCurrentDay();
      final today = currentDayResponse.days;

      // Keep the current data, only update today
      state = state.copyWith(today: today);

      // Fetch rituals for the current day
      await fetchRituals(day: today);

      return today;
    } catch (e) {
      state = HomepageState.error(e.toString());
      return null;
    }
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

  // Add a new ritual
  Future<void> addRitual({
    required String title,
    required String categoryId,
    required int startDay,
    int? duration,
  }) async {
    try {
      // Show loading only for submitting
      state = state.copyWith(isSubmitting: true);

      final newRitual = await _repository.addRitual(
        title,
        categoryId,
        startDay,
        duration,
      );

      // Optionally update local state with new ritual
      final updatedCategories = List<RitualCategory>.from(state.categories);

      final categoryIndex = updatedCategories.indexWhere(
        (c) => c.id == categoryId,
      );

      if (categoryIndex != -1) {
        updatedCategories[categoryIndex].rituals.add(newRitual);
      }

      state = state.copyWith(
        categories: updatedCategories,
        successMessage: "Ritual added successfully",
        isSubmitting: false,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isSubmitting: false);
    }
  }

  /// Edit an existing ritual
  Future<bool> editRitual(Ritual ritual) async {
    try {
      final updatedRitual = await _repository.editRitual(ritual);

      final day = updatedRitual.startDay;
      final categories = _cachedRituals[day] ?? [];

      // Update the ritual in its category
      for (var category in categories) {
        for (int i = 0; i < category.rituals.length; i++) {
          if (category.rituals[i].id == updatedRitual.id) {
            category.rituals[i] = updatedRitual;
            break;
          }
        }
      }

      _cachedRituals[day] = categories;

      if (state.today == day) {
        state = state.copyWith(categories: categories);
      }

      return true;
    } catch (e) {
      state = HomepageState.error(e.toString());
      return false;
    }
  }

  Future<void> fetchCategoryName() async {
    try {
      state = state.copyWith(fetchingCategory: true);
      final categories = await _repository.fetchCategoryName();

      state = state.copyWith(fetchingCategory: false, categoryName: categories);
    } catch (e) {
      state = HomepageState.error(e.toString());
    } finally {
      state = state.copyWith(fetchingCategory: false);
    }
  }




  /// Complete a ritual
  Future<void> completeRitual(String ritualId) async {
    try {
      state = state.copyWith(isSubmitting: true);
      final message = await _repository.completeRitual(ritualId);

      // Optionally, update local state to mark ritual as complete
      final updatedCategories = state.categories.map((category) {
        final updatedRituals = category.rituals.map((ritual) {
          if (ritual.id == ritualId) {
            return Ritual(
              id: ritual.id,
              title: ritual.title,
              categoryId: ritual.categoryId,
              startDay: ritual.startDay,
              duration: ritual.duration,
              createdByUser: ritual.createdByUser,
              creatorRole: ritual.creatorRole,
              createdAt: ritual.createdAt,
              isComplete: true,
            );
          }
          return ritual;
        }).toList();

        return RitualCategory(
          id: category.id,
          categoryName: category.categoryName,
          colorName: category.colorName,
          colorCode: category.colorCode,
          icon: category.icon,
          serialNumber: category.serialNumber,
          totalRitual: category.totalRitual,
          completeRitual: category.completeRitual + 1,
          rituals: updatedRituals,
        );
      }).toList();

      state = state.copyWith(
        categories: updatedCategories,
        successMessage: message,
        isSubmitting: false,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to complete ritual: $e',
        isSubmitting: false,
      );
    }
  }

  /// Delete a ritual
  Future<void> deleteRitual(String ritualId) async {
    try {
      state = state.copyWith(isSubmitting: true);
      final message = await _repository.deleteRitual(ritualId);

      // Remove ritual locally
      final updatedCategories = state.categories.map((category) {
        final updatedRituals =
            category.rituals.where((ritual) => ritual.id != ritualId).toList();

        return RitualCategory(
          id: category.id,
          categoryName: category.categoryName,
          colorName: category.colorName,
          colorCode: category.colorCode,
          icon: category.icon,
          serialNumber: category.serialNumber,
          totalRitual: updatedRituals.length,
          completeRitual: category.completeRitual,
          rituals: updatedRituals,
        );
      }).toList();

      state = state.copyWith(
        categories: updatedCategories,
        successMessage: message,
        isSubmitting: false,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to delete ritual: $e',
        isSubmitting: false,
      );
    }
  }


  
}
