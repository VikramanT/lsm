import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class withdraw extends StatefulWidget {
  @override
  _withdrawState createState() => _withdrawState();
}

class _withdrawState extends State<withdraw> {
  //final _formKey = GlobalKey<FormState>();
  //String _registrationNumber = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
       
        body: Padding(
          padding: EdgeInsets.only(top:40.0,left: 20,right: 20),
          child: Form(
           // key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: [
                  IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              // Manually trigger the refresh
              // You can call your refresh logic here
              // For example, you can update the transaction history
            },
          ), 
          const SizedBox(width: 70,),
          Text(
                        "Withdraw amount",
                        style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.black,fontSize: 18.0, fontWeight: FontWeight.w600))),
          

                ],),
                   const SizedBox(height: 30,),
                  Text(
                        "Transfer money from your bank account to your wallet",
                        style: GoogleFonts.poppins(textStyle: const TextStyle(color:Colors.black,fontSize: 20.0, fontWeight: FontWeight.w400))),
                           const SizedBox(height: 30,),
                           Text(
                        "Choose an account",
                        style: GoogleFonts.poppins(textStyle: const TextStyle(color:Colors.black,fontSize: 20.0, fontWeight: FontWeight.w400))),
          

                SizedBox(height: 20.0),
                  Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    'assets/images/canara_bank.png',
                    height: 50,
                    width: 50,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Column(
                    children: [
                      Text(" Canara Bank  ******9875"),
                      Row(
                        children: [
                          Text(" Savings account"),
                          SizedBox(
                            width: 50,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30,),
                          Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    'assets/images/money_image.png',
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Column(
                    children: [
                      Row(
                        children: [
                          Text("Add another Account"),
                          SizedBox(
                            width: 45,
                          ),
                        ],
                      ),
                      Text(" "),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height:30,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 32,
                  ),
              
                ],
              ),

                
                  Align(
      alignment: Alignment.bottomCenter,
      child: 
 TextButton(
  onPressed: () {
    // if (_formKey.currentState!.validate()) {
    //   _formKey.currentState!.save();
    //   // Proceed with the payment using _registrationNumber
    // }
  },
  style: TextButton.styleFrom(
    backgroundColor: Color(0xff213452),
    primary: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  ),
  child: Padding(
    padding: const EdgeInsets.only(left:30,top:5,bottom:5,right: 30),
    child: Text('Proceed to withdraw'),
  ),
)

    ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
