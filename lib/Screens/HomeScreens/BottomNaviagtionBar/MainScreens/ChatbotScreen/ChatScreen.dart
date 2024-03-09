import 'dart:convert';
import 'package:archeoassist/Color.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  TextEditingController _messageController = TextEditingController();
  List<ChatMessage> chatMessages = [];

  // Function to handle sending a text message
  void _sendMessage(String message) async {
  // Make a request to your Flask API
  final response = await http.post(
    Uri.parse('http://192.168.43.66:5000/process_message'),
 // Replace with your Flask API endpoint
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({'message': message}),
  );

  if (response.statusCode == 200) {
    // Parse the response and add it to the chat immediately after the user's message
    final responseData = json.decode(response.body);
    final botResponse = responseData['response']; // Replace with your actual response field name
    setState(() {
      chatMessages.insert(0, ChatMessage(message, true)); 
      chatMessages.insert(0, ChatMessage(botResponse, false)); // Insert at the beginning of the list
      // Insert the user's message
    });
  } else {
    // Handle error
    print('Failed to send message. Error ${response.statusCode}: ${response.body}');
  }

  // Clear the message input field
  _messageController.clear();
}



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.primaryBackgroundColor,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  reverse: true, // Reverse the list to show new messages at the bottom
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(chatMessages[index]);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                height: 70,
                color: ColorManager.GridColor,
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
                                    controller: _messageController,
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
                                    _sendMessage(_messageController.text);
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage(this.text, this.isUser);
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  ChatBubble(this.message);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: message.isUser ? ColorManager.AppTextColor : Colors.white,
        ),
        child: Text(
          textAlign: TextAlign.justify,
          message.text,
          style: TextStyle(
            color: message.isUser? Colors.white:Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
