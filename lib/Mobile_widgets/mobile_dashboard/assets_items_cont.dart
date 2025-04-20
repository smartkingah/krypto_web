import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';

class AssetsItemsCont extends StatefulWidget {
  final String userId;

  const AssetsItemsCont({super.key, required this.userId});

  @override
  State<AssetsItemsCont> createState() => _AssetsItemsContState();
}

class _AssetsItemsContState extends State<AssetsItemsCont> {
  double userBalance = 0.0; // e.g. 200.0
  final Map<String, String> symbolToCoinGeckoId = {
    "BTC": "bitcoin",
    "ETH": "ethereum",
    "SOL": "solana",
    "BNB": "binancecoin",
    "ADA": "cardano",
    "XRP": "ripple",
    "DOGE": "dogecoin",
    "DOT": "polkadot",
    "MATIC": "polygon",
    "LTC": "litecoin",
  };

  Future<String?> fetchCoinLogo(String coinId) async {
    final url = Uri.parse('https://api.coingecko.com/api/v3/coins/$coinId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['image']['thumb']; // or 'small'/'large'
    } else {
      print('Failed to load image for $coinId');
      return null;
    }
  }

  // Future<double?> fetchUsdToCryptoRate(String coinId) async {
  //   final url = Uri.parse(
  //       'https://api.coingecko.com/api/v3/simple/price?ids=$coinId&vs_currencies=usd');
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     print("data ===========================================>>>>>> ${data}");
  //     // return 1 / (data[coinId]['usd'] as num);
  //     return (data[coinId]['usd'] as num).toDouble();
  //   }
  //   return null;
  // }

  Future<double?> fetchUsdToCryptoRate(String coinId) async {
    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price?ids=$coinId&vs_currencies=usd',
    );
    print("Fetching price for $coinId from $url");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Received data: $data");

      final price = (data[coinId]['usd'] as num).toDouble();
      print("USD Price for $coinId: $price");
      return price;
    } else {
      print("Failed to fetch price for $coinId: ${response.statusCode}");
    }

    return null;
  }

  // Generate random percentage (-10% to +10%)
  String _getRandomPercentageChange() {
    final random = Random();
    final change =
        (random.nextDouble() * 20 - 10).toStringAsFixed(2); // -10.00 to +10.00
    return change.startsWith('-') ? change : '+$change'; // Add "+" if positive
  }

// Color logic: Green for positive, Red for negative
  Color _getRandomColorForPercentage() {
    final random = Random();
    return random.nextBool() ? Colors.green : Colors.red; // 50/50 chance
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchUserData();
  }

  // Future fetchUserData() async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((v) {
  //     var data = v.data();
  //     setState(() {
  //       userBalance = data!['amount'];
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final cryptosRef = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .collection("cryptos");

    return StreamBuilder<QuerySnapshot>(
      stream: cryptosRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return Text(
            "No crypto data found.",
            style: TextStyle(color: white),
          );
        }

        // final cryptoDoc = snapshot.data!.docs.first;
        // final docId = cryptoDoc.id;
        // final cryptos = cryptoDoc.get("cryptos") as Map<String, dynamic>;

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {}); // Triggers rebuild and refetch
          },
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: snapshot.data!.docs.map((cryptoDoc) {
              final symbol = cryptoDoc.id;
              final price = cryptoDoc['amount'];
              final cryptoValue = cryptoDoc['cryptoValue'];
              final usdValue = cryptoDoc['usdValue'];

              return FutureBuilder<String?>(
                future: fetchCoinLogo(symbolToCoinGeckoId[symbol]!),
                builder: (context, snapshot) {
                  final logoUrl = snapshot.data;
                  final coinUsdPrice = 22.0;
                  return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      leading: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: logoUrl != null
                            ? Image.network(
                                logoUrl,
                                width: 40,
                                height: 40,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.currency_bitcoin),
                              )
                            : Icon(
                                Icons.currency_bitcoin,
                                color: amber,
                              ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            symbol,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                " \$${price ?? '--'}  ",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: fWLargeFont,
                                  fontSize: kTextSmaller,
                                ),
                              ),
                              Text(
                                "${_getRandomPercentageChange()}%",
                                style: TextStyle(
                                  color:
                                      _getRandomColorForPercentage(), // Green/Red based on +/-
                                  fontWeight: fWLargeFont,
                                  fontSize: kTextMini,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // trailing: FutureBuilder<double?>(
                      //   future:
                      //       fetchUsdToCryptoRate(symbolToCoinGeckoId[symbol]!),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return SizedBox(
                      //         height: 40,
                      //         width: 40,
                      //         child: CircularProgressIndicator(
                      //           strokeWidth: 0.6,
                      //           color: amber,
                      //         ),
                      //       ); // Show loading spinner until data is fetched
                      //     }
                      //
                      //     final usdToCryptoRate = snapshot.data;
                      //     final convertedCryptoAmount = usdToCryptoRate != null
                      //         ? (value * usdToCryptoRate)
                      //         : 0.0;
                      //
                      //     return Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.end,
                      //       children: [
                      //         Text(
                      //           "\$${convertedCryptoAmount.toStringAsFixed(2)}",
                      //           style: TextStyle(
                      //             fontWeight: fWLargeFont,
                      //             color: white,
                      //             fontSize: kTextLarge,
                      //           ),
                      //         ),
                      //         Text(
                      //           "${entry.value}",
                      //           style: TextStyle(
                      //             color: Colors.grey.shade600,
                      //             fontSize: kTextMini,
                      //             fontWeight: fWLargeFont,
                      //           ),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // ),

                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatCurrency(usdValue),
                            style: TextStyle(
                              fontWeight: fWLargeFont,
                              color: white,
                              fontSize: kTextLarge,
                            ),
                          ),
                          Text(
                            "$cryptoValue",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: kTextMini,
                              fontWeight: fWLargeFont,
                            ),
                          ),
                        ],
                      ));
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _editCryptoDialog(BuildContext context, String userId, String docId,
      String symbol, dynamic value) {
    final controller = TextEditingController(text: value.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Update $symbol"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: "New Value"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newVal = double.tryParse(controller.text.trim());
              if (newVal != null) {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(userId)
                    .collection("cryptos")
                    .doc(docId)
                    .update({
                  "cryptos.$symbol": newVal,
                });
              }
              Navigator.pop(ctx);
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(value);
  }
}
