import 'dart:io';

import 'package:aetram_task/models/user_model.dart';
import 'package:aetram_task/services/fetchprofie_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;
  final _picker = ImagePicker();
  final UserService _userService = UserService();

  User? _user;
  bool _isLoading = true;
  bool _isEditing = false; // Add state to manage edit mode

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _websiteController = TextEditingController();
    _fetchUser();
    _loadProfileImage();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  // Load the image path from SharedPreferences
  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image_path');
    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  // Pick an image and save it locally
  Future<void> _pickAndSaveImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(pickedFile.path);
    final localImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', localImage.path);

    setState(() {
      _imageFile = localImage;
    });
  }

  // Method to fetch the user data from the API
  Future<void> _fetchUser() async {
    try {
      final user = await _userService.fetchProfile();
      if (user != null) {
        setState(() {
          _user = user;
          _nameController.text = _user!.name ?? '';
          _emailController.text = _user!.email ?? '';
          _phoneController.text = _user!.phone ?? '';
          _websiteController.text = _user!.website ?? '';
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('User not found.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Failed to load user: $e');
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF464646),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Add navigation logic to go back
                                  Navigator.pop(context); 
                                },
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                              ),
                              const Text("Profile", style: TextStyle(color: Colors.amber)),
                              TextButton.icon(
                                onPressed: _toggleEditMode,
                                icon: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.white),
                                label: Text(
                                  _isEditing ? "Save" : "Edit",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.red,
                                backgroundImage: _imageFile != null
                                    ? FileImage(_imageFile!) as ImageProvider<Object>?
                                    : null,
                                child: _imageFile == null
                                    ? const Icon(Icons.person, color: Colors.white)
                                    : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                // Corrected: Use a fixed-size container for the button
                                child: Container(
                                  width: 24, // Adjust size as needed
                                  height: 24, // Adjust size as needed
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: InkWell(
                                    onTap: _pickAndSaveImage,
                                    customBorder: const CircleBorder(),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.black,
                                        size: 16, // Adjust icon size
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Added padding for better look
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 1.0), // Changed border color for visibility
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min, // Use min size to wrap content
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 5), // Spacing between icon and text
                                Text(
                                  "Trading",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _user?.name ?? "Name Loading...",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _user?.email ?? "email@example.com",
                            style: const TextStyle(fontSize: 10, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Text(
                              "Personal Info",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                readOnly: !_isEditing, // Make read-only when not in edit mode
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                              TextFormField(
                                controller: _emailController,
                                readOnly: !_isEditing,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),
                              TextFormField(
                                controller: _phoneController,
                                readOnly: !_isEditing,
                                decoration: const InputDecoration(
                                  labelText: 'Phone',
                                  prefixIcon: Icon(Icons.phone),
                                ),
                              ),
                              TextFormField(
                                controller: _websiteController,
                                readOnly: !_isEditing,
                                decoration: const InputDecoration(
                                  labelText: 'Website',
                                  prefixIcon: Icon(Icons.link),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // You can extract these ListTiles into a separate widget for better readability
                              _buildListTile(Icons.notifications, "Notification"),
                              _buildListTile(Icons.language, "Language"),
                              _buildListTile(Icons.verified_user, "Security"),
                              _buildListTile(Icons.person_add_alt_1, "Referral Invite"),
                              _buildListTile(Icons.document_scanner, "Legal Documents"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200], // Use a lighter color for visibility
        child: Icon(icon, color: Colors.black54),
      ),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 16),
      onTap: () {
        // Add specific navigation or functionality for each list tile
      },
    );
  }
}