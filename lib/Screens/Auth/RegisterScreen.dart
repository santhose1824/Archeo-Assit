import 'dart:convert';
import 'dart:io';

import 'package:archeoassist/Color.dart';
import 'package:archeoassist/Database/DatabaseFunctions.dart';
import 'package:archeoassist/Screens/Auth/LoginScreen.dart';
import 'package:archeoassist/Widgets/AuthWidgets/AuthTextFeilds.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScree extends StatefulWidget {
  const RegisterScree({super.key});

  @override
  State<RegisterScree> createState() => _RegisterScreeState();
}

class _RegisterScreeState extends State<RegisterScree> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DatabaseFunctions _databaseFunctions = DatabaseFunctions(); 
  File? _image;
  String? base64Image;
  void register() async {
    if (_image != null) {
      // Convert image to base64
      List<int> imageBytes = await _image!.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    // Register user with email and password
    User? user = await _databaseFunctions.registerWithEmailAndPassword(
        emailController.text, passwordController.text);

    if (user != null) {
      // Add user data to Firestore
      await _databaseFunctions.addUserToFirestore(user.uid, emailController.text, base64Image ?? '',nameController.text);

      // Navigate to HomeScreen or perform other actions
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
  Future _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

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
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Archeo-Assist',
                        style: TextStyle(
                            color: ColorManager.HeadingsColors,
                            fontSize: 50,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                   Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 70,
                                foregroundImage: _image != null
                                    ? FileImage(_image!)
                                    : AssetImage('lib/assets/profile-logo.jpg')
                                        as ImageProvider<Object>,
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
                      height: 15,
                    ),
                    AuthFeilds(
                      controller: nameController,
                      hint: 'Enter your Name',
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      obsecureText: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AuthFeilds(
                      controller: emailController,
                      hint: 'Enter your Email',
                      icon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      obsecureText: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AuthFeilds(
                      controller: passwordController,
                      hint: 'Enter your Password',
                      icon: Icon(
                        Icons.key,
                        color: Colors.white,
                      ),
                      obsecureText: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        register();
                      },
                      child: Text('Register'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF112A46),
                        onPrimary: ColorManager.primaryTextColor,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // BorderRadius
                        ),
                        minimumSize: Size(370, 50),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'or Continue with',
                      style: TextStyle(
                          color: ColorManager.HeadingsColors,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 50,
                          width: 370,
                          decoration: BoxDecoration(
                              color: ColorManager.AppTextColor,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      ColorManager.AppTextColor.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 90),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'lib/assets/g-logo.png',
                                  height: 20,
                                  width: 25,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    'Sign In with Google ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already Have an Account?',
                          style: TextStyle(
                            color: ColorManager.HeadingsColors,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                 .push(MaterialPageRoute(builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: ColorManager.AppTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}
