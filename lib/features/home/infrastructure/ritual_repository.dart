import 'package:cole20/core/api/i_api_service.dart';
import 'package:cole20/core/apiEndPoints.dart';
import 'package:cole20/features/home/domain/current_day_response.dart';
import 'package:cole20/features/home/domain/ritual_response.dart';
import '../domain/i_ritual_repository.dart';
import '../domain/ritual_category_model.dart';

class HomeRepository implements IRitualRepository {
  final IApiService _apiService;

  HomeRepository(this._apiService) : super();
  @override
  Future<List<RitualCategory>> fetchRituals(int day) async {
    final response = await _apiService.get(ApiEndpoints.rituals(day));

    final result = RitualsResponse.fromJson(response);
    return result.data;
  }

  @override
  Future<CurrentDayResponse> fetchCurrentDay() async {
    final response = await _apiService.get(ApiEndpoints.fetchCurrentDay);
    return CurrentDayResponse.fromJson(response);
  }
}
