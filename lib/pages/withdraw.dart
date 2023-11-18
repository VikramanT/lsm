// ignore_for_file: use_build_context_synchronously

import 'package:app/pages/welcomePage.dart';
import 'package:app/utilities/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class MyHomePage1 extends StatefulWidget {
  const MyHomePage1({Key? key}) : super(key: key);

  @override
  State<MyHomePage1> createState() => _MyHomePage1State();
}

class _MyHomePage1State extends State<MyHomePage1> {
  //RAZOR PAY
  final _razorpay = Razorpay();

  //
  late Client httpClient;
  late Web3Client ethClient;
  String privAddress = "";
  // EthereumAddress targetAddress =
  //     EthereumAddress.fromHex("0x603154295A66cb1bE637EE6Ce4639e298c90Eb1C");
  EthereumAddress targetAddress =
      EthereumAddress.fromHex("0x3Fb12806b74D81D1a615ea26282DE5030EC5CeAC");

  bool? created;
  var balance;
  var credentials;
  // int myAmount = 15;
  var pro_pic;
  var u_name;
  bool isLoading = false;

  late TextEditingController _textController;
  late int total;
  late int myAmount;
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        "https://sepolia.infura.io/v3/d468efc91eef40608c29135204c3fd9a",
        httpClient);
    details();
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

  Color kGrey = const Color.fromRGBO(246, 246, 246, 1);
  Color kYellow = const Color.fromRGBO(255, 192, 0, 1);
  // var total = 15;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // print(response);
    // setState(() {
    //   paymentDone = true;
    // });
    // updatePaymentInfo();
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
                    // onPressed: () {
                    // Navigator.pop(context);
                    // },
                    onPressed: () async {
                      try {
                        var bigAmount = BigInt.from(myAmount);
                        String result = await deposit("deposit", [
                          EthereumAddress.fromHex(
                              "0x603154295A66cb1bE637EE6Ce4639e298c90Eb1C"),
                          bigAmount
                        ]);
                        var updatedBalance = await getBalance(credentials);
                        setState(() {
                          balance = updatedBalance;
                        });
                        if (result != "Error") {
                          // Deposit successful, navigate to the home page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyHomePage(
                                title: 'wallet',
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
    // print(response);
    // setState(() {
    //   paymentDone = false;
    // });
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
        created = data['wallet_created'];
        balance = await getBalance(credentials);
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

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi/abi.json");
    // String contractAddress = "0x7C9301E142b38B776fe7EA14f5B108E6BE8AA75b";
    // String contractAddress = "0x1162e04c5FefBFf105312404a9d8fBbdaDC21bB7";
    String contractAddress = "0x16203e1580e0215d3baC15367d9f5d6eb8E015d9";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "Gold"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
      contract: contract,
      function: ethFunction,
      params: args,
    );
    return result;
  }

  Future<BigInt> getBalance(EthereumAddress credentialAddress) async {
    List<dynamic> result = await query("balanceOf", [credentialAddress]);
    var data = result[0];
    return data;
  }

  Future<String> deposit(String functionName, List<dynamic> args) async {
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
      print(result);
      return result;
      // print("here");
    } catch (error) {
      print("Error submitting transaction: $error");
      return "Error";
    }
  }

  void makeDirectTransfer() async {
    var url = Uri.parse('https://api.razorpay.com/v1/transfers');
    var response = await http.post(url, body: {
      'account': 'acc_123', // Replace with the account id
      'amount': '200', // Replace with the amount
      'currency': 'INR',
      'notes': {
        'note1': 'This is a test transfer',
      },
    });

    if (response.statusCode == 200) {
      print('Transfer successful');
    } else {
      print('Transfer failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Box and Button Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter Text',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _displayText = _textController.text;
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
              child: const Text('Submit'),
            ),
            const SizedBox(height: 16),
            Text(
              'Entered Text: $_displayText',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
