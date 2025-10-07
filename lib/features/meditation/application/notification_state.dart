import 'package:cole20/features/meditation/domain/notification_response.dart';

enum NotificationStatus { initial, loading, loaded, error }

class NotificationState {
  final NotificationStatus status;
  final List<UserNotification> notifications;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final bool isFetchingMore;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.totalPages = 1,
    this.isFetchingMore = false,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<UserNotification>? notifications,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    bool? isFetchingMore,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}
