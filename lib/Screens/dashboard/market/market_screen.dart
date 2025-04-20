import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../Mobile_widgets/local_widgets/mobile_footer.dart';
import '../../../Reponsive/dimensions.dart';
import '../../../Utils/color/color.dart';
import '../../../Utils/dimens.dart';
import '../../../Widgets/footer_page.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  List<dynamic> cryptoData = [];

  @override
  void initState() {
    super.initState();
    fetchCryptoData();
  }

  Future<void> fetchCryptoData() async {
    final response = await http.get(
      Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=25&page=1&sparkline=true'),
    );

    if (response.statusCode == 200) {
      setState(() {
        cryptoData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFF141416),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
        child: cryptoData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),

                  ///firstimage
                  width < mobileWidth
                      ? SizedBox()
                      : Image.network('images/1.png'),
                  width < mobileWidth ? SizedBox() : SizedBox(height: 15),
                  width < mobileWidth
                      ? SizedBox()
                      : Image.network('images/2.png'),
                  SizedBox(height: 15),
                  width < mobileWidth
                      ? Image.network('images/mobile/market.png')
                      : SizedBox(),

                  ///title
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Market',
                      style: TextStyle(
                        color: white,
                        fontWeight: fWLargeFont,
                        fontSize: kTextLarge,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  ///market cont
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: DataTable(
                          columnSpacing: 180,
                          dividerThickness: 0.2,
                          decoration: BoxDecoration(),
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Color(0xFF18191D)),
                          columns: [
                            DataColumn(
                                label: Text("Pair",
                                    style: TextStyle(color: Colors.white))),
                            DataColumn(
                                label: Text("Price",
                                    style: TextStyle(color: Colors.white))),
                            DataColumn(
                                label: Text("24h Change",
                                    style: TextStyle(color: Colors.white))),
                            DataColumn(
                                label: Text("Market Cap",
                                    style: TextStyle(color: Colors.white))),
                            DataColumn(
                                label: Text("24h Volume",
                                    style: TextStyle(color: Colors.white))),
                          ],
                          rows: cryptoData.map((crypto) {
                            return DataRow(cells: [
                              DataCell(Row(
                                children: [
                                  CachedNetworkImage(
                                      imageUrl: crypto['image'], width: 24),
                                  SizedBox(width: 8),
                                  Text("${crypto['symbol'].toUpperCase()}/USDT",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              )),
                              DataCell(Text("\$${crypto['current_price']}",
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text(
                                "${crypto['price_change_percentage_24h'].toStringAsFixed(2)}%",
                                style: TextStyle(
                                    color:
                                        crypto['price_change_percentage_24h'] >=
                                                0
                                            ? Colors.green
                                            : Colors.red),
                              )),
                              DataCell(Text("\$${crypto['market_cap']}",
                                  style: TextStyle(color: Colors.white))),
                              DataCell(Text("\$${crypto['total_volume']}",
                                  style: TextStyle(color: Colors.white))),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  ///footer
                  width < mobileWidth ? MobileFooterPage() : FooterPage(),
                ],
              ),
      ),
    );
  }
}
