import 'package:archeoassist/Color.dart';
import 'package:flutter/material.dart';

class GroupChatWidget extends StatefulWidget {
  final List<Groups> users;
  const GroupChatWidget({super.key,required this.users});

  @override
  State<GroupChatWidget> createState() => _GroupChatWidgetState();
}

class _GroupChatWidgetState extends State<GroupChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.separated(
        itemCount: widget.users.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 8); // Adjust the height as needed
        },
        itemBuilder: (BuildContext context, int index) {
          return buildChatItem(widget.users[index]);
        },
      ),
    );
  }

  Widget buildChatItem(Groups user) {
    return Container(
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
          ), //BoxShadow
        ],
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
                  child: Icon(
                    Icons.person,
                    // You can replace the default icon with the user's image
                  ),
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


class Groups {
  final String userName;
  // Add more user properties as needed

  Groups({required this.userName});
}