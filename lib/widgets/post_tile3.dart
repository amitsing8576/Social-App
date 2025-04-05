import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/domain/entities/app_user.dart';
import 'package:socialapp/features/auth/presentation/components/my_text_field.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialapp/features/notification/domain/entities/notification.dart';
import 'package:socialapp/features/notification/presentation/cubits/notification_cubits.dart';
import 'package:socialapp/features/post/domain/entities/comment.dart';
import 'package:socialapp/features/post/domain/entities/post.dart';
import 'package:socialapp/features/post/presentation/cubits/post_cubits.dart';
import 'package:socialapp/widgets/textToSpeech.dart';

class PostTile3 extends StatefulWidget {
  final Post post;
  final VoidCallback? onDeletePressed;

  const PostTile3({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTile3> createState() => _PostTile3State();
}

class _PostTile3State extends State<PostTile3> {
  bool isOwnPost = false;
  bool showComments = false; // Toggle comments section
  bool isTtsPlaying = false;

  AppUser? currentUser;

  final CommentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userid == currentUser!.uid);
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
    final notification = Notificationn(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: widget.post.userid,
      triggerUserId: currentUser!.uid,
      triggerUserName: currentUser!.name,
      postId: widget.post.id,
      type: 1, // 1 for like, 2 for save, 3 for comment
      timeStamp: DateTime.now(),
      isRead: false,
    );
    if (isOwnPost == false) {
      if (isLiked == false) {
        context.read<NotificationCubit>().createNotification(notification);
      }
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
    final notification = Notificationn(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: widget.post.userid,
      triggerUserId: currentUser!.uid,
      triggerUserName: currentUser!.name,
      postId: widget.post.id,
      type: 2, // 1 for like, 2 for save, 3 for comment
      timeStamp: DateTime.now(),
      isRead: false,
    );
    if (isOwnPost == false) {
      if (issaved == false) {
        context.read<NotificationCubit>().createNotification(notification);
      }
    }
  }

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
      final notification = Notificationn(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.post.userid,
        triggerUserId: currentUser!.uid,
        triggerUserName: currentUser!.name,
        postId: widget.post.id,
        type: 3, // 1 for like, 2 for save, 3 for comment
        timeStamp: DateTime.now(),
        isRead: false,
      );
      if (isOwnPost == false) {
        context.read<NotificationCubit>().createNotification(notification);
      }
    }
  }

  @override
  void dispose() {
    CommentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Post Header
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundImage: AssetImage('assets/img.png'),
              ),
              const SizedBox(width: 10),
              Text(
                widget.post.anonymous ? "Anonymous" : widget.post.userName,
                style: TextStyle(fontWeight: FontWeight.bold),
                //overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Text(
                customTimeAgo(widget.post.timeStamp),
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.post.caption,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.post.text,
              style: TextStyle(fontSize: 12),
              //overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 10.0),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(10), // Adjust the radius as needed
              child: widget.post.imageUrl == null
                  ? Container()
                  : Image.asset(
                      '${widget.post.imageUrl}',
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(height: 10),
          // Post Actions (Like, Comment, Save)
          Row(
            children: [
              //const SizedBox(width: 50),
              GestureDetector(
                onTap: toggleLikePost,
                child: Icon(
                  size: 18,
                  widget.post.likes.contains(currentUser!.uid)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.post.likes.contains(currentUser!.uid)
                      ? Colors.red
                      : null,
                ),
              ),
              Text(widget.post.likes.length.toString(),
                  style: TextStyle(color: Colors.grey[500])),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() => showComments = !showComments);
                },
                child: Icon(Icons.comment_outlined, size: 18),
              ),
              Text(widget.post.comments.length.toString(),
                  style: TextStyle(color: Colors.grey[500])),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: togglesavePost,
                child: Icon(
                  size: 18,
                  widget.post.saves.contains(currentUser!.uid)
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                ),
              ),
              Text(widget.post.saves.length.toString(),
                  style: TextStyle(color: Colors.grey[500])),
              const Spacer(),
              //Icon(Icons.play_circle_outline_sharp, size: 18),
              TTSPage(
                text: widget.post.text,
                onPlayStateChanged: (isPlaying) {
                  setState(() {
                    isTtsPlaying = isPlaying;
                  });
                },
              ),
              const SizedBox(width: 12),
            ],
          ),

          Divider(thickness: 1, color: Colors.grey[300]),

          // Show Comments Section when toggled
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
                    const Spacer(),
                    IconButton(
                      onPressed: openNewCommentBox,
                      icon: Icon(Icons.add_comment_outlined),
                      iconSize: 25,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 1,
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
                                        widget.post.comments[i].text.length *
                                            0.6,
                                    color: Colors.grey[300],
                                  ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.post.comments[i].userName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      Text(
                                        customTimeAgo(
                                            widget.post.comments[i].timeStamp),
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
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
                                          style: TextStyle(
                                              color: Colors.grey[500])),
                                      const SizedBox(width: 10),
                                      Icon(Icons.comment_outlined, size: 18),
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.grey[500])),
                                      const SizedBox(width: 10),
                                      Icon(Icons.bookmark_border, size: 18),
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.grey[500])),
                                      const Spacer(),
                                      TTSPage(
                                        text: widget.post.comments[i].text,
                                        onPlayStateChanged: (isPlaying) {
                                          setState(() {
                                            isTtsPlaying = isPlaying;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                Divider(thickness: 1, color: Colors.grey[300]),
              ],
            ),
        ],
      ),
    );
  }
}
