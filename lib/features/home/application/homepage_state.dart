import '../domain/ritual_category_model.dart';

enum HomePageStatus { initial, loading, loaded, error }

class HomepageState {
  final HomePageStatus status;
  final List<RitualCategory> categories;
  final String? errorMessage;
  final int today;

  const HomepageState._({
    required this.status,
    this.categories= const [],
    this.errorMessage,
    this.today = 1,
  });

  factory HomepageState.initial() =>
      const HomepageState._(status: HomePageStatus.initial);

  factory HomepageState.loading() =>
      const HomepageState._(status: HomePageStatus.loading);

  factory HomepageState.loaded(List<RitualCategory> categories, {int today = 1}) =>
      HomepageState._(
        status: HomePageStatus.loaded,
        categories: categories,
        today: today,
      );

  factory HomepageState.error(String message) =>
      HomepageState._(status: HomePageStatus.error, errorMessage: message);

  HomepageState copyWith({
    HomePageStatus? status,
    List<RitualCategory>? categories,
    String? errorMessage,
    int? today,
  }) {
    return HomepageState._(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
      today: today ?? this.today,
    );
  }

  bool get isInitial => status == HomePageStatus.initial;
  bool get isLoading => status == HomePageStatus.loading;
  bool get isLoaded => status == HomePageStatus.loaded;
  bool get hasError => status == HomePageStatus.error;
}
