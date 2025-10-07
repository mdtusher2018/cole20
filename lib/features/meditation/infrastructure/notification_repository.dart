import 'package:cole20/core/api/i_api_service.dart';
import 'package:cole20/core/apiEndPoints.dart';
import 'package:cole20/features/meditation/domain/i_notification_repository.dart';
import 'package:cole20/features/meditation/domain/notification_response.dart';

class NotificationRepository implements INotificationRepository{
  final IApiService _apiService;

  NotificationRepository(this._apiService);
@override
  Future<NotificationResponse> fetchNotifications({required int page,int? limit}) async {
    final response = await _apiService.get(ApiEndpoints.notifications(page: page,limit: limit));
    return NotificationResponse.fromJson(response);
  }
}
