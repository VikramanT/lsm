import 'package:flutter/material.dart';

class PaymentSummary extends StatelessWidget {
  const PaymentSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.deepPurpleAccent,
          body: SingleChildScrollView(
            child: Card(
              color: Colors.deepPurpleAccent,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    children: [
                      Spacer(),
                      Text(
                        "Payment Summary",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Spacer()
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.maxFinite,
                      height: 150,
                      child: const Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  "Shuttle Ride",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Spacer()
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  "See you next time",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                Spacer()
                              ],
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  "Thank you 20W1o022",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                Spacer()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.maxFinite,
                      height: 250,
                      child: Card(
                        color: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                            bottomLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Row(
                              children: [
                                Spacer(),
                                Text(
                                  "Shuttle - 5",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Spacer()
                              ],
                            ),
                            const Row(
                              children: [
                                Spacer(),
                                Text(
                                  "IN 05 SP 2002",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                Spacer()
                              ],
                            ),
                            const Row(
                              children: [
                                Spacer(),
                                Text(
                                  "Nov 18, 2023 at 12:00pm",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                Spacer()
                              ],
                            ),
                            const SizedBox(
                              height: 115,
                            ),
                            Container(
                              height: 50,
                              width: double.maxFinite,
                              child: const Card(
                                color: Color.fromARGB(255, 201, 189, 235),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    //   topLeft: Radius.circular(15.0),
                                    // topRight: Radius.circular(15.0),
                                    bottomLeft: Radius.circular(25.0),
                                    bottomRight: Radius.circular(25.0),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Text(
                                      'Total',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Spacer(),
                                    Text(
                                      ' ₹ 15',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Spacer()
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  SizedBox(
                    width: 0.7 * MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 118, 233, 145), // text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        onPressed: () {},
                        child: const Text("Done")),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
