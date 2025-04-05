import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart'; // Add this import
import 'package:socialapp/drawer/rule_rituals.dart';
import 'package:socialapp/drawer/savedContent.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:socialapp/features/auth/presentation/pages/auth_page.dart';
import 'package:socialapp/features/auth/presentation/pages/login_page.dart';
import 'package:socialapp/features/profile/profileScreen.dart';

class Drawerscreen extends StatefulWidget {
  const Drawerscreen({super.key});

  @override
  State<Drawerscreen> createState() => _DrawerscreenState();
}

class _DrawerscreenState extends State<Drawerscreen> {
  final SavedcontentPage _savedContentPage = SavedcontentPage();
  final PodcastPage _podcastPage = PodcastPage();
  final RulesPage _rulesPage = RulesPage();
  final MoodPage _moodPage = MoodPage();
  final PollPage _pollPage = PollPage();
  final AddFriendPage _addFriendPage = AddFriendPage();

  late final List<Map<String, dynamic>> menuItems;

  // Share function
  void _shareApp() {
    const String androidUrl =
        'https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME';
    const String iosUrl = 'https://apps.apple.com/app/idYOUR_APP_ID';
    final String message =
        'Check out Kaari घर!\nAndroid: $androidUrl\niOS: $iosUrl';
    Share.share(message);
  }

  @override
  void initState() {
    super.initState();

    menuItems = [
      {
        'icon': Icons.person_outline,
        'title': 'Edit/View Profile',
        'page': Profilescreen(),
      },
      {
        'icon': Icons.bookmark_border,
        'title': 'Saved Content',
        'page': _savedContentPage,
      },
      {
        'icon': Icons.mic_none_outlined,
        'title': 'Listen Podcast',
        'page': _podcastPage,
      },
      {
        'icon': Icons.rule_outlined,
        'title': 'Rules & Rituals',
        'page': RuleRituals(),
      },
      {
        'icon': Icons.mood,
        'title': 'Record Mood',
        'page': _moodPage,
      },
      {
        'icon': Icons.poll_outlined,
        'title': 'Monthly Poll',
        'page': _pollPage,
      },
      {
        'icon': Icons.person_add_outlined,
        'title': 'Add Friend',
        'page': _addFriendPage,
      },
      {
        'icon': Icons.share_outlined,
        'title': 'Share Kaari घर',
        'page': Container(), // Placeholder since we won't navigate
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black)),
        title: const Text('kaari घर',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            )),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.1,
                ),
                shrinkWrap: true,
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return _buildMenuItem(
                    icon: menuItems[index]['icon'],
                    title: menuItems[index]['title'],
                    page: menuItems[index]['page'],
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<AuthCubit>().logout();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.logout),
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle share differently
        if (title == 'Share Kaari घर') {
          _shareApp();
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 60,
                  color: const Color.fromARGB(221, 32, 32, 32),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Remove the SharePage class since it's no longer needed

// Keep other placeholder page classes unchanged
// ...

// Placeholder pages for each menu item

class SavedcontentPage extends StatelessWidget {
  const SavedcontentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Content'),
      ),
      body: savedContentPage(),
    );
  }
}

class PodcastPage extends StatelessWidget {
  const PodcastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listen Podcast'),
      ),
      body: const Center(
        child: Text('Podcast Page Content'),
      ),
    );
  }
}

class RulesPage extends StatelessWidget {
  const RulesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rules & Rituals'),
      ),
      body: const Center(
        child: Text('Rules & Rituals Page Content'),
      ),
    );
  }
}

class MoodPage extends StatelessWidget {
  const MoodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Mood'),
      ),
      body: const Center(
        child: Text('Mood Recording Page Content'),
      ),
    );
  }
}

class PollPage extends StatelessWidget {
  const PollPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Poll'),
      ),
      body: const Center(
        child: Text('Monthly Poll Page Content'),
      ),
    );
  }
}

class AddFriendPage extends StatelessWidget {
  const AddFriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
      ),
      body: const Center(
        child: Text('Add Friend Page Content'),
      ),
    );
  }
}
