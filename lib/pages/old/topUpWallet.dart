// ignore_for_file: use_build_context_synchronously

import 'package:app/constants.dart';
import 'package:app/pages/welcomePage.dart';
import 'package:app/utilities/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class TopUpWallet extends StatefulWidget {
  const TopUpWallet({super.key});

  @override
  State<TopUpWallet> createState() => _TopUpWalletState();
}

class _TopUpWalletState extends State<TopUpWallet> {
  //RAZOR PAY
  final _razorpay = Razorpay();

  //
  late Client httpClient;
  late Web3Client ethClient;

  bool? created;
  var balance;
  var pro_pic;
  var u_name;
  bool isLoading = false;
  String publicKey = "";
  EthereumAddress defaultAddress =
      EthereumAddress.fromHex("0x603154295A66cb1bE637EE6Ce4639e298c90Eb1C");
  String privateKey =
      "809ce458028c75778039d9133359cfffe1bea99139514f7cacd7b2844b09a4b1";

  late TextEditingController _textController;
  late int total;
  late int myAmount;

  @override
  void initState() {
    super.initState();
    details();
    httpClient = Client();
    ethClient = Web3Client(Constants().web3Client, httpClient);
    _textController = TextEditingController();
    myAmount = 0; // Set a default value
    total = 0;
    //RAZORPAY
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });
    //
  }

  Future<void> details() async {
    try {
      setState(() {
        isLoading = true;
      });
      dynamic data = await getUserDetails();
      if (data != null) {
        publicKey = data['publicKey'];
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

  var response_1;

  Color kGrey = const Color.fromRGBO(246, 246, 246, 1);
  Color kYellow = const Color.fromRGBO(255, 192, 0, 1);
  // var total = 15;
  callback() {
    setState(() {
      response_1 = response_1;
      myAmount = myAmount;
    });
  }

                                  // 'type': 'deposit',
                                  // 'description': 'Wallet Top-Up',
                                  // 'dateTime': DateTime.now(),

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      response_1 = response.paymentId;
    });
    var transactionModel =
        TransactionModel(response: response_1, amount: myAmount, type: 'deposit', description: 'Wallet Top-Up', dateTime: DateTime.now());
    context.read<TransactionModelProvider>().addTransaction(transactionModel);
    showDialog(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width / 390;
        return AlertDialog(
          content: Container(
            // color: kGrey,
            width: 360,
            height: 230,
            // color in rgba
            decoration: BoxDecoration(
              // color: Color(0XFFE4E4E4).withOpacity(0.6),
              color: kGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 75,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Payment of ₹ $total is successful",
                    style: GoogleFonts.poppins(
                      fontSize: 16 * screenWidth,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        var bigAmount = BigInt.from(myAmount);
                        String result = await deposit("sendMoney", [
                          defaultAddress,
                          EthereumAddress.fromHex(publicKey),
                          bigAmount
                        ]);
                        if (result != "Error") {
                          // Deposit successful, navigate to the home page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                title: myAmount,
                              ),
                              settings: RouteSettings(
                                arguments: {
                                  "response": response_1,
                                  "amount": myAmount,
                                  'type': 'deposit',
                                  'description': 'Wallet Top-Up',
                                  'dateTime': DateTime.now(),
                                },
                              ),
                            ),
                          );
                        } else {
                          // Deposit failed, handle accordingly
                          print("Deposit failed");
                        }
                      } catch (error) {
                        print("Error deposit: $error");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      "Ok",
                      style: GoogleFonts.poppins(
                        fontSize: 16 * screenWidth,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width / 390;
        return AlertDialog(
          content: Container(
            width: 360,
            height: 230,
            // color: kGrey,
            // color in rgba
            decoration: BoxDecoration(
              // color: Color(0XFFE4E4E4).withOpacity(0.6),
              color: kGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 75,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Payment of ₹ $total is unsuccessful",
                    style: GoogleFonts.poppins(
                      fontSize: 16 * screenWidth,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      "Ok",
                      style: GoogleFonts.poppins(
                        fontSize: 16 * screenWidth,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // print(response);
    // Do something when an external wallet is selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.walletName ?? ''),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi/abi.json");
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, "Gold"), Constants().contractAddress);
    return contract;
  }

  Future<String> deposit(String functionName, List<dynamic> args) async {
    try {
      DeployedContract contract = await loadContract();
      final ethFunction = contract.function(functionName);
      EthPrivateKey key = EthPrivateKey.fromHex(privateKey);
      Transaction transaction = Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
        maxGas: 100000,
      );

      var nonce = await ethClient.getTransactionCount(
        key.address,
        atBlock: const BlockNum.pending(),
      );

      transaction = transaction.copyWith(nonce: nonce);

      String result =
          await ethClient.sendTransaction(key, transaction, chainId: 11155111);
      print(result);
      return result;
    } catch (error) {
      print("Error submitting transaction: $error");
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 90.0, left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        builder: (context) => const MyHomePage(title: 0),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 90,
                ),
                Text(
                  "Top Up",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Top-up your wallet",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    myAmount =
                        int.parse(_textController.text); // Update myAmount here
                    total = myAmount;
                  });
                  //RAZORPAY
                  var options = {
                    'key': 'rzp_test_jRrCzQJAH4t81Z',
                    'amount': (total * 100).toInt(),
                    'name': 'Genesis',
                    'App Name': 'Genesis',
                    'App ID': 'com.example.app',
                    'description': 'Student Top-Up',
                    'retry': {'enabled': true, 'max_count': 1},
                    'send_sms_hash': true,
                    'prefill': {
                      'contact': '8438006590',
                      'email': 'kiruthick012002@gmail.com'
                    },
                    'external': {
                      'wallets': ['paytm']
                    },
                  };
                  try {
                    _razorpay.open(options);
                  } catch (e) {
                    // print(e.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xff213452),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.only(left: 30, top: 5, bottom: 5, right: 30),
                  child: Text('Proceed to Payment'),
                ),
              ),
            ),
            // LIST OF TRANSACTIONS
            const SizedBox(height: 16),
            const Text(
              "Transaction History",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
