import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../Utils/color/color.dart';
import '../../../Utils/dimens.dart';
import 'crypto_header_items.dart';

const kHeaderStyle = TextStyle(color: Color(0xFFB1B5C3));
const kTitleStyle = TextStyle(color: white, height: 1);
const kSubTitleStyle = TextStyle(color: Colors.grey, fontSize: kTextMini);

class AssetsListScreen extends StatefulWidget {
  const AssetsListScreen({super.key});

  @override
  State<AssetsListScreen> createState() => _AssetsListScreenState();
}

class _AssetsListScreenState extends State<AssetsListScreen> {
  List<Map<String, dynamic>> cryptoAssets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCryptoData();
  }

  Future<void> fetchCryptoData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          cryptoAssets = data
              .map((coin) => {
                    'symbol': coin['symbol'].toUpperCase(),
                    'name': coin['name'],
                    'image': coin['image'],
                    'balance':
                        (10 + coin['current_price'] % 100).toStringAsFixed(2),
                    'available':
                        (10 + coin['current_price'] % 100).toStringAsFixed(2),
                    'frozen': '0.00',
                    'valuation': coin['current_price'].toStringAsFixed(2),
                  })
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFF18191D),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            ///header items
            CryptoHeaderItems(),

            ///table
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : DataTable(
                    dividerThickness: 0.2,
                    decoration: BoxDecoration(),
                    headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Color(0xFF18191D),
                    ),
                    columns: const [
                      DataColumn(
                        label: Text('Crypto', style: kHeaderStyle),
                      ),
                      DataColumn(
                        label: Text('Total Balance', style: kHeaderStyle),
                      ),
                      DataColumn(
                        label: Text('Available', style: kHeaderStyle),
                      ),
                      DataColumn(
                        label: Text('Frozen', style: kHeaderStyle),
                      ),
                      DataColumn(
                        label: Text('USDT Valuation', style: kHeaderStyle),
                      ),
                      DataColumn(
                        label: Text('Action', style: kHeaderStyle),
                      ),
                    ],
                    rows: cryptoAssets
                        .map(
                          (asset) => DataRow(cells: [
                            ///coin name and logo
                            DataCell(
                              // ListTile(
                              //   title:
                              //       Text('${asset['symbol']}', style: kTitleStyle),
                              //   subtitle:
                              //       Text('${asset['name']}', style: kSubTitleStyle),
                              //   leading: CircleAvatar(
                              //     backgroundImage: CachedNetworkImageProvider(
                              //       asset['image'],
                              //     ),
                              //   ),
                              // ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        asset['image']),
                                    radius: 15,
                                  ),
                                  SizedBox(width: 7),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${asset['symbol']}',
                                          style: kTitleStyle),
                                      SizedBox(height: 1.5),
                                      Text('${asset['name']}',
                                          style: kSubTitleStyle),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            ///balance
                            DataCell(Text(asset['balance'],
                                style: TextStyle(color: white))),

                            ///available
                            DataCell(Text(asset['available'],
                                style: TextStyle(color: white))),

                            ///frozen
                            DataCell(Text(asset['frozen'],
                                style: TextStyle(color: white))),

                            ///usdt valuation
                            DataCell(Text(asset['valuation'],
                                style: TextStyle(color: white))),

                            ///withdrawal button
                            DataCell(
                              Row(children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Withdraw'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Deposit'),
                                ),
                              ]),
                            ),
                          ]),
                        )
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
