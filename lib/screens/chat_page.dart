import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../chat/chat_service.dart';
import '../helper/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  final String receiverUserEmail;
  final String receiverUserID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final userCredential = FirebaseAuth.instance.currentUser;

  //Method
  void sendMessage() async {
    //only send message if there is something
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(
          widget.receiverUserID, messageController.text);

      // clear the text controller after sending the message
      messageController.clear();
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        centerTitle: true,
          backgroundColor: Colors.deepPurple.shade200,
          title: Text(widget.receiverUserEmail)
      ),
      body: Column(
        children: [
          // message
          Expanded(
            child: buildMessageList(),
          ),

          // user input
          buildMessageInput(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // build message list
  Widget buildMessageList() {
    return StreamBuilder(
        stream:
            chatService.getMessage(widget.receiverUserID, userCredential!.uid),
        builder: (context, snapshot) {
          // error check
          if (snapshot.hasError) {
            return Text('Error${snapshot.error}');
          }

          // if it's loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          return ListView(
            reverse: true,
            children: snapshot.data!.docs
                .map((document) => buildMessageItem(document))
                .toList(),
          );
        });
  }

  // build message item
  Widget buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the message to the right if the sender is the current user, o/w to the left
    var alignment = (data['senderId'] == userCredential!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: (data['senderId'] == userCredential!.uid)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment: (data['senderId'] == userCredential!.uid)
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Text(data['senderEmail'], style: const TextStyle(fontSize: 10),),
              const SizedBox(height: 5),
              ChatBubble(message: data['message']),
            ],
          ),
        ));
  }

  // build message input
  Widget buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // textfield
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(158, 158, 158, 1),
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(158, 158, 158, 1),
                    )),
                hintText: 'Message',
              ),
              controller: messageController,
              cursorColor: Colors.grey.shade500,
              
            ),
          ),

          // send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_circle_right,
              color: Color.fromRGBO(179, 157, 219, 1),
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
