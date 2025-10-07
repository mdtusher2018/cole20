import 'package:flutter_riverpod/legacy.dart';
import '../infrastructure/notification_repository.dart';
import 'notification_state.dart';

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationRepository _repository;

  NotificationNotifier(this._repository) : super(const NotificationState());

  /// Fetch first page or refresh
  Future<void> fetchNotifications({int page = 1}) async {
    try {
      if (page == 1) {
        state = state.copyWith(status: NotificationStatus.loading, currentPage: 1);
      } else {
        state = state.copyWith(isFetchingMore: true);
      }

      final response = await _repository.fetchNotifications(page: page);

      final notifications = page == 1
          ? response.data.notification
          : [...state.notifications, ...response.data.notification];

      state = state.copyWith(
        status: NotificationStatus.loaded,
        notifications: notifications,
        currentPage: page,
        totalPages: response.data.meta.totalPage,
        isFetchingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        status: NotificationStatus.error,
        errorMessage: e.toString(),
        isFetchingMore: false,
      );
    }
  }

  /// Load next page if available
  Future<void> loadMore() async {
    if (state.isFetchingMore) return;
    if (state.currentPage >= state.totalPages) return;

    final nextPage = state.currentPage + 1;
    await fetchNotifications(page: nextPage);
  }
}
