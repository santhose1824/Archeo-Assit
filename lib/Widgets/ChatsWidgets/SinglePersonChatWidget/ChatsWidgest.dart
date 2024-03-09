import 'dart:convert';
import 'package:archeoassist/Color.dart';
import 'package:flutter/material.dart';

class ChatsWidget extends StatefulWidget {
  final List<ChatUser> users;
  final void Function(ChatUser user) onUserPressed;

  const ChatsWidget(
      {Key? key, required this.users, required this.onUserPressed})
      : super(key: key);

  @override
  State<ChatsWidget> createState() => _ChatsWidgetState();
}

class _ChatsWidgetState extends State<ChatsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.separated(
        itemCount: widget.users.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 8);
        },
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              widget.onUserPressed(widget.users[index]);
            },
            child: buildChatItem(widget.users[index]),
          );
        },
      ),
    );
  }

  Widget buildChatItem(ChatUser user) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: ColorManager.AppTextColor, // Change to your desired color
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  backgroundImage: MemoryImage(base64Decode(user.imageUrl)),
                ),
                SizedBox(width: 10),
                Text(
                  user.userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChatUser {
  final String userId;
  final String userName;
  final String imageUrl;

  ChatUser({required this.userId, required this.userName, required this.imageUrl});
}
