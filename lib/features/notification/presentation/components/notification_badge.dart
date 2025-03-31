import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialapp/features/notification/presentation/cubits/notification_cubits.dart';
import 'package:socialapp/features/notification/presentation/cubits/notification_states.dart';

class NotificationBadge extends StatefulWidget {
  final Widget child;

  const NotificationBadge({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge> {
  @override
  void initState() {
    super.initState();
    _fetchUnreadCount();
  }

  void _fetchUnreadCount() {
    final currentUser = context.read<AuthCubit>().currentUser;
    if (currentUser != null) {
      context
          .read<NotificationCubit>()
          .fetchUnreadNotificationCount(currentUser.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        int unreadCount = 0;

        if (state is NotificationCountLoaded) {
          unreadCount = state.count;
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            widget.child,
            if (unreadCount > 0)
              Positioned(
                right: -5,
                top: -5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    unreadCount > 9 ? '9+' : '$unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
