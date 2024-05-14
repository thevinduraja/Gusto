import 'package:firebase_auth/firebase_auth.dart';
import 'package:gusto/auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final User? user = Auth().currentUser;

  List<String> buttonNames = [
    'Profile',
    'Favorites',
    'Privacy',
    'Feedback',
    'Notifications',
    'Logout',
  ];

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget buildButton(String buttonName) {
    return ElevatedButton(
      onPressed: () {
        if (buttonName == 'Profile') {
          null;
        } else if (buttonName == 'Favorites') {
          null;
        } else if (buttonName == 'Privacy') {
          null;
        } else if (buttonName == 'Feedback') {
          null;
        } else if (buttonName == 'Notifications') {
          null;
        } else if (buttonName == 'Logout') {
          signOut();
        }
      },
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: const Color(0xFFFDC36D),
          fixedSize: const Size(160, 130)
      ),
      child: Text(
        buttonName,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE9C8),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          const CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage("assets/user.jpg")
          ),
          const SizedBox(height: 20),
          Text(
            user?.email ?? "User",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  buildButton("Profile"),
                  const SizedBox(height: 20),
                  buildButton("Privacy"),
                  const SizedBox(height: 20),
                  buildButton("Notifications"),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  buildButton("Favorites"),
                  const SizedBox(height: 20),
                  buildButton("Feedback"),
                  const SizedBox(height: 20),
                  buildButton("Logout"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
