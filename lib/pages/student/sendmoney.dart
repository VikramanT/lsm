import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SendMoney extends StatefulWidget {
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final _formKey = GlobalKey<FormState>();
  String _registrationNumber = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
       
        body: Padding(
          padding: EdgeInsets.only(top:40.0,left: 20,right: 20),
          child: Form(
            key: _formKey,
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
          const SizedBox(width: 90,),
          Text(
                        "Send Money",
                        style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.black,fontSize: 18.0, fontWeight: FontWeight.w600))),
          

                ],),
                   const SizedBox(height: 30,),
                  Text(
                        "Send Money to your friends",
                        style: GoogleFonts.poppins(textStyle: const TextStyle(color:Colors.black,fontSize: 20.0, fontWeight: FontWeight.w400))),
                           const SizedBox(height: 30,),
           TextFormField(
            
  decoration: InputDecoration(
    
    labelText: 'Registration Number',
    floatingLabelBehavior: FloatingLabelBehavior.always,
    border: OutlineInputBorder(), // Optional: You can still include a border if needed
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter registration number';
    }
    return null;
  },
  onSaved: (value) {
    _registrationNumber = value!;
  },
),

                SizedBox(height: 20.0),
                  Align(
      alignment: Alignment.bottomCenter,
      child: 
 TextButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Proceed with the payment using _registrationNumber
    }
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
    child: Text('Proceed to Payment'),
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
