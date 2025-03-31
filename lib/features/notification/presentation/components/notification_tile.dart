import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/notification/domain/entities/notification.dart';
import 'package:socialapp/features/notification/domain/entities/notification.dart'
    as custom;
import 'package:socialapp/features/notification/presentation/cubits/notification_cubits.dart';
import 'package:socialapp/features/post/presentation/cubits/post_cubits.dart';
import 'package:socialapp/widgets/textToSpeech.dart';

class NotificationTile extends StatefulWidget {
  final custom.Notification notification;
  final bool showHeader;

  const NotificationTile({
    Key? key,
    required this.notification,
    this.showHeader = false,
  }) : super(key: key);

  @override
  State<NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  bool isTtsPlaying = false;

  String _getNotificationTitle() {
    switch (widget.notification.type) {
      case NotificationType.like:
        return "Your work is getting noticed! ${widget.notification.triggerUserName} liked your post—keep sharing your craft with the community!";
      case NotificationType.comment:
        return "Someone left a comment on your post! Tap here to see what they said.";
      case NotificationType.save:
        return "Great news! ${widget.notification.triggerUserName} saved your post to revisit later. Your work is inspiring others!";
      default:
        return "New notification";
    }
  }

  IconData _getNotificationIcon() {
    switch (widget.notification.type) {
      case NotificationType.like:
        return Icons.favorite_border;
      case NotificationType.comment:
        return Icons.chat_bubble_outline;
      case NotificationType.save:
        return Icons.bookmark_border;
      default:
        return Icons.notifications_none;
    }
  }

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
    // Get the PostCubit directly in the build method instead of storing it
    final postCubit = context.read<PostCubit>();

    return Column(
      children: [
        // Section header - only show if showHeader is true
        if (widget.showHeader)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: Text(
              _getTimeSection(widget.notification.timeStamp),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        // Divider after header
        if (widget.showHeader)
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
        // Notification tile
        InkWell(
          onTap: () {
            if (!widget.notification.isRead) {
              context
                  .read<NotificationCubit>()
                  .markNotificationAsRead(widget.notification.id);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon on the left
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Icon(
                    _getNotificationIcon(),
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                // Notification text
                Expanded(
                  child: Text(
                    _getNotificationTitle(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
                // TTS and settings icons
                TTSPage(
                  text: _getNotificationTitle(),
                  onPlayStateChanged: (isPlaying) {
                    setState(() {
                      isTtsPlaying = isPlaying;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
