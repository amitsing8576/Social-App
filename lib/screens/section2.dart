import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/post/presentation/cubits/post_cubits.dart';
import 'package:socialapp/features/post/presentation/cubits/post_states.dart';
import 'package:socialapp/widgets/post_tile3.dart';

class Section2Screen extends StatefulWidget {
  @override
  State<Section2Screen> createState() => Section2ScreenState();
}

class Section2ScreenState extends State<Section2Screen> {
  late final postCubit = context.read<PostCubit>();

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
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
          final allPosts = state.posts;

          if (allPosts.isEmpty) {
            return Center(
              child: Text("No Posts"),
            );
          }
          return ListView.builder(
            itemCount: allPosts.length,
            itemBuilder: (context, index) {
              final post = state.posts[index];
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
