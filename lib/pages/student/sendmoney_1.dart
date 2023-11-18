
import 'package:app/utilities/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/pages/welcomePage.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class SendMoney_1 extends StatefulWidget {
  final String firstStringValue;
  final String secondStringValue;
   SendMoney_1({
    required this.firstStringValue,
    required this.secondStringValue,
  });
  @override
  _SendMoney_1State createState() => _SendMoney_1State();
}


class _SendMoney_1State extends State<SendMoney_1> {
  final _formKey = GlobalKey<FormState>();
  String _amount = '';
    bool isLoading = false;
    late Client httpClient;
  late Web3Client ethClient;
   String privAddress = "";
   late TextEditingController amountController;
   
     var credentials;
     String addr="";
     
      
 @override
  void initState() {
    super.initState();
    httpClient = Client();
    amountController = TextEditingController();
    ethClient = Web3Client(
        "https://sepolia.infura.io/v3/94f7fea0f45d4643b095ae8069e90f50",
        httpClient);
        details();
      // 
        
  }
  Future<String> sendCoin(String targetAddress,TextEditingController myAmount) async {
    try {
      setState(() {
        isLoading = true;
      });
      EthereumAddress targ=EthereumAddress.fromHex(targetAddress);
          int myAmount = int.parse(amountController.text);
      var bigAmount = BigInt.from(myAmount);
      var response = await submit("transfer", [targ, bigAmount]);
      return response;
    } catch (error) {
      print("Error sending coin: $error");
      return "Error";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
    Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi/abi.json");
    // String contractAddress = "0x7C9301E142b38B776fe7EA14f5B108E6BE8AA75b";
    // String contractAddress = "0x1162e04c5FefBFf105312404a9d8fBbdaDC21bB7";
    String contractAddress = "0x5FCab2e6d66F05CC9752e76c9d5B2cf868800fA9";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "Gold"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }
      Future<String> submit(String functionName, List<dynamic> args) async {
    try {
      DeployedContract contract = await loadContract();
      final ethFunction = contract.function(functionName);
      EthPrivateKey key = EthPrivateKey.fromHex(privAddress);
      Transaction transaction = Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
        maxGas: 100000,
      );

      var nonce = await ethClient.getTransactionCount(
        credentials,
        atBlock: const BlockNum.pending(),
      );

      transaction = transaction.copyWith(nonce: nonce);

      String result =
          await ethClient.sendTransaction(key, transaction, chainId: 11155111);


      return result;
    } catch (error) {
      print("Error submitting transaction: $error");
      return "Error";
    }
  }
   Future<void> details() async {
    try {
      setState(() {
        isLoading = true;
      });
      dynamic data = await getUserDetails();

      if (data != null) {
        privAddress = data['privateKey'];
        var temp = EthPrivateKey.fromHex(privAddress);
         credentials = temp.address;
       // created = data['wallet_created'];
       // balance = await getBalance(credentials);
      } else {
        print("Data is NULL!");
      }
    } catch (error) {
      print("Error fetching details: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
               DottedBorderContainer(amountController: amountController),
              const SizedBox(height: 220,),
                                Align(
      alignment: Alignment.bottomCenter,
      child: 
 TextButton(
  onPressed: () async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
        setState(() {
                        isLoading = true;
                      });
                        String result = await sendCoin(widget.firstStringValue,amountController);
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
  final TextEditingController amountController;

  DottedBorderContainer({required this.amountController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 400.0,
      child: CustomPaint(
        painter: DottedPainter(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(bottom: 110)),
            Container(child: Image.asset("assets/images/hum.png")),
            Text(
              "PayingSheethl P",
              style: GoogleFonts.manrope(
                  textStyle: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500)),
            ),
            Text(
              "20MID0206",
              style: GoogleFonts.manrope(
                  textStyle: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500)),
            ),
            Text(
              "Wallet  name:Sheethll P",
              style: GoogleFonts.manrope(
                  textStyle: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.only(left: 110, right: 110),
              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: amountController,
                decoration: InputDecoration(
                  hintText: '₹ 0',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
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