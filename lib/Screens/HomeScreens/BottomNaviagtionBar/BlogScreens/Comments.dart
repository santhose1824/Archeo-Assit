import 'dart:convert';

import 'package:archeoassist/Color.dart';
import 'package:archeoassist/Database/DatabaseFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  final String caption;
  final String username;
  final String imageUrl;
  final String profileImage;

  CommentScreen({
    required this.postId,
    required this.caption,
    required this.username,
    required this.imageUrl,
    required this.profileImage,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();
   List<Map<String, dynamic>> comments = []; 
     final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.primaryBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: ColorManager.AppTextColor,
                          backgroundImage: MemoryImage(
                            base64Decode(widget.profileImage),
                          ),
                        ),
                        title: Text(widget.username),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.black,
                          ),
                        ),
                        child: Container(
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.caption,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: comments.map((comment) {
                    return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: MemoryImage(
                            base64Decode(comment['profileImage']),
                          ),
                        ),
                        title: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorManager.AppTextColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(comment['username'],style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold,),),
                            ),
                              SizedBox(height: 4), // Adjust the spacing between username and comment
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(comment['comment'],style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold,)),
                              ),
                            ],
                          ),
                        ),
                      );

                  }).toList(),
                ),
                SizedBox(height: 20),
                 Container(
                decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ColorManager.AppTextColor,
                          ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ColorManager.AppTextColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: commentController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Type your message...',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                    addComment();
                                  },
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                 )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addComment() async{
    String userName;
    String profileImage;
    User? user = _auth.currentUser;
    String commentText = commentController.text.trim();
    DatabaseFunctions databaseFunctions = DatabaseFunctions();
      Map<String, dynamic>? userData =
          await databaseFunctions.getUserData(user!.uid);
      userName = userData?['name'] ?? 'Unknown User';
      profileImage = userData?['imageUrl']??'';
    if (commentText.isNotEmpty) {
      FirebaseFirestore.instance.collection('comments').add({
        'postId': widget.postId,
        'username': userName,
        'comment': commentText,
        'profileImage': profileImage,
      });

      commentController.clear();
      getComments();
    }
  }

  void getComments() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('comments')
        .where('postId', isEqualTo: widget.postId)
        .get();

    setState(() {
      comments = querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getComments();
  }
}
