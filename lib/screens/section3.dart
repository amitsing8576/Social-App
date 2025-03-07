import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/home/home_page.dart';
import 'package:socialapp/features/home/presentation/components/post_tile.dart';
import 'package:socialapp/features/post/presentation/cubits/post_cubits.dart';
import 'package:socialapp/features/post/presentation/cubits/post_states.dart';
import 'package:socialapp/widgets/post_tile4.dart';

class Section3Screen extends StatefulWidget {
  @override
  State<Section3Screen> createState() => _Section3ScreenState();
}

class _Section3ScreenState extends State<Section3Screen> {
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
          // Filter posts for Section 2
          final filteredPosts =
              state.posts.where((post) => post.section == 'Section 3').toList();

          if (filteredPosts.isEmpty) {
            return Center(
              child: Text("No Posts in Section 3"),
            );
          }
          return ListView.builder(
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = filteredPosts[index];
              return PostTile4(
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
