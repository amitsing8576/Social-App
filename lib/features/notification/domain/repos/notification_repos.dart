import 'package:socialapp/features/notification/domain/entities/notification.dart';

abstract class NotificationRepo {
  Future<void> createNotification(Notification notification);
  Future<List<Notification>> fetchNotificationsForUser(String userId);
  Future<void> markNotificationAsRead(String notificationId);
  Future<void> markAllNotificationsAsRead(String userId);
  Future<void> deleteNotification(String notificationId);
  Future<int> getUnreadNotificationCount(String userId);
}
