import 'package:Cryptousd/Widgets/tField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/color/color.dart';
import '../Utils/dimens.dart';
import '../providers/general_provider.dart';

class SubscriptionCont extends StatefulWidget {
  const SubscriptionCont({super.key});

  @override
  State<SubscriptionCont> createState() => _SubscriptionContState();
}

class _SubscriptionContState extends State<SubscriptionCont> {
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<GeneralProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      color: amber,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tCont(),
              Spacer(),

              ///email to login
              SizedBox(
                width: 250,
                child: Tfield(
                  contr: emailController,
                  preIcon: Icon(Icons.email),
                  title: 'Email',
                  hint: 'jaykong@gmail.com',
                  suffixIcon: SizedBox(),
                ),
              ),

              ///signup button
              GestureDetector(
                onTap: () {
                  prov.setPage(data: 'loginPage');
                },
                child: Container(
                  // height: 80,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  margin: EdgeInsets.only(left: 20, right: 30),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: black,
                      fontWeight: fWLargeFont,
                      fontSize: kTextSmall,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  tCont() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Stay Updated with Krypto Market',
          style: TextStyle(
            color: black,
            fontSize: kTextSmall,
            fontWeight: fWxLargeFont,
          ),
        ),
        Text(
          'Subscribe to our newsletter for the latest updates, market insights, and exclusive offers.',
          style: TextStyle(
            color: black,
            fontSize: kTextTinyHigh,
            fontWeight: fWLargeFont,
          ),
        ),
      ],
    );
  }
}
