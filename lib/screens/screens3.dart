import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/post/presentation/cubits/post_cubits.dart';
import 'package:socialapp/features/post/presentation/cubits/post_states.dart';
import 'package:socialapp/widgets/posttile2.dart';

class Screens3 extends StatefulWidget {
  const Screens3({super.key});

  @override
  State<Screens3> createState() => _Screens3State();
}

class _Screens3State extends State<Screens3> {
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
          final allPosts =
              state.posts.where((post) => post.section == 'Section 5').toList();

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
