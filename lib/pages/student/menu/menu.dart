import 'package:app/pages/student/homepage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentHomePage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 90,
                    ),
                    Text("Menu",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600))),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(height: 20.0),
                Container(
                  //padding: const

                  //EdgeInsets.all(16.0),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(8.0),
                  //   border: Border.all(color: Colors.grey),
                  // ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/arrow_right.png',
                              width: 80, height: 80),
                          const SizedBox(width: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Text(' send Money',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Color(0xff213452),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/arrow_right.png',
                              width: 80, height: 80),
                          const SizedBox(width: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Text(' Top-up',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Color(0xff213452),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/arrow_right.png',
                              width: 100, height: 100),
                          const SizedBox(width: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Text(' withdraw',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Color(0xff213452),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/arrow_right.png',
                              width: 100, height: 100),
                          const SizedBox(width: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Text(' History Transactions',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Color(0xff213452),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/arrow_right.png',
                              width: 100, height: 100),
                          const SizedBox(width: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Text(' profile',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Color(0xff213452),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/arrow_right.png',
                              width: 100, height: 100),
                          const SizedBox(width: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Text(' change password',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Color(0xff213452),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/arrow_right.png',
                              width: 100, height: 100),
                          const SizedBox(width: 8.0),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Text(' Logout',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Color(0xff213452),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
