
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SendMoney_1 extends StatefulWidget {
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney_1> {
  final _formKey = GlobalKey<FormState>();
  String _amount = '';


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 40.0, left: 30, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
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
                  const SizedBox(
                    width: 90,
                  ),
                  Text(
                    "Send Money",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              DottedBorderContainer(),
              const SizedBox(height: 220,),
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
    child: Text('Proceed to Pay'),
  ),
)



    ),
            ],
          ),
        ),
      ),
    );
  }
}

class DottedBorderContainer extends StatelessWidget {
  late final GlobalKey<FormState> formKey;
  late final ValueChanged<String> onAmountSaved;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 400.0,
      child: CustomPaint(
        painter: DottedPainter(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(bottom: 110)),
            Container(child: Image.asset("assets/images/hum.png"),),
             Text(
                        "PayingSheethl P",
                        style: GoogleFonts.manrope(textStyle: TextStyle(color:Colors.black,fontSize: 20.0, fontWeight: FontWeight.w500))),
            
            Text(
                        "20MID0206",
                        style: GoogleFonts.manrope(textStyle: TextStyle(color:Colors.black,fontSize: 20.0, fontWeight: FontWeight.w500))),
            
             Text(
                        "Wallet  name:Sheethll P",
                        style: GoogleFonts.manrope(textStyle: TextStyle(color:Colors.black,fontSize: 20.0, fontWeight: FontWeight.w500))),


                        const SizedBox(height: 10,),
           Container(margin: EdgeInsets.only(left:110,right: 110),
           decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(10)),
             child: TextFormField(
                  decoration: InputDecoration(
                   // labelText: 'amount',
                   hintText: '₹ 0',
                   // floatingLabelBehavior: FloatingLabelBehavior.always,
                   // border: OutlineInputBorder(),
         
                  ),
                  
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the amount';
                    }
                    return null;
                  },
                 //          onSaved: onAmountSaved,
                ),
           ),

            // Add more text or widgets as needed
          ],
        ),
      ),
    );
  }
}

class DottedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dashWidth = 5.0;
    final dashSpace = 5.0;

    // Draw top border
    double startX = 0.0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0.0),
        Offset(startX + dashWidth, 0.0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    // Draw bottom border
    double endX = 0.0;
    while (endX < size.width) {
      canvas.drawLine(
        Offset(endX, size.height),
        Offset(endX + dashWidth, size.height),
        paint,
      );
      endX += dashWidth + dashSpace;
    }

    // Draw left border
    double startY = 0.0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0.0, startY),
        Offset(0.0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Draw right border
    double endY = 0.0;
    while (endY < size.height) {
      canvas.drawLine(
        Offset(size.width, endY),
        Offset(size.width, endY + dashWidth),
        paint,
      );
      endY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  runApp(SendMoney_1());
}

