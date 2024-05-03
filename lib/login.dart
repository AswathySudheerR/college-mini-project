import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
//import 'package:firebase_core/firebase_core.dart';



class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Check the authentication status
            if (snapshot.hasData) {
              // User is signed in
              return HomePage();
            } else {
              // User is not signed in
              return AuthPage();
            }
          }
          // Show a loading indicator while waiting for authentication to complete
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
