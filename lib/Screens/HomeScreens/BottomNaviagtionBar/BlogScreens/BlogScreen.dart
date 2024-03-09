import 'package:archeoassist/Color.dart';
import 'package:archeoassist/Screens/HomeScreens/BottomNaviagtionBar/BlogScreens/Comments.dart';
import 'package:archeoassist/Screens/HomeScreens/BottomNaviagtionBar/BlogScreens/CreateBlog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class BlogScreen extends StatefulWidget {
  final userId;

  BlogScreen({required this.userId});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  TextEditingController searchController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    // Call the method to retrieve posts when the widget is created
    _getPosts();
  }

  Future<void> _getPosts() async {
    try {
      User? user = _auth.currentUser;

      // Retrieve posts from Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('posts').get();

      // Convert the Firestore data to a list of Post objects
      List<Post> retrievedPosts = querySnapshot.docs.map((doc) {
        Map<String, dynamic> postData = doc.data()!;
        return Post(
          postId: postData['postId'],
          caption: postData['caption'],
          username: postData['username'],
          userEmail: postData['userEmail'],
          imageUrl: postData['imageUrl'],
          profileImage: postData['profileImage'],
        );
      }).toList();

      // Update the state with the retrieved posts
      setState(() {
        posts = retrievedPosts;
      });
    } catch (e) {
      print('Error retrieving posts: $e');
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
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () async {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CreateBlog()));
                  },
                  icon: Icon(
                    Icons.post_add,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: ColorManager.GridColor,
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.GridColor.withOpacity(0.2),
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
                      controller: searchController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Display the retrieved posts using ListView.builder
              Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    Post post = posts[index];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          ListTile(
                           leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: ColorManager.AppTextColor,
                                backgroundImage: MemoryImage(
                                  base64Decode(post.profileImage),
                                ),
                              ),


                            title: Text(post.username),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.comment,
                                color: ColorManager.AppTextColor,
                              ),
                              onPressed: () {
                                // Handle comment button pressed
                                Navigator.of(context).push(
                                   MaterialPageRoute(builder: (context) => CommentScreen(
                                    username:post.username ,
                                    profileImage: post.profileImage,
                                    postId: post.postId,
                                    imageUrl: post.imageUrl,
                                    caption: post.caption,
                                   )));
                              },
                            ),
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
                                post.imageUrl,
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
                              post.caption,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Post {
  final String postId;
  final String caption;
  final String username;
  final String userEmail;
  final String imageUrl;
  final String profileImage;

  Post({
    required this.postId,
    required this.caption,
    required this.username,
    required this.userEmail,
    required this.imageUrl,
    required this.profileImage,
  });
}
