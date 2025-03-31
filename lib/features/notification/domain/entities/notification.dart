import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType { like, comment, save }

class Notification {
  final String id;
  final String userId; // User who will receive the notification
  final String triggerUserId; // User who triggered the notification
  final String triggerUserName;
  final String postId;
  final NotificationType type;
  final DateTime timeStamp;
  final bool isRead;
  final String? text; // Optional text for comments

  Notification({
    required this.id,
    required this.userId,
    required this.triggerUserId,
    required this.triggerUserName,
    required this.postId,
    required this.type,
    required this.timeStamp,
    required this.isRead,
    this.text,
  });

  // Convert notification to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'triggerUserId': triggerUserId,
      'triggerUserName': triggerUserName,
      'postId': postId,
      'type': type.toString().split('.').last, // Store enum as string
      'timeStamp': timeStamp,
      'isRead': isRead,
      'text': text,
    };
  }

  // Convert JSON to notification
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      userId: json['userId'],
      triggerUserId: json['triggerUserId'],
      triggerUserName: json['triggerUserName'],
      postId: json['postId'],
      type: NotificationType.values.firstWhere(
          (e) => e.toString().split('.').last == json['type'],
          orElse: () => NotificationType.like),
      timeStamp: (json['timeStamp'] as Timestamp).toDate(),
      isRead: json['isRead'] ?? false,
      text: json['text'],
    );
  }
}
