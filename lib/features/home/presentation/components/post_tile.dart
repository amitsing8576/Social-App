import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/domain/entities/app_user.dart';
import 'package:socialapp/features/auth/presentation/components/my_text_field.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialapp/features/post/domain/entities/comment.dart';
import 'package:socialapp/features/post/domain/entities/post.dart';
import 'package:socialapp/features/post/presentation/cubits/post_cubits.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostTile extends StatefulWidget {
  final Post post;
  final VoidCallback? onDeletePressed;
  const PostTile(
      {super.key, required this.post, required this.onDeletePressed});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  bool isOwnPost = false;
  AppUser? currentUser;
  bool isExpanded = false;
  bool showComments = false;
  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });

    context
        .read<PostCubit>()
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  String customTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return '${difference.inSeconds}s';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

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

  final CommentTextController = TextEditingController();

  void openNewCommentBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                content: MyTextField(
                  controller: CommentTextController,
                  hintText: 'Add a Comment',
                  obscureText: false,
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        addComment();
                        Navigator.pop(context);
                      },
                      child: Text('Post')),
                ]));
  }

  void addComment() {
    final text = CommentTextController.text;

    final newcomment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        postId: widget.post.id,
        userId: widget.post.userid,
        userName: widget.post.userName,
        text: text,
        timeStamp: DateTime.now());

    if (CommentTextController.text.isNotEmpty) {
      context.read<PostCubit>().addComment(widget.post.id, newcomment);
    }
  }

  @override
  void dispose() {
    CommentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> words = widget.post.text.split(' ');
    bool shouldShowViewMore = words.length > 20;
    String displayedText = isExpanded
        ? widget.post.text
        : (shouldShowViewMore
            ? words.take(17).join(' ') + '...'
            : widget.post.text);
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 17,
                    backgroundImage: AssetImage('assets/img.png'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.userName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.post.caption,
                          style: TextStyle(fontSize: 15),
                          //overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    customTimeAgo(widget.post.timeStamp),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (isOwnPost)
              IconButton(
                onPressed: widget.onDeletePressed, //=> deletePost(post.id),
                icon: Icon(Icons.delete),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 55.0, right: 10.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded; // Toggle full text
              });
            },
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: displayedText,
                  style: TextStyle(fontSize: 11, color: Colors.black),
                  children: shouldShowViewMore && !isExpanded
                      ? [
                          TextSpan(
                            text: " View More",
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          )
                        ]
                      : [],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 10.0),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(20), // Adjust the radius as needed
            child: Image.asset(
              'assets/img.png',
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const SizedBox(
              width: 50,
            ),
            GestureDetector(
                onTap: toggleLikePost,
                child: Icon(
                  widget.post.likes.contains(currentUser!.uid)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.post.likes.contains(currentUser!.uid)
                      ? Colors.red
                      : null,
                )),

            Text(widget.post.likes.length.toString(),
                style: TextStyle(color: Colors.grey[500])),
            const SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                setState(() => showComments = !showComments);
                if (showComments) {
                  openNewCommentBox();
                }
              },
              child: Icon(Icons.comment_outlined, size: 18),
            ),
            Text(widget.post.comments.length.toString(),
                style: TextStyle(color: Colors.grey[500])),
            const SizedBox(
              width: 20,
            ),
            GestureDetector(
                onTap: togglesavePost,
                child: Icon(widget.post.saves.contains(currentUser!.uid)
                    ? Icons.bookmark
                    : Icons.bookmark_border)),
            Text(widget.post.saves.length.toString(),
                style: TextStyle(color: Colors.grey[500])),

            const Spacer(),
            Icon(Icons.play_circle_outline_sharp),
            const SizedBox(
              width: 12,
            ),
            // Icon(Icons.)
          ],
        ),
        Divider(thickness: 2, color: Colors.grey[300]),
        if (showComments)
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Replies",
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ],
              ),
              Divider(thickness: 1, color: Colors.grey[300]),
              for (int i = 0; i < widget.post.comments.length; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 17,
                                backgroundImage: AssetImage('assets/img.png'),
                              ),
                              if (i < widget.post.comments.length - 1)
                                Container(
                                  width: 2,
                                  height:
                                      widget.post.comments[i].text.length * 0.6,
                                  color: Colors.grey[300],
                                ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.post.comments[i].userName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.post.comments[i].text,
                                  style: TextStyle(fontSize: 15),
                                  maxLines: null, // Fix truncation issue
                                  softWrap: true,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.favorite_border, size: 18),
                                    Text('0',
                                        style:
                                            TextStyle(color: Colors.grey[500])),
                                    const SizedBox(width: 10),
                                    Icon(Icons.comment_outlined, size: 18),
                                    Text('0',
                                        style:
                                            TextStyle(color: Colors.grey[500])),
                                    const SizedBox(width: 10),
                                    Icon(Icons.bookmark_border, size: 18),
                                    Text('0',
                                        style:
                                            TextStyle(color: Colors.grey[500])),
                                    const Spacer(),
                                    Icon(
                                      Icons.play_circle_outline_sharp,
                                      size: 18,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Text(
                            customTimeAgo(widget.post.comments[i].timeStamp),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              Divider(thickness: 1, color: Colors.grey[300]),
            ],
          ),
      ],
    );
  }
}
