import 'package:flutter/material.dart';

import '../../Widgets/customeAppBar.dart';
import '../../Widgets/footer_page.dart';
import '../../Widgets/subCont.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.only(left: 100.0),
          child: Image.network(
            'images/la.png',
            scale: 5.4,
          ),
        ),

        ///item counts
        Container(
          // height: 70,
          width: MediaQuery.of(context).size.width,
          color: Colors.purple,
          child: Image.network(
            'images/ex.png',
            scale: 1,
          ),
        ),
        SizedBox(height: 50),

        ///partners
        Container(
          // height: 70,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Image.network(
            'images/pa.png',
            scale: 5.5,
          ),
        ),

        ///features
        Padding(
          padding: const EdgeInsets.only(
            left: 120.0,
            right: 120,
            top: 50,
            bottom: 50,
          ),
          child: Image.network('images/features.png'),
        ),

        ///reviews
        Padding(
          padding: const EdgeInsets.only(
            left: 120.0,
            right: 120,
            top: 50,
            bottom: 50,
          ),
          child: Image.network('images/review.png'),
        ),

        ///trust
        Padding(
          padding: const EdgeInsets.only(
            left: 120.0,
            right: 120,
            top: 50,
            bottom: 50,
          ),
          child: Image.network('images/trust.png'),
        ),

        ///phone
        Padding(
          padding: const EdgeInsets.only(
            left: 120.0,
            right: 120,
            top: 50,
            bottom: 50,
          ),
          child: Image.network('images/phone.png'),
        ),

        ///faq
        Padding(
          padding: const EdgeInsets.only(
            left: 120.0,
            right: 120,
            top: 50,
            bottom: 50,
          ),
          child: Image.network('images/faq.png'),
        ),

        ///sub cont
        SubscriptionCont(),

        ///footer
        FooterPage(),
      ],
    );
  }
}
