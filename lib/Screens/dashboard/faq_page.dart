import 'package:flutter/material.dart';

import '../../Widgets/footer_page.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
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
        FooterPage(),
      ],
    );
  }
}
