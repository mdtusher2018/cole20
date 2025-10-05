import 'package:cole20/features/home/domain/current_day_response.dart';
import 'package:cole20/features/home/domain/ritual_category_model.dart';


abstract class IRitualRepository {
  Future<List<RitualCategory>> fetchRituals(int day);

  Future<CurrentDayResponse> fetchCurrentDay();
}
