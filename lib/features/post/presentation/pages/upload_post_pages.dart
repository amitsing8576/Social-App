import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final captionController = TextEditingController();
  final List<String> _sections = ['Section 1', 'Section 2', 'Section 3'];
  late String _selectedSection = _sections[0];
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> _pickImage() async {
    // Request permission before accessing the gallery
    if (await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted) {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gallery permission is required!')),
      );
    }
  }

  void getCurrentUser() async {
    final authcubit = context.read<AuthCubit>();
    currentUser = authcubit.currentUser;
  }

  void uploadPost() {
    if (captionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Caption is required'),
          backgroundColor: Colors.black54,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      );
      return;
    }

    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userid: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      caption: captionController.text,
      section: _selectedSection,
      timeStamp: DateTime.now(),
      likes: [],
      saves: [],
      comments: [],
    );

    final postCubit = context.read<PostCubit>();
    postCubit.createPost(newPost);
  }

  @override
  void dispose() {
    textController.dispose();
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(builder: (context, state) {
      if (state is PostLoading || state is PostUploading) {
        return Scaffold(
          body: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
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
        elevation: 0,
        backgroundColor: Colors.grey,
        title: const Text(
          'Create Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: uploadPost,
              icon: const Icon(Icons.cloud_upload, size: 28),
              tooltip: 'Upload Post',
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Selection Area
              Center(
                child: Column(
                  children: [
                    if (_selectedImage != null)
                      Container(
                        width: 200,
                        height: 200,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                          image: DecorationImage(
                            image: FileImage(File(_selectedImage!.path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      label: Text(
                        _selectedImage == null ? 'Add Photo' : 'Change Photo',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Choose Section',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                width: double.infinity,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSection,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSection = newValue!;
                      });
                    },
                    items: _sections.map((location) {
                      return DropdownMenuItem(
                        value: location,
                        child: Text(
                          location,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: captionController,
                      decoration: const InputDecoration(
                        hintText: "Write a caption...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: const TextStyle(fontSize: 18),
                      maxLines: 3,
                    ),
                    const Divider(height: 32),
                    TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: "Write your post content here...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: const TextStyle(fontSize: 16),
                      maxLines: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: uploadPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Upload Post',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
