import 'package:app/utilities/direct_login.dart';
import 'package:app/utilities/sign_in_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';

class TransactionModel {
  final String response;
  final int amount;
  final String type;
  final String description;
  final DateTime dateTime;

  TransactionModel(
      {required this.response,
      required this.amount,
      required this.type,
      required this.description,
      required this.dateTime});
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TransactionModelProvider(),
      child: MyApp(),
    ),
  );
}

class TransactionModelProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<TransactionModel> _transactionHistory = [];
  List<TransactionModel> get transactionHistory => _transactionHistory;

  Future<void> loadTransactionHistory() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      String uid = auth.currentUser!.uid;
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('transactions')
          .where('user_uid', isEqualTo: uid)
          .get();

      _transactionHistory = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return TransactionModel(
          response: data['response'],
          amount: data['amount'] is int
              ? data['amount']
              : (data['amount'] as num).toInt(),
          type: data['type'],
          description: data['description'],
          dateTime: (data['dateTime'] as Timestamp).toDate(),
        );
      }).toList();

      notifyListeners();
    } catch (error) {
      print('Error loading transaction history: $error');
    }
  }

  Future<void> _saveTransaction(TransactionModel transaction) async {
    try {
      await _firestore.collection('transactions').add({
        'response': transaction.response,
        'amount': transaction.amount,
        'type': transaction.type,
        'description': transaction.description,
        'dateTime': transaction.dateTime,
        'user_uid': FirebaseAuth.instance.currentUser!.uid,
      });
    } catch (error) {
      print('Error saving transaction: $error');
    }
  }

  void addTransaction(TransactionModel transaction) {
    _transactionHistory.add(transaction);
    _saveTransaction(transaction);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbapp = Firebase.initializeApp();

  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Raleway'),
            home: FutureBuilder(
              future: _fbapp,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('You Have an error! ${snapshot.error.toString()}');
                  return const Text('Something Went Wrong!');
                } else if (snapshot.hasData) {
                  return AnimatedSplashScreen(
                    splash: 'assets/images/logo.png',
                    pageTransitionType: PageTransitionType.bottomToTop,
                    duration: 3000,
                    // nextScreen: MyHomePage(
                    //   title: 0,
                    // ),
                    nextScreen: const Login(),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
            // AnimatedSplashScreen(splash: 'assyets/images/logo2.gif',
            //   pageTransitionType: PageTransitionType.bottomToTop,
            //   duration: 3000,
            //   nextScreen: MyHomePage(),
            // )
            ));
  }
}
