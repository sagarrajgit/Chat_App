import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;

    return IntrinsicWidth(
      child: FractionallySizedBox(
        widthFactor: 1.0,
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth*0.6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade400,
          ),
          child: Text(
            message,
            softWrap: true,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
