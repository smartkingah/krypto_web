import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import '../../Widgets/tField.dart';
import '../../providers/general_provider.dart';

class MobileSubscriptionCont extends StatefulWidget {
  const MobileSubscriptionCont({super.key});

  @override
  State<MobileSubscriptionCont> createState() => _MobileSubscriptionContState();
}

class _MobileSubscriptionContState extends State<MobileSubscriptionCont> {
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<GeneralProvider>(context);
    return IntrinsicHeight(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 180,
        color: amber,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              tCont(),
              // Spacer(),

              ///email to login
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      color: Colors.green,
                      width: 250,
                      alignment: Alignment.centerLeft,
                      child: Tfield(
                        hor: 0,
                        contr: emailController,
                        preIcon: Icon(Icons.email),
                        title: 'Email',
                        hint: 'jaykong@gmail.com',
                        suffixIcon: SizedBox(),
                      ),
                    ),

                    SizedBox(width: 30),

                    ///signup button
                    GestureDetector(
                      onTap: () {
                        prov.setPage(data: 'loginPage');
                      },
                      child: Container(
                        // height: 80,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),

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
          'News Letter',
          style: TextStyle(
            color: black,
            fontSize: kTextSmall,
            fontWeight: fWxLargeFont,
          ),
        ),
        Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width / 1.2,
          child: Text(
            'Subscribe to our newsletter for the latest updates, market insights, and exclusive offers.',
            style: TextStyle(
              color: black,
              fontSize: kTextTinyHigh,
              fontWeight: fWLargeFont,
            ),
          ),
        ),
      ],
    );
  }
}
