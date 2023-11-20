// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:app/constants.dart';
import 'package:app/main.dart';
import 'package:app/pages/student/homepage/homepage.dart';
import 'package:app/utilities/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class TopUpWallet extends StatefulWidget {
  const TopUpWallet({super.key});

  @override
  State<TopUpWallet> createState() => _TopUpWalletState();
}

class _TopUpWalletState extends State<TopUpWallet> {
  final _razorpay = Razorpay();
  late Client httpClient;
  late Web3Client ethClient;
  bool? created;
  BigInt? balance;
  bool isLoading = false;
  String publicKey = "";

  late EthereumAddress defaultAddress;
  late String privateKey;

  late TextEditingController _textController;
  late int total;
  late int myAmount;

  @override
  void initState() {
    super.initState();
    getDefaultWallet();
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

  Future<dynamic> getDefaultWallet() async {
    dynamic data;
    final cf.DocumentReference document = cf.FirebaseFirestore.instance
        .collection("defaultwallet")
        .doc("6N4gXhg2AMw8BQJcKV4u");

    await document.get().then<dynamic>((cf.DocumentSnapshot snapshot) {
      data = snapshot.data();
      defaultAddress = EthereumAddress.fromHex(data['publicKey']);
      privateKey = data['privateKey'];
    });

    // Consider returning the data or other relevant information here
    return data;
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
        // const SnackBar(content: Text('No User data found'));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No User data found'),
          ),
        );
      }
    } catch (error) {
      // SnackBar(content: Text('Error fetching details: $error'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching details: $error'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String response_1 = "";
  Color kGrey = const Color.fromRGBO(246, 246, 246, 1);
  Color kYellow = const Color.fromRGBO(255, 192, 0, 1);
  // var total = 15;
  callback() {
    setState(() {
      response_1 = response_1;
      myAmount = myAmount;
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      response_1 = response.paymentId!;
    });
    var transactionModel = TransactionModel(
        response: response_1,
        amount: myAmount,
        type: 'deposit',
        description: 'Wallet Top-Up',
        dateTime: DateTime.now());
    context.read<TransactionModelProvider>().addTransaction(transactionModel);
    showDialog(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width / 390;
        return AlertDialog(
          backgroundColor: Colors.white, // Set background color to white
          content: SizedBox(
            width: 325,
            height: 230,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/file-text.png',
                  height: 75,
                  width: 75,
                ),
                const SizedBox(height: 20),
                Text(
                  "₹ $total successful transferred",
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentHomePage(),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Deposit failed'),
                          ),
                        );
                      }
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error deposit: $error'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(150, 50),
                    backgroundColor: const Color(0xff213452),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Done",
                        style: GoogleFonts.poppins(
                          fontSize: 16 * screenWidth,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 16 * screenWidth,
                      ),
                    ],
                  ),
                ),
              ],
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
          backgroundColor: Colors.white, // Set background color to white
          content: SizedBox(
            width: 325,
            height: 230,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/file-text.png',
                  height: 75,
                  width: 75,
                ),
                const SizedBox(height: 20),
                Text(
                  "₹ $total transferred is unsuccessful",
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
                    fixedSize: const Size(150, 50),
                    backgroundColor: const Color(0xff213452),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Done",
                        style: GoogleFonts.poppins(
                          fontSize: 16 * screenWidth,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // tick icon
                      Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 16 * screenWidth,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
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
        // gasPrice: EtherAmount.inWei(BigInt.one),
        // value: EtherAmount.fromInt(EtherUnit.ether, 1),
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
      // print("Error submitting transaction: $error");
      // SnackBar(content: Text('Error submitting transaction: $error'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting transaction: $error'),
        ),
      );

      return "Error";
    }
  }

  final String _apiUrl =
      'https://53z7prs4a0.execute-api.ap-south-1.amazonaws.com/v1/GENESIS';

  Future<void> sendSMS() async {
    try {
      String phoneNumber = "";

      // Create a request body as a JSON string
      Map<String, dynamic> requestBody = {
        "phone_number": phoneNumber,
        "amount": total,
        "trntyp": "2"
      };
      String requestBodyString = jsonEncode(requestBody);

      // Send the POST request to the Lambda function endpoint
      Response response = await post(
        Uri.parse(_apiUrl),
        body: requestBodyString,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Successful API call
        // Parse the response JSON
        Map<String, dynamic> responseData = json.decode(response.body);
        // print(
        //     "Response: ${responseData['message']}"); // Print the response message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message']),
          ),
        );
      } else {
        // API call failed
        // print('API Call Failed: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('API Call Failed: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      // Handle any exceptions
      // print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.only(top: 90.0, left: 16, right: 16),
          child: Column(
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
                          builder: (context) => const StudentHomePage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 60),
                  Text(
                    "Top-Up Wallet",
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
              const SizedBox(height: 30),
              Text(
                "Enter the amount to top-up your wallet",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      total = 0;
                    } else {
                      myAmount = int.parse(value);
                      total = myAmount;
                    }
                  });
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
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
                      myAmount = int.parse(
                          _textController.text); // Update myAmount here
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
              const SizedBox(height: 5),
              Text(
                // "Total: ₹ ${total * 1} = ₹ $total",
                "Total: ₹ $total * 1 = ₹ $total",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // conversion rate
              const SizedBox(height: 20),
              const Text(
                "Conversion Rate:",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "100 GLD = 100 INR",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
