import 'dart:convert';

import 'package:app/main.dart';
import 'package:app/pages/deposit.dart';
import 'package:app/pages/student/menu.dart';
import 'package:app/pages/student/sendmoney.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/pages/createWallet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:app/utilities/firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hex/hex.dart';
import 'package:connectivity/connectivity.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final int title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  late Client httpClient;
  late Web3Client ethClient;
  String privAddress = "";
  // EthereumAddress targetAddress =
  //     EthereumAddress.fromHex("0x603154295A66cb1bE637EE6Ce4639e298c90Eb1C");
  EthereumAddress targetAddress =
      EthereumAddress.fromHex("0x5FCab2e6d66F05CC9752e76c9d5B2cf868800fA9");

  bool? created;
  var balance;
  var credentials;
  int myAmount = 15;
  var pro_pic;
  var u_name;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
        "https://sepolia.infura.io/v3/94f7fea0f45d4643b095ae8069e90f50",
        httpClient);
        loadTransactionHistory();
    details();
  }

  Future<void> loadTransactionHistory() async {
    try {
      await context.read<TransactionModelProvider>().loadTransactionHistory();
    } catch (error) {
      print("Error loading transaction history: $error");
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
    String contractAddress = "0x5FCab2e6d66F05CC9752e76c9d5B2cf868800fA9";
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
    } catch (error) {
      print("Error submitting transaction: $error");
      return "Error";
    }
  }

  Future<String> withdraw(String functionName, List<dynamic> args) async {
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

  Future<String> sendCoin() async {
    try {
      setState(() {
        isLoading = true;
      });
      var bigAmount = BigInt.from(myAmount);
      var response = await submit("transfer", [targetAddress, bigAmount]);
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



Future<String> sendRawTransaction(Uint8List signedTransaction) async {
  try {
    // Infura API endpoint
    final String infuraUrl = 'https://sepolia.infura.io/v3/94f7fea0f45d4643b095ae8069e90f50';

    // Construct the request headers
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    // Construct the request body
    final String requestBody = jsonEncode({
      'jsonrpc': '2.0',
      'method': 'eth_sendRawTransaction',
      'params': [
        '0x${HEX.encode(signedTransaction)}',
      ],
      'id': 1,
    });

    // Make the HTTP POST request to Infura
    final http.Response httpResponse = await http.post(
      Uri.parse(infuraUrl),
      headers: headers,
      body: requestBody,
    );

    // Parse the response
    final Map<String, dynamic> responseJson = jsonDecode(httpResponse.body);

    // Check if the response contains a transaction hash
    if (responseJson.containsKey('result')) {
      final String transactionHash = responseJson['result'];
      return transactionHash;
    } else if (responseJson.containsKey('error')) {
      final dynamic error = responseJson['error'];
      print("Error from Infura: $error");
    }

    return "Error";
  } catch (error) {
    print("Error sending raw transaction: $error");
    return "Error";
  }
}
Future<void> initiateOfflineTransaction() async {
  try {
    setState(() {
      isLoading = true;
    });

    // Simulate the process of initiating an offline transaction
    var bigAmount = BigInt.from(myAmount);
    await saveTransactionDetails("sendMoney", [targetAddress, bigAmount]);

    // Check if the transaction details are saved
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? transactionJson = prefs.getString('pendingTransaction');
    print("Saved Transaction Details: $transactionJson");

  } catch (error) {
    print("Error initiating offline transaction: $error");
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

Future<void> saveTransactionDetails(
  String functionName,
  List<dynamic> args,
) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String transactionKey = 'pendingTransaction';

    final Map<String, dynamic> transactionDetails = {
      'functionName': functionName,
      'args': args.map((arg) => arg.toString()).toList(),
      'targetAddressHex': targetAddress.hex,
    };
    // final Map<String,dynamic> transactionDetails ={
    //   'functionName':functionName,
    //   'args': args.map((arg) => arg.toString()).toList(),
    //   'targetAddressHex':EthereumAddress.fromHex(targetAddress as String)
    // };

    // Manually serialize the transaction details
    final String transactionJson = jsonEncode(transactionDetails);

    prefs.setString(transactionKey, transactionJson);
  } catch (error) {
    print("Error saving transaction details: $error");
  }
}


Future<void> broadcastSavedTransaction() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? transactionJson = prefs.getString('pendingTransaction');

    if (transactionJson != null) {
      final Map<String, dynamic> transactionDetails =
          jsonDecode(transactionJson);

      final String functionName = transactionDetails['functionName'];
      // print(functionName);
      final List<dynamic> args = transactionDetails['args'];
      // print(args[0]);
      // print(args[1]);

      // Extract the targetAddress from args
      // EthereumAddress targetAddress = args[0];
      EthereumAddress targetAddress = EthereumAddress.fromHex(transactionDetails['targetAddressHex']);
      // print(targetAddress);

      // Process the saved transaction details (send the transaction)
      // await submit(functionName, [targetAddress]);
     final result =  await submit(functionName, [EthereumAddress.fromHex("0xcDD9663C8958C1b6CB383DcD370B8C4a3eD8e793"),targetAddress,BigInt.parse(args[1])]);
    print(result);
      prefs.remove('pendingTransaction');
    }
  } catch (error) {
    print("Error broadcasting saved transaction: $error");
  }
}





  @override
  Widget build(BuildContext context) {
    var transactionHistory = context.watch<TransactionModelProvider>().transactionHistory;
    // final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final user = FirebaseAuth.instance.currentUser;
    if (user?.photoURL == null) {
      pro_pic = "assets/images/logo.png";
    } else {
      pro_pic = user!.photoURL;
    }
    if (user?.displayName == null) {
      u_name = "User Name";
    } else {
      u_name = user!.displayName;
    }
    return Scaffold(
      backgroundColor: Color(0xff213452),
           body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : 
           Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:90,bottom:20),
              color: Color(0xff213452),
              child:

               Column(
                 children: [
                   Container(
                    padding: EdgeInsets.only(top: 30,bottom: 30),
                    margin: EdgeInsets.only(left: 50,right:50),
                    decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/backblur.png'),
                     fit: BoxFit.fill,
                    )),
                     child: 
                     Column(
                       children: [
                          Center(
                          child: Text(
                            'Your balance',
                            style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white,fontSize: 20)),
                          ),
                                 ),
                                 SizedBox(height: 20,),
                         Center(
                          child:
                          Container(
                            padding: EdgeInsets.only(left: 20,right: 30,bottom:15,top:10,),
                            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/dotted.png'),
                     fit: BoxFit.fill,
                    )),

                            child: Text(
                            '₹ $balance',
                            style: GoogleFonts.rokkitt(textStyle: TextStyle(color: Colors.white,fontSize: 36)),
                          ),
                                 ),
                         ),
                       ],
                     ),
                   ),
                   Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: <Widget>[
    MaterialButton(
      onPressed: () async {
                      var response = await sendCoin();
                      print(response);
                    },
      child: Image.asset('assets/compare_arrows.png', height: MediaQuery.of(context).size.width < 600 ? 80.0 : 120.0),
    ),
    MaterialButton(
      onPressed: () async {
        var result= Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage1(),
                        ),
                      );
                      
        


      },
      child: Image.asset('assets/arrow_upward.png', height: MediaQuery.of(context).size.width < 600 ? 80.0 : 120.0),
    ),
    MaterialButton(
      onPressed: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendMoney(),
                        ),
                      );
                    },

      
      child: Image.asset('assets/arrow_downward.png', height: MediaQuery.of(context).size.width < 600 ? 80.0 : 120.0),
    ),
    MaterialButton(
      onPressed: () {
        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  menu(),
                        ),
                      );
      },
      child: Image.asset('assets/menu.png', height: MediaQuery.of(context).size.width < 600 ? 80.0 : 120.0),
    ),
  ],
),
                 ],
               ),
            ),
   
//const SizedBox(height: 50,),


          Expanded(
  child: Container(
    decoration: BoxDecoration(color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      )
    ),
    child: Column(
      children: <Widget>[
        const SizedBox(height: 20,),
        Text(
          'Transaction History',
          textAlign:TextAlign.left,
          style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xff082431),fontSize: 18,)),
        ),
        Divider(
              color: Color(0xff082431)
            ),
        Expanded(
          child: ListView.builder(
            itemCount: transactionHistory.length,
            itemBuilder: (context, index) {
              var transaction = transactionHistory[index];
              return 
              // Container(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //      Row(
              //       children: [
                      
              //         Container(width: 50,height: 50,
              //           child:Image.asset('assets/shuttle_1.png'),),
              //         Text("Shuttle ride"),
              //         const SizedBox(width: 50,),
              //         Text("₹ 15.00")
              //       ],
              //      ),
              //      Text("Nov 18, 2023 at 12:00 pm "),
                   
              //     ],
                  
              //   ),
              // );
               Container(
      padding: const
 
EdgeInsets.all(16.0),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(8.0),
      //   border: Border.all(color: Colors.grey),
      // ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset('assets/shuttle_1.png', width: 50, height: 50),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      margin: EdgeInsets.only(right: 100),
                      child: Text(
                      ' ${transaction.response}',
                       style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xff213452),fontSize: 14.0, fontWeight: FontWeight.w500))
                                       
                                      ),
                    ),
               //   const SizedBox(width: 120,),
                  Text(
                    '₹ ${transaction.amount}',
                    style: GoogleFonts.poppins(textStyle: TextStyle(color: Color(0xff213452),fontSize: 14.0, fontWeight: FontWeight.w500))
                  ),
                  ],),
                  
                  

      //             Row(children: [
      //                Text(
      //               "Nov 17, 2023 at 9:50 am",
      //               style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.grey,fontSize: 14.0, fontWeight: FontWeight.w300))
      //             ),
      // const SizedBox(width: 55,),
      //                 Text(
      //               "Felix Logistics",
      //              style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.grey,fontSize: 14.0, fontWeight: FontWeight.w300))
      //             ),

      //             ],)
                
                ],
              ),
           
            ],
          ),
        
        ],
      ),
    );
              // ListTile(
              //   title: Text('Transaction ${index + 1}',style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black,fontSize: 18,))
              //   ),
              //   subtitle: Text('Date - Time\nAmount'),
              // );
            },
          ),
        ),
        Container(height: 30,
          width: double.infinity,
          decoration: BoxDecoration(color: Color(0xff213452),),
          child:  
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Center(child: 
              Text(
                        "Last sync on 04-10-2023 10:57 am",
                        style: GoogleFonts.manuale(textStyle: TextStyle(color:Colors.white,fontSize: 17.0, fontWeight: FontWeight.w300)))),
                  Transform.translate(
          offset: Offset(0, -5.0), // Adjust the vertical offset as needed
          child: IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              // Manually trigger the refresh
              // You can call your refresh logic here
              // For example, you can update the transaction history
            },
          ),
        ),
                        
            ],
          )
          )
      ],
    ),
  ),
),

          ],
        ),
// 
// 
// 
// ListView(
//               children: [
//                 Container(
//                   color: Colors.blue[600],
//                   height: 150,
//                   alignment: Alignment.center,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                       image: DecorationImage(
//                         image: NetworkImage(pro_pic),
//                         scale: 0.1,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.all(20),
//                   child: Text(
//                     u_name,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       color: Colors.blueAccent,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.all(5),
//                   alignment: Alignment.center,
//                   height: 100,
//                   width: MediaQuery.of(context).size.width,
//                   child: const Text(
//                     "Balance",
//                     style: TextStyle(
//                       fontSize: 70,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.all(5),
//                   alignment: Alignment.center,
//                   height: 50,
//                   width: MediaQuery.of(context).size.width,
//                   child: Text(
//                     balance == null ? "0 GLD" : "$balance GLD",
//                     style: const TextStyle(
//                       fontSize: 50,
//                       color: Colors.blueAccent,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.all(20),
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       var response = await sendCoin();
//                       print(response);
//                     },
//                     style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.all<Color>(Colors.green),
//                     ),
//                     child: const Text("Send Money"),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.all(10),
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       try {
//                         var updatedBalance = await getBalance(credentials);
//                         setState(() {
//                           balance = updatedBalance;
//                         });
//                       } catch (error) {
//                         print("Error fetching balance: $error");
//                       }
//                     },
//                     child: const Text("Refresh Page"),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                 //    await performOfflineTransaction();
//                // createOfflineTransaction();
//               // generateTransactionHash("803388097393d1956cc9c60d2ef979ccdd042e2cdeef2ffc07ad6a1f79344034", targetAddress);
//               await initiateOfflineTransaction();
//                   },
//                   child: Text("Offline Transaction"),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.all(10),
//                   child: ElevatedButton(
//                     // onPressed: () async {
//                     //   try {
//                     //     var bigAmount = BigInt.from(myAmount);
//                     //     await deposit("deposit", [
//                     //       EthereumAddress.fromHex(
//                     //           "0x603154295A66cb1bE637EE6Ce4639e298c90Eb1C"),
//                     //       bigAmount
//                     //     ]);
//                     //     var updatedBalance = await getBalance(credentials);
//                     //     setState(() {
//                     //       balance = updatedBalance;
//                     //     });
//                     //   } catch (error) {
//                     //     print("Error deposit: $error");
//                     //   }
//                     // },
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const MyHomePage1(),
//                         ),
//                       );
//                     },
//                     child: const Text("Deposit"),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.all(10),
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       try {
//                         var bigAmount = BigInt.from(myAmount);
//                         await withdraw("withdraw", [bigAmount]);
//                         var updatedBalance = await getBalance(credentials);
//                         setState(() {
//                           balance = updatedBalance;
//                         });
//                       } catch (error) {
//                         print("Error withdraw: $error");
//                       }
//                     },
//                     child: const Text("Withdraw"),
//                   ),
//                 ),
//                 // Example: Calling broadcastOfflineTransaction when a button is pressed
// ElevatedButton(
//   onPressed: () async {
//     //await broadcastOfflineTransaction();
//    await broadcastSavedTransaction();
//   },
//   child: const Text("Broadcast Offline Transaction"),
// ),

//                 Container(
//                   margin: const EdgeInsets.only(top: 30, right: 30),
//                   alignment: Alignment.bottomRight,
//                   child: FloatingActionButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const CreateWallet(),
//                         ),
//                       );
//                     },
//                     child: const Icon(Icons.add),
//                   ),
//                 ),
//               ],
//             ),
    );
  }
}