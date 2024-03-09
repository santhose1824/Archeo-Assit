import 'dart:convert';
import 'dart:io';
import 'package:archeoassist/Color.dart';
import 'package:archeoassist/Widgets/ChatsWidgets/SinglePersonChatWidget/ChatsWidgest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  final String? userId;

  const ChatScreen({Key? key, required this.user, required this.userId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();

  void _sendMessage(String message) {
    CollectionReference messages = FirebaseFirestore.instance.collection('messages');

    messages.add({
      'senderId': widget.userId,
      'receiverId': widget.user.userId,
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _messageController.clear();
  }

  Future<void> _capturePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      print('Sending Picture: ${pickedFile.path}');
    }
  }

  Future<void> _sendDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      print('Sending Document: ${file.path}');
    }
  }

Widget _buildMessages(List<Message> messages) {
  return ListView.builder(
    itemCount: messages.length,
    itemBuilder: (context, index) {
      Message message = messages[index];
      bool isCurrentUser = message.senderId == widget.userId;

      return Padding(
        padding: EdgeInsets.only(left: isCurrentUser ? 100 : 0, right: isCurrentUser ? 0 : 100),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 200, // Set your maximum width
            ),
            alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.white : ColorManager.AppTextColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.black : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(message.timestamp.toDate()),
                  style: TextStyle(fontSize: 12, color: isCurrentUser ? Colors.black : Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}





  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.primaryBackgroundColor, // Change to your desired background color
        body: Column(
          children: [
            Container(
              color: ColorManager.AppTextColor, // Change to your desired color
              height: 70,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: widget.user.imageUrl != null
                          ? MemoryImage(base64Decode(widget.user.imageUrl!))
                          : AssetImage('path_to_placeholder_image') as ImageProvider,
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.user.userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .orderBy('timestamp')
                      .where(
                        '(senderId == ${widget.userId} && receiverId == ${widget.user.userId}) OR (senderId == ${widget.user.userId} && receiverId == ${widget.userId})',
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    List<Message> messages = snapshot.data!.docs
                        .map((doc) => Message.fromFirestore(doc))
                        .toList();

                    return _buildMessages(messages);
                  },
                ),

            ),
            Container(
              height: 70,
              color: ColorManager.AppTextColor, // Change to your desired color
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: _messageController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                _sendMessage(_messageController.text);
                              },
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: _capturePicture,
                      color: Colors.white,
                    ),
                    IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: _sendDocument,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
  Map data = doc.data() as Map;
  return Message(
    senderId: data['senderId'] ?? '',
    receiverId: data['receiverId'] ?? '',
    text: data['text'] ?? '',
    timestamp: data['timestamp'] ?? Timestamp.now(),
  );
}

  }
