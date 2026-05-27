import 'package:flutter/material.dart';

import 'mobile_footer.dart';

class MobileFaq extends StatefulWidget {
  const MobileFaq({super.key});

  @override
  State<MobileFaq> createState() => _MobileFaqState();
}

class _MobileFaqState extends State<MobileFaq> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Image.network(
            'images/faq1.png',
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 10),

        ///footer
        MobileFooterPage(),
      ],
    );
  }
}
