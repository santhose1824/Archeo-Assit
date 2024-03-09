import 'dart:io';
import 'package:archeoassist/Color.dart';
import 'package:archeoassist/Database/DatabaseFunctions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  File? _image;
  TextEditingController commentController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadPost() async {
    try {
      User? user = _auth.currentUser;
      String? userName;
      String? profileImage;
      // Query the 'users' collection to get the userName based on the user's email
      DatabaseFunctions databaseFunctions = DatabaseFunctions();
      Map<String, dynamic>? userData =
          await databaseFunctions.getUserData(user!.uid);
      userName = userData?['name'] ?? 'Unknown User';
      profileImage = userData?['imageUrl']??'';
      String postId = _firestore.collection('posts').doc().id;
      print(userName);
      print(user.email);

      Reference storageReference = _storage.ref().child('images/$postId');
      UploadTask uploadTask = storageReference.putFile(_image!);
      await uploadTask;

      // Get the download URL of the uploaded image
      String imageURL = await storageReference.getDownloadURL();

      Map<String, dynamic> postData = {
        'postId': postId,
        'caption': commentController.text,
        'username': userName ?? user.displayName,
        'userEmail': user.email,
        'imageUrl': imageURL,
        'profileImage':profileImage // Add imageURL to the postData
      };

      await _firestore.collection('posts').doc(postId).set(postData);

      // Clear the image and text controller
      setState(() {
        _image = null;
        commentController.clear();
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post uploaded successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      print('Post uploaded successfully!');
    } catch (e) {
      print('Error uploading post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.primaryBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Your Post',
                  style: TextStyle(
                    color: ColorManager.AppTextColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Center(
                          child: Container(
                            height: 200,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: ColorManager.AppTextColor,
                            ),
                            child: _image != null
                                ? Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: ColorManager.AppTextColor,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  ColorManager.AppTextColor!.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Center(
                            child: TextField(
                              controller: commentController,
                              maxLines: 4,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.comment, color: Colors.white),
                                hintText: 'Leave a Comment',
                                hintStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await _uploadPost();
                        },
                        child: Text('Post'),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF112A46),
                          onPrimary: Colors.white,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
