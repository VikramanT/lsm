import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

void addUserDetails(privateKey, publicKey) async {
  var userInstance = FirebaseAuth.instance.currentUser;
  List<String> parts = userInstance!.displayName!.split(' ');
  String name = parts.sublist(0, parts.length - 1).join(' ');
  String registrationNumber = parts.last;

  await FirebaseFirestore.instance
      .collection("users")
      .doc(userInstance.uid)
      .set({
    'user_name': name,
    'email': userInstance.email,
    'reg_no': registrationNumber,
    'createdAt': DateTime.now().toString(),
    'platform': Platform.operatingSystem,
    'privateKey': privateKey.toString(),
    'publicKey': publicKey.toString(),
    'wallet_created': true
  }).whenComplete(() {
    if (kDebugMode) {
      print("User data added");
    }
  }).catchError((error) {
    if (kDebugMode) {
      print("Failed to add user: $error");
    }
  });
}

Future<dynamic> getUserDetails() async {
  dynamic data;
  var userInstance = FirebaseAuth.instance.currentUser;
  final DocumentReference document =
      FirebaseFirestore.instance.collection("users").doc(userInstance!.uid);
  await document.get().then<dynamic>((DocumentSnapshot snapshot) {
    data = snapshot.data();
  });
  return data;
}
