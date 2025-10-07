import 'package:cole20/features/rituals/domain/category_name_model.dart';
import 'package:cole20/features/rituals/domain/response/current_day_response.dart';
import 'package:cole20/features/rituals/domain/ritual_category_model.dart';
import 'package:cole20/features/rituals/domain/ritual_model.dart';

abstract class IRitualRepository {
  Future<List<RitualCategory>> fetchRituals(int day);
  Future<Ritual> addRitual(
    String title,
    String categotyId,
    int startDay,
    int? duration,
  );

  Future<CurrentDayResponse> fetchCurrentDay();
  Future<List<RitualCategoryNameModel>> fetchCategoryName();

  Future<Ritual> editRitual(Ritual ritual);


  Future<(String,int)> completeRitual(String ritualId);

  Future<(String,int)> deleteRitual(String ritualId);

}
