import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/domain/entities/app_user.dart';
import 'package:socialapp/features/auth/presentation/components/my_text_field.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialapp/features/post/domain/entities/comment.dart';
import 'package:socialapp/features/post/domain/entities/post.dart';
import 'package:socialapp/features/post/presentation/cubits/post_cubits.dart';

class PostTile2 extends StatefulWidget {
  final Post post;

  const PostTile2({super.key, required this.post});

  @override
  State<PostTile2> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile2> {
  bool isOwnPost = false;
  AppUser? currentUser;

  void togglesavePost() {
    final issaved = widget.post.saves.contains(currentUser!.uid);

    setState(() {
      if (issaved) {
        widget.post.saves.remove(currentUser!.uid);
      } else {
        widget.post.saves.add(currentUser!.uid);
      }
    });

    context
        .read<PostCubit>()
        .toggleSavePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      setState(() {
        if (issaved) {
          widget.post.saves.add(currentUser!.uid);
        } else {
          widget.post.saves.remove(currentUser!.uid);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final authcubit = context.read<AuthCubit>();
    currentUser = authcubit.currentUser;
    isOwnPost = (widget.post.userid == currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    List<String> words = widget.post.text.split(' ');
    bool shouldShowViewMore = words.length > 20;
    String displayedText = shouldShowViewMore
        ? words.take(1).join(' ') + '... '
        : widget.post.text;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15), bottom: Radius.circular(15)),
              child: Image.asset(
                'assets/img.png', // Replace with your asset image path
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    // Ensures text does not overflow
                    child: Text(
                      displayedText,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize
                        .min, // Prevents Row from expanding unnecessarily
                    children: [
                      GestureDetector(
                        onTap: togglesavePost,
                        child: Icon(
                          widget.post.saves.contains(currentUser!.uid)
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                        ),
                      ),
                      SizedBox(width: 4),
                      //Text(widget.post.saves.length.toString()),
                      SizedBox(width: 4),
                      Icon(Icons.play_circle_outline_sharp),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
