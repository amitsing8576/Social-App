import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/domain/entities/app_user.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialapp/features/post/presentation/cubits/post_cubits.dart';
import 'package:socialapp/features/post/presentation/cubits/post_states.dart';
import 'package:socialapp/widgets/post_tile3.dart';

class savedContentPage extends StatefulWidget {
  @override
  State<savedContentPage> createState() => savedContentPageState();
}

class savedContentPageState extends State<savedContentPage> {
  late final postCubit = context.read<PostCubit>();
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
    currentUser = context.read<AuthCubit>().currentUser;
  }

  void fetchAllPosts() {
    postCubit.FetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.DeletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoading && state is PostUploading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PostLoaded) {
          // Filter posts for Section 2
          final filteredPosts = state.posts
              .where((post) => post.saves.contains(currentUser!.uid))
              .toList();

          if (filteredPosts.isEmpty) {
            return Center(
              child: Text("No Posts in Section 2"),
            );
          }
          return ListView.builder(
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = filteredPosts[index];
              return PostTile3(
                post: post,
                onDeletePressed: () => deletePost(post.id),
              );
            },
          );
        } else if (state is PostError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
