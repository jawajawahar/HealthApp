import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/AboutUS.dart';
import 'package:untitled1/Colors.dart';
import 'package:untitled1/Other%20features.dart';
import 'package:untitled1/profile.dart';
import 'package:untitled1/setting.dart';
import 'package:untitled1/login.dart';
import 'ContactUs.dart';
import 'authservice.dart';
import 'reminder.dart';
import 'alarm/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  int _currentIndex = 0;
  String? userName;
  String? userEmail;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userName = user.displayName ?? 'No Name';
        userEmail = user.email ?? 'No Email';
        profileImageUrl = user.photoURL;
      });

      if (user.displayName == null || user.photoURL == null) {

        _showWelcomeDialog();
      }
    }
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Hello, $userName 👋',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23,color:appname),
          ),
          content: Text(
            'Welcome to Health Expert! 🎉\n\n'
                'We are glad to have you here! Take a moment to explore our features and get started on your health journey. 🚀',
            style: TextStyle(fontSize: 18, color:Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      try {

        TaskSnapshot snapshot = await _storage.ref().child('profile_images/$fileName').putFile(imageFile);
        String downloadUrl = await snapshot.ref.getDownloadURL();


        User? user = _auth.currentUser;
        if (user != null) {
          await user.updateProfile(photoURL: downloadUrl);

          setState(() {
            profileImageUrl = downloadUrl;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile image updated successfully!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  void _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _navigateToProfilePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
    _getUserDetails();
  }

  void _triggerTestDialog() {
    _showWelcomeDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbar,
        title: const Text(
          'Health Expert',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: icon,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.grey[200],
                      child: profileImageUrl != null
                          ? ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/loading.gif',
                          image: profileImageUrl!,
                          fit: BoxFit.cover,
                          width: 64,
                          height: 64,
                          fadeInDuration: const Duration(milliseconds: 300),
                        ),
                      )
                          : const Icon(Icons.camera_alt, color: Colors.white, size: 30),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName ?? 'Loading...',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                  ),
                  Text(
                    userEmail ?? 'Loading...',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            _drawerItem(
              icon: Icons.person,
              text: 'Profile',
              onTap: _navigateToProfilePage,
            ),
            _drawerDivider(),
            _drawerItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () => _navigateToPage(SettingsPage()),
            ),
            _drawerDivider(),
            _drawerItem(
              icon: Icons.help,
              text: 'Help & Support',
              onTap: () => _navigateToPage(HelpSupport()),
            ),
            _drawerDivider(),
            _drawerItem(
              icon: Icons.info,
              text: 'About Us',
              onTap: () => _navigateToPage(AboutUsPage()),
            ),
            _drawerDivider(),
            _drawerItem(
              icon: Icons.logout_outlined,
              text: 'Logout',
              onTap: () async {
                await _authService.signout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LogIn()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          MyApp(),
          Other(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTapped,
        backgroundColor: Colors.white,
        selectedItemColor: icon,
        unselectedItemColor: Colors.grey[500],
        selectedFontSize: 14,
        unselectedFontSize: 12,
        iconSize: 25,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm_rounded),
            label: 'Reminder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets_rounded),
            label: 'Other Services',
          ),
        ],
      ),
    );
  }

  ListTile _drawerItem({required IconData icon, required String text, required Function() onTap}) {
    return ListTile(
      leading: Icon(icon, color: appname),
      title: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }

  Divider _drawerDivider() {
    return Divider();
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
