import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/app.dart';
import 'package:socialapp/features/auth/domain/entities/app_user.dart';
import 'package:socialapp/features/auth/presentation/cubits/auth_cubit.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  AppUser? currentUser;
  @override
  void initState() {
    super.initState();
    // Fetch the current user from the AuthCubit
    currentUser = context.read<AuthCubit>().currentUser;
  }

  late TextEditingController usernameController =
      TextEditingController(text: currentUser?.name ?? '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              final updatedUser =
                  currentUser!.copyWith(name: usernameController.text);
              context.read<AuthCubit>().updateUser(updatedUser);
              navigatorKey.currentState?.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully!'),
                ),
              );
            },
            icon: const Icon(Icons.check_box_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Add image picker logic
                },
                child: const CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(
                      'https://www.w3schools.com/howto/img_avatar.png'),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tap on the above icon to change/add new profile picture. Pick any image that resonates with you--no pressure to use your own photo if you're not comfortable.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tap on your username to edit--just erase and type a new one, and you're all set! Your username can be anything you like--it doesn't have to be your real name. However, using your own name would be great!",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Once you're happy with your changes, tap the Save button in the top right corner to update your profile!",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Verified Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildInfoRow('Name', currentUser?.name ?? ''),
                      const Divider(),
                      _buildInfoRow('Gender', 'Female'),
                      const Divider(),
                      _buildInfoRow('Specialisation', 'Hand embroidery'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your name, gender, and specialisation were verified during the video call onboarding and can\'t be changed after setting up your account. If you have any questions about this, feel free to write or record a message and reach out to us through the Contact section--we\'re here to help!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
