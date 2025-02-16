import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/post/presentation/cubits/post_cubits.dart';
import 'package:socialapp/features/post/presentation/cubits/post_states.dart';
import 'package:socialapp/widgets/posttile2.dart';

class Screens2 extends StatefulWidget {
  const Screens2({super.key});

  @override
  State<Screens2> createState() => _Screens2State();
}

class _Screens2State extends State<Screens2> {
  late PostCubit postCubit;

  @override
  void initState() {
    super.initState();

    // Delay the call to fetch posts until after build context is available
    Future.microtask(() {
      postCubit = context.read<PostCubit>();
      fetchAllPosts();
    });
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
        if (state is PostLoading || state is PostUploading) {
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

          return Scaffold(
            body: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                return PostTile2(
                    post: allPosts[index]); // Fixing the post parameter
              },
            ),
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
