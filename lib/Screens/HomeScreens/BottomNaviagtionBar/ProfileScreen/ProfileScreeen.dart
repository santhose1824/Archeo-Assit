import 'dart:convert';
import 'dart:io';

import 'package:archeoassist/Color.dart';
import 'package:archeoassist/Database/DatabaseFunctions.dart';
import 'package:archeoassist/Screens/Auth/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  String? base64Image;
  String? userName = '';
  String? userEmail = '';
  String? userImageBase64;
  DatabaseFunctions _databaseFunctions = DatabaseFunctions();

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _databaseFunctions.getUserDataAndUpdateState(user.uid, _updateState);
    }
  }

  void _updateState(String? name, String? email, String? imageUrl) {
    setState(() {
      userName = name;
      userEmail = email;
      userImageBase64 = imageUrl;
    });
  }

  void logout() async {
    await _databaseFunctions.signOut();

    // Navigate to the LoginScreen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Convert image to base64
      List<int> imageBytes = await _image!.readAsBytes();
      base64Image = base64Encode(imageBytes);

      // Now you can use base64Image as needed
      print('Base64 Image: $base64Image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.primaryBackgroundColor,
        body: Padding(
          padding: EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      foregroundImage: userImageBase64 != null
                          ? MemoryImage(base64Decode(userImageBase64!))
                          : AssetImage('lib/assets/profile-logo.jpg') as ImageProvider<Object>,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Color.fromARGB(229, 7, 160, 89),
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          onPressed: _getImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: ColorManager.AppTextColor,
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.AppTextColor.withOpacity(0.2),
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 3.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'Name :',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        userName ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: ColorManager.AppTextColor,
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.AppTextColor.withOpacity(0.2),
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 3.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'Email :',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        userEmail ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  logout();
                },
                child: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF112A46),
                  onPrimary: ColorManager.primaryTextColor,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(370, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
