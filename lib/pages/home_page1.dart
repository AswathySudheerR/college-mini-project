import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart'; // Ensure you import FirebaseAuth

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //final user = FirebaseAuth.instance.currentUser; // Get the current user

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the signed-in user's email
            Text('Signed in'),
            //Text('Signed in as: ${user?.email ?? "No email available"}'),
            MaterialButton(onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            color: Colors.purple,
            child: Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }
}
