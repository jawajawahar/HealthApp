import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'Colors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isEditing = false;
  bool emailError = false;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        nameController.text = user.displayName ?? '';
        emailController.text = user.email ?? '';
        profileImageUrl = user.photoURL;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await user.updateProfile(displayName: nameController.text, photoURL: profileImageUrl);
        await user.updateEmail(emailController.text);
        await user.reload();
        user = _auth.currentUser;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );

        setState(() {
          isEditing = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      try {
        TaskSnapshot snapshot = await _storage.ref().child('profile_images/$fileName').putFile(imageFile);
        String downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          profileImageUrl = downloadUrl;
        });

        User? user = _auth.currentUser;
        if (user != null) {
          await user.updateProfile(photoURL: downloadUrl);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbar,
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: appname,
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : AssetImage('assets/a.png') as ImageProvider,
                  child: profileImageUrl == null
                      ? Icon(Icons.camera_alt, color: Colors.white, size: 30)
                      : null,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: nameController,
                labelText: 'Username',
                icon: Icons.person,
                isEnabled: isEditing,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: emailController,
                labelText: 'Email',
                icon: Icons.email,
                isEnabled: isEditing,
                errorText: emailError ? 'Invalid email: Missing "@" symbol' : null,
                onChanged: (value) {
                  setState(() {
                    emailError = !value.contains('@');
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildElevatedButton('Edit', () {
                    setState(() {
                      isEditing = true;
                    });
                  }),
                  _buildElevatedButton('Save', () async {
                    if (!emailError) {
                      await _updateUserProfile();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cannot save: Invalid email address')),
                      );
                    }
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool isEnabled = true,
    String? errorText,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: appbar, fontWeight: FontWeight.bold),
        errorText: errorText,
        filled: true,
        fillColor: Colors.grey[200],
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.5),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal[900]!, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        prefixIcon: Icon(icon, color: Colors.teal[900]),
      ),
      style: TextStyle(color: Colors.black),
      enabled: isEnabled,
      onChanged: onChanged,
    );
  }

  Widget _buildElevatedButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal[900],
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
