import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:cole20/features/meditation/application/notification_state.dart';
import 'package:cole20/core/providers.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(notificationNotifierProvider.notifier)
          .fetchNotifications(page: 1);
    });

    // Infinite scroll listener
    _scrollController.addListener(() {
      final state = ref.read(notificationNotifierProvider);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !state.isFetchingMore &&
          state.status != NotificationStatus.loading) {
        loadMore();
      }
    });
  }

  Future<void> loadMore() async {
    final notifier = ref.read(notificationNotifierProvider.notifier);
    setState(() => isLoadingMore = true);
    currentPage++;
    await notifier.fetchNotifications(page: currentPage);
    setState(() => isLoadingMore = false);
  }

  Future<void> refresh() async {
    currentPage = 1;
    await ref
        .read(notificationNotifierProvider.notifier)
        .fetchNotifications(page: 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: commonText("Notifications", size: 21, isBold: true),
        centerTitle: true,
      ),
      body:
          state.status == NotificationStatus.loading && currentPage == 1
              ? const Center(child: CircularProgressIndicator())
              : (state.notifications.isEmpty)
              ? Center(
                child: commonText(
                  "No notifications available.",
                  size: 18,
               
                ),
              )
              : RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.notifications.length + 1,
                  itemBuilder: (context, index) {
                    if (index < state.notifications.length) {
                      final notif = state.notifications[index];
                      final message = notif.message.text;
                      final createdAt = notif.createdAt; // use formatted
                      return _buildNotificationItem(
                        message: message,
                        timeAgo: timeAgo(createdAt),
                        isHighlighted: !notif.isRead,
                      );
                    } else {
                      // Loading indicator at the bottom
                      return isLoadingMore
                          ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                          : const SizedBox();
                    }
                  },
                ),
              ),
    );
  }

  Widget _buildNotificationItem({
    required String message,
    required String timeAgo,
    bool isHighlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xfff7e9b8c) : AppColors.white,
        border: Border.all(
          color: isHighlighted ? const Color(0xfff7e9b8c) : Colors.transparent,
          width: isHighlighted ? 1 : 0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/notification.png", width: 32, height: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonText(message, size: 16),
                const SizedBox(height: 4),
                commonText(timeAgo, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String timeAgo(DateTime createdAt) {
    final duration = DateTime.now().difference(createdAt);
    if (duration.inMinutes < 60) return "${duration.inMinutes} minutes ago";
    if (duration.inHours < 24) return "${duration.inHours} hours ago";
    return "${duration.inDays} days ago";
  }
}
