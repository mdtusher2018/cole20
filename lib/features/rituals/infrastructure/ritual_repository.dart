import 'package:cole20/core/api/i_api_service.dart';
import 'package:cole20/core/apiEndPoints.dart';
import 'package:cole20/features/rituals/domain/response/add_ritual_response.dart';
import 'package:cole20/features/rituals/domain/category_name_model.dart';
import 'package:cole20/features/rituals/domain/response/category_name_response.dart';
import 'package:cole20/features/rituals/domain/response/current_day_response.dart';
import 'package:cole20/features/rituals/domain/ritual_model.dart';
import 'package:cole20/features/rituals/domain/response/ritual_response.dart';
import '../domain/repository/i_ritual_repository.dart';
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
Future<(String,int)> completeRitual(String ritualId) async {
  try {
    final response = await _apiService.post(ApiEndpoints.completeRitual(ritualId), {});
    // Assuming API returns something like { "success": true, "message": "Ritual completed" }
    return (response['message'] as String,response['statusCode']as int);
  } catch (e) {
    return ('Failed to complete ritual: $e',500);
  }
}

@override
Future<(String,int)> deleteRitual(String ritualId) async {
  try {
    final response = await _apiService.delete(ApiEndpoints.deleteRitual(ritualId));
    // Assuming API returns something like { "success": true, "message": "Ritual deleted" }
    return (response['message'] as String,response['statusCode']as int);
  } catch (e) {
    return ('Failed to delete ritual: $e',500);
  }
}


}
