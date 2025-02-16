import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/data/firebase_auth_repo.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_states.dart';
import 'package:socialapp/features/auth/presentation/pages/auth_page.dart';
import 'package:socialapp/features/home/home_page.dart';
import 'package:socialapp/features/post/data/firebase_post_repo.dart';
import 'package:socialapp/features/post/presentation/cubits/post_cubits.dart';

class MyApp extends StatelessWidget {
  final authrepo = FirebaseAuthRepo();

  final firebasePostRepo = FirebasePostRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authrepo, authRepo: authrepo)..checkAuth(),
        ),
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(postRepo: firebasePostRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            //if user is unauthenticated show auth page
            if (authState is unAuthenticated) {
              return AuthPage();
            }

            //if user is authenticated show home page
            if (authState is Authenticated) {
              return HomePage();
            }
            // if user is loading show loading page
            else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
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
