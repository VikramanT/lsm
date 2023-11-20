
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class withdraw_1 extends StatefulWidget {
  @override
  _withdraw_1 createState() => _withdraw_1();
}

class _withdraw_1 extends State<withdraw_1> {
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
                    width: 70,
                  ),
                  Text(
                    "Top-up Wallet",
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
    child: Text('Proceed to Transfer'),
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
                  const SizedBox(
                height: 50,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 32,
                  ),
                  Text(
                    "From",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
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
                          Text("Sheethll P"),
                          SizedBox(
                            width: 45,
                          ),
                        ],
                      ),
                      Text(" via Wallet account"),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                children: [
                  SizedBox(
                    width: 32,
                  ),
                  Text(
                    "To",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 30,
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
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  width: 150, // Set the desired width for the TextField
                  child: TextField(
                    style: TextStyle(
                        fontSize: 18), // Adjust the font size as needed
                    decoration: InputDecoration(
                      labelText:
                          '               ₹0       ', // Indian Rupee symbol as the label text
                      // Optional: Add a money icon before the label
                      filled: true,
                      fillColor:
                          Colors.grey[200], // Set the background color to grey
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide.none, // Remove the border when focused
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide
                            .none, // Remove the border when not focused
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15), // Center the label text vertically
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
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
  runApp(withdraw_1());
}

