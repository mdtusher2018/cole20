import 'package:cole20/core/api/i_api_service.dart';
import 'package:cole20/core/apiEndPoints.dart';
import 'package:cole20/features/rituals/domain/add_ritual_response.dart';
import 'package:cole20/features/rituals/domain/category_name_model.dart';
import 'package:cole20/features/rituals/domain/category_name_response.dart';
import 'package:cole20/features/rituals/domain/current_day_response.dart';
import 'package:cole20/features/rituals/domain/ritual_model.dart';
import 'package:cole20/features/rituals/domain/ritual_response.dart';
import '../domain/i_ritual_repository.dart';
import '../domain/ritual_category_model.dart';

class RitualRepository implements IRitualRepository {
  final IApiService _apiService;

  RitualRepository(this._apiService) : super();
  @override
  Future<List<RitualCategory>> fetchRituals(int day) async {
    final response = await _apiService.get(ApiEndpoints.rituals(day));

    final result = RitualsResponse.fromJson(response);
    return result.data;
  }

  @override
  Future<Ritual> addRitual(
    String title,
    String categotyId,
    int startDay,
    int? duration,
  ) async {
    final response = await _apiService.post(ApiEndpoints.addRitual, {
      "title": title,
      "categoryId": categotyId,
      "startDay": startDay,
      "duration": duration,
    });

    final result = AddRitualsResponse.fromJson(response);
    return result.data;
  }

  @override
  Future<CurrentDayResponse> fetchCurrentDay() async {
    final response = await _apiService.get(ApiEndpoints.fetchCurrentDay);
    return CurrentDayResponse.fromJson(response);
  }

  @override
  Future<Ritual> editRitual(Ritual ritual) async {
    final response = await _apiService
        .patch(ApiEndpoints.editRitual(ritual.id), {
          "categoryId": ritual.categoryId,
          "title": ritual.title,
          "startDate": ritual.startDay,
          "startDay": ritual.startDay,
          "duration": ritual.duration,
        });

    final result = AddRitualsResponse.fromJson(response);
    return result.data;
  }

  @override
  Future<List<RitualCategoryNameModel>> fetchCategoryName() async {
    final response = await _apiService.get(ApiEndpoints.categoryName);

    final result = CategoryNameResponse.fromJson(response);
    return result.data;
  }
  
@override
Future<String> completeRitual(String ritualId) async {
  try {
    final response = await _apiService.post(ApiEndpoints.completeRitual(ritualId), {});
    // Assuming API returns something like { "success": true, "message": "Ritual completed" }
    return response['message'] ?? 'Ritual completed successfully';
  } catch (e) {
    return 'Failed to complete ritual: $e';
  }
}

@override
Future<String> deleteRitual(String ritualId) async {
  try {
    final response = await _apiService.delete(ApiEndpoints.deleteRitual(ritualId));
    // Assuming API returns something like { "success": true, "message": "Ritual deleted" }
    return response['message'] ?? 'Ritual deleted successfully';
  } catch (e) {
    return 'Failed to delete ritual: $e';
  }
}


}
