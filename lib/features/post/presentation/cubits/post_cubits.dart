import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/post/domain/entities/comment.dart';
import 'package:socialapp/features/post/domain/entities/post.dart';
import 'package:socialapp/features/post/domain/repos/post_repos.dart';
import 'package:socialapp/features/post/presentation/cubits/post_states.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  PostCubit({required this.postRepo}) : super(PostInitial());

  Future<void> createPost(Post post) async {
    try {
      postRepo.createPost(post);

      FetchAllPosts();
    } catch (e) {
      emit(PostError("Error creating post $e"));
    }
  }

  Future<void> FetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchAllPost();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError("Error fetching posts $e"));
    }
  }

  Future<void> DeletePost(String postId) async {
    try {
      postRepo.deletePost(postId);
      //emit(PostInitial());
    } catch (e) {
      emit(PostError("Error deleting post $e"));
    }
  }

  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.togglelikePost(postId, userId);
    } catch (e) {
      emit(PostError("Error toggling like post $e"));
    }
  }

  Future<void> toggleSavePost(String postId, String userId) async {
    try {
      await postRepo.togglesavePost(postId, userId);
    } catch (e) {
      emit(PostError("Error toggling save post $e"));
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);

      FetchAllPosts();
    } catch (e) {
      emit(PostError("Error adding comment $e"));
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);

      FetchAllPosts();
    } catch (e) {
      emit(PostError("Error deleting comment $e"));
    }
  }
}
