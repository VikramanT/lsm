import 'package:flutter/material.dart';

class WithdrawAmount extends StatelessWidget {
  const WithdrawAmount({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                SizedBox(
                  width: 40,
                ),
                Text(
                  'Withdraw amount',
                  style: TextStyle(color: Colors.black),
                ),
                Spacer()
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                // Add functionality to navigate back or perform other actions.
                // For now, simply pop the current screen.
                Navigator.pop(context);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Withdraw money from your wallet and transfer it back  to your bank account ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Choose an account ",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Image.asset(
                      'assets/canara_bank.jpeg',
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Column(
                      children: [
                        Text(" Canara Bank  ******9875"),
                        Text(" Savings account")
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    Image.asset(
                      'assets/add_bank image.png',
                      height: 50,
                      width: 50,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      " Add another account",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                const SizedBox(
                  height: 250,
                ),
                SizedBox(
                  width: 0.7 * MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            const Color.fromARGB(255, 23, 40, 53), // text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                      onPressed: () {},
                      child: const Text("Proceed to withdraw ")),
                )
              ],
            ),
          )),
    );
  }
}
