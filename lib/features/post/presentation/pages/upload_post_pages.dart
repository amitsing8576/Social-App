import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:socialapp/features/auth/domain/entities/app_user.dart';

import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialapp/features/post/domain/entities/post.dart';
import 'package:socialapp/features/post/presentation/cubits/post_cubits.dart';
import 'package:socialapp/features/post/presentation/cubits/post_states.dart';
import 'package:socialapp/features/post/presentation/pages/file_picker.dart';

class UploadPostPages extends StatefulWidget {
  int index;
  UploadPostPages({super.key, required this.index});

  @override
  State<UploadPostPages> createState() => _UploadPostPagesState();
}

class _UploadPostPagesState extends State<UploadPostPages> {
  final textController = TextEditingController();
  final captionController = TextEditingController();

  String? _selectedCategory = 'Section 1';
  String? _selectedImage;
  bool _postAnonymously = false;

  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  final List<String> assetImages = [
    'assets/pic1_1.jpg',
    'assets/pic1_2.jpg',
    'assets/pic1_3.jpg',
    'assets/pic2_1.jpg',
    'assets/Context.png',
    'assets/eShram.jpg',
    'assets/How.jpg',
    'assets/Layout.png',
    'assets/Skill India.jpg',
    'assets/What, Why.jpg'
  ];

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take more space
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ImagePickerBottomSheet(
        assetImages: assetImages,
        onImageSelected: (imagePath) {
          setState(() {
            _selectedImage = imagePath;
          });
        },
      ),
    );
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
    final newPost;
    if (widget.index == 1) {
      newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userid: currentUser!.uid,
        userName: currentUser!.name,
        text: textController.text,
        caption: captionController.text,
        section: "Section 4",
        timeStamp: DateTime.now(),
        likes: [],
        saves: [],
        comments: [],
        imageUrl: _selectedImage,
        anonymous: false,
      );
    } else if (widget.index == 2) {
      newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userid: currentUser!.uid,
        userName: currentUser!.name,
        text: textController.text,
        caption: captionController.text,
        section: "Section 5",
        timeStamp: DateTime.now(),
        likes: [],
        saves: [],
        comments: [],
        imageUrl: _selectedImage,
        anonymous: false,
      );
    } else {
      newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userid: currentUser!.uid,
        userName: currentUser!.name,
        text: textController.text,
        caption: captionController.text,
        section: _selectedCategory!,
        timeStamp: DateTime.now(),
        likes: [],
        saves: [],
        comments: [],
        imageUrl: _selectedImage,
        anonymous: _postAnonymously,
      );
    }
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
        //backgroundColor: Colors.grey,
        title: const Text(
          'New Post',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: uploadPost,
              icon: const Icon(Icons.check_box_outlined, size: 28),
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
              if (widget.index == 0) ...[
                Center(
                  child: Text(
                    'Choose a category you want to post in ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryCard(
                      'Share/Learn\nSkills',
                      'Section 1',
                      Icons.computer_outlined,
                    ),
                    _buildCategoryCard(
                      'Problem\nDiscussions',
                      'Section 2',
                      Icons.chat_bubble_outline,
                    ),
                    _buildCategoryCard(
                      'Workplace\nExperience',
                      'Section 3',
                      Icons.people_outline,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Do you wish to post anonymously?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    _buildChoiceButton('Yes', true),
                    const SizedBox(width: 8),
                    _buildChoiceButton('No', false),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: AssetImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                color: Colors.grey.shade500,
                                size: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Upload image/video here',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: captionController,
                  decoration: const InputDecoration(
                    hintText: 'Write title here...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 12),

              // Content Field
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    hintText: 'Write content here...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: const TextStyle(fontSize: 16),
                  maxLines: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String section, IconData icon) {
    final isSelected = _selectedCategory == section;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = section;
        });
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue.shade300 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceButton(String label, bool value) {
    final isSelected = _postAnonymously == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _postAnonymously = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
