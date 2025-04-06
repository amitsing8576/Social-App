import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/app.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialapp/features/notification/presentation/components/notification_tile.dart';
import 'package:socialapp/features/notification/presentation/cubits/notification_cubits.dart';
import 'package:socialapp/features/notification/presentation/cubits/notification_states.dart';
import 'package:socialapp/features/notification/presentation/screens/admin_notfication_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final currentUsr;
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    final currentUser = context.read<AuthCubit>().currentUser;
    currentUsr = currentUser!.email;
    if (currentUser != null) {
      context
          .read<NotificationCubit>()
          .fetchNotificationsForUser(currentUser.uid);
    }
  }

  // Add this method to group notifications by time period
  String _getTimeSection(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) return "Today";
    if (difference.inDays == 1) return "Yesterday";
    if (difference.inDays < 7) return "This Week";
    return "Last Week";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              final currentUser = context.read<AuthCubit>().currentUser;
              if (currentUser != null) {
                context
                    .read<NotificationCubit>()
                    .markAllNotificationsAsRead(currentUser.uid);
              }
            },
            child: const Text('Mark all as read'),
          ),
          if (currentUsr == GlobalVariables.adminEmail) ...[
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => AdminNotficationScreen()),
                  );
                },
                icon: Icon(Icons.add_alarm_outlined))
          ],
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationsLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return const Center(
                child: Text('No notifications yet'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadNotifications();
              },
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final showHeader = index == 0 ||
                      _getTimeSection(notification.timeStamp) !=
                          _getTimeSection(notifications[index - 1].timeStamp);

                  return NotificationTile(
                    notification: notification,
                    showHeader: showHeader,
                  );
                },
              ),
            );
          } else if (state is NotificationError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          } else {
            return const Center(
              child: Text('No notifications'),
            );
          }
        },
      ),
    );
  }
}
