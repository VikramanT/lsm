// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:app/constants.dart';
import 'package:app/pages/student/homepage/homepage.dart';
import 'package:app/utilities/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:google_fonts/google_fonts.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({super.key});

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  late Client httpClient;
  late Web3Client ethClient;
  BigInt? balance;
  bool isLoading = false;
  EthereumAddress? publicKey;
  String privateKey = "";
  EthereumAddress? recipientpublicKey;

  late TextEditingController _textController;
  late int total;
  late int myAmount;
  bool userExists = false;
  bool isTransactionInProgress = false;

  @override
  void initState() {
    super.initState();
    details();
    httpClient = Client();
    ethClient = Web3Client(Constants().web3Client, httpClient);
    _textController = TextEditingController();
    myAmount = 0; // Set a default value
    total = 0;
  }

  Future<void> details() async {
    try {
      setState(() {
        isLoading = true;
      });
      dynamic data = await getUserDetails();
      if (data != null) {
        publicKey = EthereumAddress.fromHex(data['publicKey']);
        privateKey = data['privateKey'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No User data found'),
          ),
        );
      }
    } catch (error) {
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
  callback() {
    setState(() {
      response_1 = response_1;
      myAmount = myAmount;
    });
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
        maxGas: 50000,
        gasPrice: EtherAmount.inWei(BigInt.one),
      );

      var nonce = await ethClient.getTransactionCount(
        key.address,
        atBlock: const BlockNum.pending(),
      );

      transaction = transaction.copyWith(nonce: nonce);

      String result =
          await ethClient.sendTransaction(key, transaction, chainId: 11155111);
      isTransactionInProgress = false;
      return result;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting transaction: $error'),
        ),
      );
      isTransactionInProgress = false;
      return "Error";
    }
  }

  // checkUserExists
  Future<bool> checkUserExists(
      String registrationNumber, BuildContext context) async {
    try {
      dynamic data;
      cf.QuerySnapshot<Map<String, dynamic>> querySnapshot = await cf
          .FirebaseFirestore.instance
          .collection("users")
          .where('reg_no', isEqualTo: registrationNumber.toUpperCase())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        data = querySnapshot.docs[0].data();
        recipientpublicKey = EthereumAddress.fromHex(data['publicKey']);
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User does not exist'),
          ),
        );
        return false;
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching details: $error'),
        ),
      );
      return false;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
                  const SizedBox(
                    width: 80,
                  ),
                  Text(
                    "Send Money",
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
                "Send money to your friends",
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
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Registeration Number',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (!userExists)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () async {
                      String registrationNumber = _textController.text;
                      // Check if user exists in the databaseA
                      bool exists =
                          await checkUserExists(registrationNumber, context);
                      setState(() {
                        userExists = exists;
                        if (userExists) {
                          // If user exists, set focus to the amount TextField
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xff213452),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: 30, top: 5, bottom: 5, right: 30),
                      child: Text('Check User Availability'),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Display the amount TextField only if the user exists
              if (userExists)
                TextField(
                  onChanged: (value) {
                    setState(() {
                      myAmount = int.parse(value);
                      total = myAmount;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 16),
              // Display the button only if the user exists
              if (userExists)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () async {
                      if (myAmount > 0) {
                        isTransactionInProgress = true;
                        String txHash = await deposit("sendMoney", [
                          publicKey,
                          recipientpublicKey,
                          BigInt.from(myAmount)
                        ]);
                        setState(() {
                          response_1 = txHash;
                        });
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
                      padding: EdgeInsets.only(
                          left: 30, top: 5, bottom: 5, right: 30),
                      child: Text('Proceed to Payment'),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (isTransactionInProgress)
                const CircularProgressIndicator(
                  color: Colors.purple,
                ),
              // Display a message if the user doesn't exist
              if (!userExists)
                Text(
                  "Check User Availability first",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Colors.purple, // Choose your color
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
