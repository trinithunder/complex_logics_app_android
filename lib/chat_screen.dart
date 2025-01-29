import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class ChatScreen extends StatefulWidget {
  final int chatId;
  final String wsUrl;

  ChatScreen({required this.chatId, required this.wsUrl});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late WebSocketChannel channel;
  List<Map<String, dynamic>> messages = [];
  final TextEditingController messageController = TextEditingController();
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('${widget.wsUrl}/cable');

    // Send subscription message to Rails ActionCable
    channel.sink.add(json.encode({
      "command": "subscribe",
      "identifier": json.encode({"channel": "ChatChannel", "chat_id": widget.chatId}),
    }));

    channel.stream.listen((data) {
      final response = json.decode(data);

      if (response["message"] != null) {
        setState(() => messages.add(response["message"]));
      }
    });
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      channel.sink.add(json.encode({
        "command": "message",
        "identifier": json.encode({"channel": "ChatChannel", "chat_id": widget.chatId}),
        "data": json.encode({"content": messageController.text}),
      }));

      setState(() => messageController.clear());
    }
  }

  void sendTyping() {
    channel.sink.add(json.encode({
      "command": "message",
      "identifier": json.encode({"channel": "ChatChannel", "chat_id": widget.chatId}),
      "data": json.encode({"typing": true}),
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Messages")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return MessageBubble(
                  text: message["content"],
                  isMe: message["user_id"] == 1,  // Replace with current user ID
                  avatarUrl: message["avatar_url"],
                );
              },
            ),
          ),
          if (isTyping) Text("User is typing...", style: TextStyle(color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (text) {
                      if (!isTyping) {
                        setState(() => isTyping = true);
                        sendTyping();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String? avatarUrl;

  MessageBubble({required this.text, required this.isMe, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe && avatarUrl != null) CircleAvatar(backgroundImage: NetworkImage(avatarUrl!)),
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
