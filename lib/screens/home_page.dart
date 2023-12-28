import 'package:assignment_app/helper/dialog_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userCredential = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.deepPurple.shade200,

        // user name(email)
        title: Text(userCredential!.email!),

        // Log out button
        actions: [
          InkWell(
              onTap: () {
                showDialog(
                  context: context, 
                  builder: (context) => const DialogPage()
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Icon(Icons.logout_rounded),
              ))
        ],
      ),
      body: buildUserList(),
    );
  }

  // build a list of users
  Widget buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading...'));
          }
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => buildUserListItem(doc))
                .toList(),
          );
        });
  }

  // build individual user list items
  Widget buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // display all user except current user
    if (userCredential!.email != data['email']) {
      return Column(
        children: [
          ListTile(
            title: Text(
              data['email'],
              style: const TextStyle(
                  fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
            ),
            onTap: () {
              // pass the clicked user's UID to that page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverUserEmail: data['email'],
                    receiverUserID: data['uid'],
                  ),
                ),
              );
            },
          ),
          const Divider(color: Color.fromRGBO(179, 157, 219, 1), height: 0),
        ],
      );
    }

    //return empty container
    else {
      return Container();
    }
  }
}
