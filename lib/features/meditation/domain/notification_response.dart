class NotificationResponse {
  final bool success;
  final int statusCode;
  final String message;
  final NotificationData data;

  NotificationResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: NotificationData.fromJson(json['data']),
    );
  }
}



class NotificationData {
  final List<UserNotification> notification;
  final Meta meta;

  NotificationData({
    required this.notification,
    required this.meta,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notification: (json['notification'] as List)
          .map((item) => UserNotification.fromJson(item))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}
class UserNotification {
  final String id;
  final Message message;
  final String userId;
  final String receiverId;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserNotification({
    required this.id,
    required this.message,
    required this.userId,
    required this.receiverId,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['_id'] ?? '',
      message: Message.fromJson(json['message']),
      userId: json['userId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      type: json['type'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Message {
  final String text;
  final List<String> photos;

  Message({
    required this.text,
    required this.photos,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
    );
  }
}

class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 1,
    );
  }
}
