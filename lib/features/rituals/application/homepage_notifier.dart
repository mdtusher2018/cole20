import 'dart:developer';

import 'package:cole20/core/localstorage/i_local_storage_service.dart';
import 'package:cole20/core/localstorage/session_memory.dart';
import 'package:cole20/core/localstorage/storage_key.dart';
import 'package:cole20/features/rituals/domain/repository/i_ritual_repository.dart';
import 'package:cole20/features/rituals/domain/ritual_category_model.dart';
import 'package:cole20/features/rituals/domain/ritual_model.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'homepage_state.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomePageNotifier extends StateNotifier<HomepageState> {
  final IRitualRepository _repository;
  final ILocalStorageService _localStorageService;
  final SessionMemory _sessionalMemory;
  final Map<int, List<RitualCategory>> _cachedRituals = {};

  HomePageNotifier(
    this._repository,
    this._localStorageService,
    this._sessionalMemory,
  ) : super(HomepageState.initial()) {
    fetchCategoryName();
  }

  Future<String> fetchName() async {
    String? token = await _localStorageService.getString(StorageKey.token);

    if (token == null || token.isEmpty) {
      token ??= _sessionalMemory.token;
      if (token == null || token.isEmpty) {
        return "Guest";
      }
    }

    try {
      // Decode token safely
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Adjust key according to your token structure
      final fullName =
          decodedToken['fullName'] ??
          decodedToken['name'] ??
          decodedToken['userName'] ??
          "User";

      return fullName;
    } catch (e) {
      return "User";
    }
  }

  Future<int?> fetchCurrentDay() async {
    // if (kDebugMode) return 1;

    try {
      state = state.copyWith(status: HomePageStatus.loading);

      final currentDayResponse = await _repository.fetchCurrentDay();
      log("Today=======>>>>>>>>>");
      final today = currentDayResponse.days;
      final unreadNotification = currentDayResponse.unreadCount;

      state = state.copyWith(
        today: today,
        unreadNotification: unreadNotification,
      );

      await fetchRituals(day: today);

      return today;
    } catch (e) {
      log("Today=======>>>>>>>>>2");
      state = HomepageState.error(e.toString());
      return null;
    }
  }

  Future<void> fetchRituals({
    required int day,
    bool hardRefresh = false,
  }) async {
    // ✅ Check cache first
    if (_cachedRituals.containsKey(day) && !hardRefresh) {
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
  Future<(bool,String)> addRitual({
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

      return (true,"Ritual added successfully");
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isSubmitting: false);
      return (false,e.toString());
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
  Future<bool> completeRitual(String ritualId) async {
    try {
      state = state.copyWith(isSubmitting: true);
      final (message, status) = await _repository.completeRitual(ritualId);

      final updatedCategories =
          state.categories.map((category) {
            final updatedRituals =
                category.rituals.map((ritual) {
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
                      isComplete: status == 200 ? true : false,
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
      return status == 200;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to complete ritual: $e',
        isSubmitting: false,
      );
      return false;
    }
  }

  /// Delete a ritual
  Future<bool> deleteRitual(String ritualId) async {
    try {
      state = state.copyWith(isSubmitting: true);
      final (message, statuscode) = await _repository.deleteRitual(ritualId);

      final updatedCategories =
          state.categories.map((category) {
            final updatedRituals =
                category.rituals
                    .where(
                      (ritual) =>
                          (statuscode == 200) ? ritual.id != ritualId : true,
                    )
                    .toList();

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
      if (statuscode != 200) {
        state = state.copyWith(errorMessage: message, isSubmitting: false);
      }
      return statuscode == 200;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to delete ritual: $e',
        isSubmitting: false,
      );
      return false;
    }
  }
}
