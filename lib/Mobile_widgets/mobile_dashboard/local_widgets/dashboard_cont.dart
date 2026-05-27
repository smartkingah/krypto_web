import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../Utils/color/color.dart';
import '../../../Utils/dimens.dart';
import '../../../providers/general_provider.dart';

class DashboardCont extends StatefulWidget {
  const DashboardCont({super.key});

  @override
  State<DashboardCont> createState() => _DashboardContState();
}

class _DashboardContState extends State<DashboardCont> {
  List balanceList = [];
  bool obscure = false;
  String userBalance = '0.0'; // e.g. 200.0

  Future<void> updateUserBalance() async {
    final cryptosRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cryptos');

    final cryptosSnapshot = await cryptosRef.get();

    double totalBalance = 0.0;

    for (var cryptoDoc in cryptosSnapshot.docs) {
      final rawUsdValue = cryptoDoc['usdValue'];

      // Convert to double safely
      double usdValue = 0.0;
      if (rawUsdValue is String) {
        usdValue = double.tryParse(rawUsdValue) ?? 0.0;
      } else if (rawUsdValue is num) {
        usdValue = rawUsdValue.toDouble();
      }

      totalBalance += usdValue;
    }

    setState(() {
      userBalance = totalBalance.toString();
      Provider.of<GeneralProvider>(context, listen: false)
          .setUserBalance(data: userBalance);
      print(
          "userBalace=========================---------===========> ${Provider.of<GeneralProvider>(context, listen: false).setUserBalance(data: userBalance)}");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUserBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: amber,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage('images/mobile/cardcont.png'),
            ),
          ),
        ),

        ///balance cont
        Positioned(
          top: 20,
          left: 10,
          child: balanceCont(),
        ),
      ],
    );
  }

  Widget balanceCont() {
    final currencyFormatter =
        NumberFormat.currency(locale: "en_US", symbol: "\$");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Balance total ',
                style: TextStyle(
                  color: Color(0xFF353945),
                  fontWeight: fWSmallFont,
                  fontSize: kTextLarge,
                ),
              ),

              ///visibility
              GestureDetector(
                onTap: () {
                  // updateUserBalance();
                  setState(() {
                    obscure = !obscure;
                  });
                },
                child: Icon(
                  !obscure ? Icons.visibility_off : Icons.visibility,
                  size: kTextLarge,
                  color: Color(0xFF353945),
                ),
              )
            ],
          ),
          Text(
            obscure ? formatCurrencyFromString(userBalance) : "******* ",
            style: TextStyle(
              color: Color(0xFF353945),
              fontWeight: fWxxLargeFont,
              fontSize: kTextXxLarge,
            ),
          ),
        ],
      ),
    );
  }
}

String formatCurrencyFromString(String value) {
  try {
    final number = double.parse(value);
    final formatter = NumberFormat.currency(symbol: '\$ ', decimalDigits: 2);
    return formatter.format(number);
  } catch (e) {
    return value; // fallback if parsing fails
  }
}
