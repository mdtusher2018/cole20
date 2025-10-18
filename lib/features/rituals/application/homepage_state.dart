import 'package:cole20/features/rituals/domain/category_name_model.dart';

import '../domain/ritual_category_model.dart';

enum HomePageStatus { initial, loading, loaded, error }

class HomepageState {
  final HomePageStatus status;
  final List<RitualCategory> categories;
  final String? errorMessage;
  final int today;
  final int unreadNotification;
  final String? successMessage;
  final bool isRefreshing;
  final bool isSubmitting;
  final bool fetchingCategory;
  final List<RitualCategoryNameModel> categoryName;

  const HomepageState._({
    required this.status,
    this.categories = const [],
    this.errorMessage,
    this.today = 0,
    this.unreadNotification=0,
    this.successMessage,
    this.isRefreshing = false,
    this.isSubmitting = false,
    this.fetchingCategory = false,
    this.categoryName = const [],
  });

  factory HomepageState.initial() =>
      const HomepageState._(status: HomePageStatus.initial);

  factory HomepageState.loading({bool refreshing = false}) =>
      HomepageState._(status: HomePageStatus.loading, isRefreshing: refreshing);

  factory HomepageState.loaded(
    List<RitualCategory> categories, {
    
    String? successMessage,
    bool isSubmitting = false,
  }) => HomepageState._(
    status: HomePageStatus.loaded,
    categories: categories,
    
    successMessage: successMessage,
    isSubmitting: isSubmitting,
  );

  factory HomepageState.error(String message) =>
      HomepageState._(status: HomePageStatus.error, errorMessage: message);

  HomepageState copyWith({
    HomePageStatus? status,
    List<RitualCategory>? categories,
    String? errorMessage,
    int? today,
    int? unreadNotification,
    String? successMessage,
    bool? isRefreshing,
    bool? isSubmitting,
    bool? fetchingCategory,
    List<RitualCategoryNameModel>? categoryName,
  }) {
    return HomepageState._(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: this.errorMessage,
      today: today ?? this.today,
      unreadNotification: unreadNotification?? this.unreadNotification,
      successMessage: successMessage ?? this.successMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      fetchingCategory: fetchingCategory ?? this.fetchingCategory,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  bool get isInitial => status == HomePageStatus.initial;
  bool get isLoading => status == HomePageStatus.loading;
  bool get isLoaded => status == HomePageStatus.loaded;
  bool get hasError => status == HomePageStatus.error;
}
