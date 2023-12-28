import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DialogPage extends StatelessWidget {
  const DialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        backgroundColor: Colors.deepPurple.shade200,
        title: const Text(
          'Confirm Sign-Out',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        // buttons
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white),
              foregroundColor: MaterialStatePropertyAll(Colors.deepPurple),
            ),
            child:const Text('No', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white),
              foregroundColor: MaterialStatePropertyAll(Colors.deepPurple)
            ),
            child: const Text('Yes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}