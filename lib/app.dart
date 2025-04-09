import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/data/firebase_auth_repo.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_states.dart';
import 'package:socialapp/features/auth/presentation/pages/auth_page.dart';
import 'package:socialapp/features/home/home_page.dart';
import 'package:socialapp/features/notification/data/firebase_notification_repo.dart';
import 'package:socialapp/features/notification/presentation/cubits/notification_cubits.dart';
import 'package:socialapp/features/post/data/firebase_post_repo.dart';
import 'package:socialapp/features/post/presentation/cubits/post_cubits.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final authrepo = FirebaseAuthRepo();
  final firebasePostRepo = FirebasePostRepo();
  final firebaseNotificationRepo = FirebaseNotificationRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authrepo, authRepo: authrepo)..checkAuth(),
        ),
        BlocProvider<NotificationCubit>(
          create: (context) => NotificationCubit(
            notificationRepo: firebaseNotificationRepo,
          ),
        ),
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            notificationCubit: context.read<NotificationCubit>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            if (authState is unAuthenticated) {
              return AuthPage();
            }
            if (authState is Authenticated) {
              return HomePage();
            }
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.black54,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class GlobalVariables {
  // Private constructor prevents instantiation
  GlobalVariables._();

  // Static email variable
  static const String adminEmail = "testuser2@gmail.com";
}
