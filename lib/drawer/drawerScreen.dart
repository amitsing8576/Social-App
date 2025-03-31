import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';

class Drawerscreen extends StatefulWidget {
  const Drawerscreen({super.key});

  @override
  State<Drawerscreen> createState() => _DrawerscreenState();
}

class _DrawerscreenState extends State<Drawerscreen> {
  // Placeholder pages need to be defined before they're used in menuItems
  final ProfilePage _profilePage = ProfilePage();
  final SavedContentPage _savedContentPage = SavedContentPage();
  final PodcastPage _podcastPage = PodcastPage();
  final RulesPage _rulesPage = RulesPage();
  final MoodPage _moodPage = MoodPage();
  final PollPage _pollPage = PollPage();
  final AddFriendPage _addFriendPage = AddFriendPage();
  final SharePage _sharePage = SharePage();

  // List of menu items with their icons and names
  late final List<Map<String, dynamic>> menuItems;

  @override
  void initState() {
    super.initState();

    // Initialize menuItems in initState
    menuItems = [
      {
        'icon': Icons.person_outline,
        'title': 'Edit/View Profile',
        'page': _profilePage,
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
        'page': _rulesPage,
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
        'page': _sharePage,
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
            // Error: GridView.builder needs to be wrapped in a container with height or Expanded
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
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
                  // 'weight' property doesn't exist for Icon class, remove it
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

// Placeholder pages for each menu item
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit/View Profile'),
      ),
      body: const Center(
        child: Text('Profile Page Content'),
      ),
    );
  }
}

class SavedContentPage extends StatelessWidget {
  const SavedContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Content'),
      ),
      body: const Center(
        child: Text('Saved Content Page'),
      ),
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

class SharePage extends StatelessWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Kaari घर'),
      ),
      body: const Center(
        child: Text('Share Page Content'),
      ),
    );
  }
}
