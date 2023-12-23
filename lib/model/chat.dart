// class for message
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat{
  Chat({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;


  // convert to map bcz that's how data store in firebase
  Map<String, dynamic> toMap(){
    return{
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  } 
}
