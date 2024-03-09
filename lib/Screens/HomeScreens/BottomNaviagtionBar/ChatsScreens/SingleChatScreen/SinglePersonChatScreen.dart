import 'package:archeoassist/Color.dart';
import 'package:archeoassist/Screens/HomeScreens/BottomNaviagtionBar/ChatsScreens/SingleChatScreen/ChatScreen.dart';
import 'package:archeoassist/Widgets/ChatsWidgets/SinglePersonChatWidget/ChatsWidgest.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SinglePersonChatScreen extends StatefulWidget {
  final userId;

  SinglePersonChatScreen({required this.userId});

  @override
  _SinglePersonChatScreenState createState() => _SinglePersonChatScreenState();
}

class _SinglePersonChatScreenState extends State<SinglePersonChatScreen> {
  User? currentUser;
  List<ChatUser> users = [];

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      setState(() {
        currentUser = user;
      });

      // Fetch all users from Firestore and filter out the current user
      await fetchAllUsers(user.uid);
    }
  }

  Future<void> fetchAllUsers(String currentUserId) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<ChatUser> allUsers = querySnapshot.docs
        .where(
            (document) => document.id != currentUserId) // Exclude current user
        .map((document) {
      String userId = document.id;
      String userName = document['name'];
      String imageUrl = document['imageUrl'];
      return ChatUser(
        userId: userId,
        userName: userName,
        imageUrl: imageUrl,
      );
    }).toList();

    setState(() {
      users.addAll(allUsers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.primaryBackgroundColor, // Change to your desired background color
        body: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.settings,
                    size: 50,
                    color: ColorManager.GridColor,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chats',
                    style: TextStyle(
                      color: ColorManager.AppTextColor,
                      fontSize: 30,
                    ),
                  ),
                  Icon(Icons.chat_rounded, color: ColorManager.AppTextColor)
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: ChatsWidget(
                  users: users,
                  onUserPressed: (ChatUser user) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        user: user,
                        userId: currentUser!.uid,
                      ),
                    ));
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
