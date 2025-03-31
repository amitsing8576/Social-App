import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/drawer/drawerScreen.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialapp/features/home/presentation/components/post_tile.dart';
import 'package:socialapp/features/notification/presentation/screens/notification_screen.dart';
import 'package:socialapp/features/post/domain/entities/post.dart';
import 'package:socialapp/features/post/presentation/cubits/post_cubits.dart';
import 'package:socialapp/features/post/presentation/cubits/post_states.dart';
import 'package:socialapp/features/post/presentation/pages/upload_post_pages.dart';

import 'package:socialapp/screens/screens2.dart';
import 'package:socialapp/screens/screens3.dart';
import 'package:socialapp/screens/screens4.dart';
import 'package:socialapp/screens/section2.dart';
import 'package:socialapp/screens/section3.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Widget> _screens = [
    Container(), // Placeholder for TabBarView
    Screens2(),
    Screens3(),
    WorkerAssistancePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Drawerscreen(),
                ),
              );
            },
            icon: Icon(Icons.menu)),
        title: Text('kaari घर', style: TextStyle(fontWeight: FontWeight.w500)),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UploadPostPages(),
              ),
            ),
            icon: Icon(Icons.add),
            iconSize: 30,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            icon: Icon(Icons.notifications_none),
            iconSize: 30,
          ),
        ],
        bottom: _currentIndex == 0
            ? TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    child: FittedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons
                              .precision_manufacturing), // Sewing Machine Icon
                          SizedBox(width: 8), // Space between icon and text
                          Text('Section 1'),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: FittedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons
                              .error_outline), // Chat Bubble with Exclamation
                          SizedBox(width: 8),
                          Text('Section 2'),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: FittedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.account_tree), // Network Tree Icon
                          SizedBox(width: 8),
                          Text('Section 3'),
                        ],
                      ),
                    ),
                  ),
                ],
                labelColor: Colors.black, // Active tab text color
                unselectedLabelColor: Colors.grey, // Inactive tab text color
                indicator: BoxDecoration(
                  color: Colors
                      .grey.shade300, // Background highlight for active tab
                  borderRadius: BorderRadius.circular(5),
                ),
              )
            : null,
      ),
      body: _currentIndex == 0
          ? TabBarView(
              controller: _tabController,
              children: [
                HomeFeedScreen(),
                Section2Screen(),
                Section3Screen() // Create this widget for Section 3 content
              ],
            )
          : _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        iconSize: 35,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business_center), label: 'Screen1'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Screen2'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Screen3'),
        ],
      ),
    );
  }
}

class HomeFeedScreen extends StatefulWidget {
  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
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
          // Filter posts for Section 1
          final filteredPosts =
              state.posts.where((post) => post.section == 'Section 1').toList();

          if (filteredPosts.isEmpty) {
            return Center(
              child: Text("No Posts in Section 1"),
            );
          }
          return ListView.builder(
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = filteredPosts[index];
              return PostTile(
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
