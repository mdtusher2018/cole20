import '../domain/notification_response.dart';

abstract class INotificationRepository{
Future<NotificationResponse> fetchNotifications({required int page,int? limit});
}

