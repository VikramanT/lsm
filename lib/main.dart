import 'package:app/pages/transfer_acc_to_wallet.dart';
import 'package:app/pages/transfer_wallet_to_acccount.dart';
import 'package:app/pages/welcomePage.dart';
import 'package:app/utilities/direct_login.dart';
import 'package:app/utilities/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';

Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(withdraw());
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
                    nextScreen: Login(),
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
