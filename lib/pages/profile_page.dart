import 'dart:io';

import 'package:aetram_task/models/user_model.dart';
import 'package:aetram_task/services/fetchprofie_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path; // Add this line

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;
  final _picker = ImagePicker();
  // Create an instance of the UserService to fetch data
  final UserService _userService = UserService();
  
  // State variables to hold the user data and loading status
  User? _user;
  bool _isLoading = true;

  // Controllers for the TextFields to display the user data
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _websiteController;

  // Load the image path from SharedPreferences and display the image
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _websiteController = TextEditingController();
    _fetchUser();
    _loadProfileImage(); // Call this method to load the saved image on start
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    super.dispose();
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
        // Handle case where user data is not found
        print('User not found.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Failed to load user: $e');
    }
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
                                onPressed: () {},
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                              ),
                              const Text("Profile", style: TextStyle(color: Colors.amber)),
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.edit, color: Colors.white),
                                label: const Text(
                                  "Edit",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
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
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                    onPressed: _pickAndSaveImage,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.black,
                              border: Border.all(style: BorderStyle.solid),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
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
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),
                              TextFormField(
                                controller: _phoneController,
                                decoration: const InputDecoration(
                                  labelText: 'Phone',
                                  prefixIcon: Icon(Icons.phone),
                                ),
                              ),
                              TextFormField(
                                controller: _websiteController,
                                decoration: const InputDecoration(
                                  labelText: 'Website',
                                  prefixIcon: Icon(Icons.link),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.notifications),
                                ),
                                title: const Text("Notification"),
                                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                              ),
                              ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.language),
                                ),
                                title: const Text("Language"),
                                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                              ),
                              ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.verified_user),
                                ),
                                title: const Text("Security"),
                                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                              ),
                              ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person_add_alt_1),
                                ),
                                title: const Text("Referal Invite"),
                                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                              ),
                              ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.document_scanner),
                                ),
                                title: const Text("Legal Documents"),
                                trailing: const Icon(Icons.arrow_forward_ios_outlined),
                              ),
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
}