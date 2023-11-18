import 'package:app/pages/LoginPage.dart';
import 'package:app/pages/welcomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return const MyHomePage(
              title: 0,
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something Went wrong!"),
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
