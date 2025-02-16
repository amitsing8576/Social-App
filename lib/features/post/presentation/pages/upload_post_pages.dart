import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/domain/entities/app_user.dart';
import 'package:socialapp/features/auth/presentation/components/my_text_field.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialapp/features/post/domain/entities/post.dart';
import 'package:socialapp/features/post/presentation/cubits/post_cubits.dart';
import 'package:socialapp/features/post/presentation/cubits/post_states.dart';

class UploadPostPages extends StatefulWidget {
  const UploadPostPages({super.key});

  @override
  State<UploadPostPages> createState() => _UploadPostPagesState();
}

class _UploadPostPagesState extends State<UploadPostPages> {
  final textController = TextEditingController();

  AppUser? currentUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final authcubit = context.read<AuthCubit>();
    currentUser = authcubit.currentUser;
  }

  void uploadPost() {
    if (textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Caption is required'),
          backgroundColor: Colors.black54,
        ),
      );
      return;
    }

    //create a new post object

    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userid: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      timeStamp: DateTime.now(),
      likes: [],
      saves: [],
      comments: [],
    );

    //post cubit
    final postCubit = context.read<PostCubit>();

    postCubit.createPost(newPost);

    //Navigator.pop(context);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(builder: (context, state) {
      if (state is PostLoading || state is PostUploading) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return buildUploadPage();
    }, listener: (context, state) {
      if (state is PostLoaded) {
        Navigator.pop(context);
      }
    });
  }

  Widget buildUploadPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        actions: [IconButton(onPressed: uploadPost, icon: Icon(Icons.upload))],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextField(
                  controller: textController,
                  hintText: "Caption",
                  obscureText: false),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: uploadPost,
                child: Text('Upload Post'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
