import 'package:flutter/material.dart';

import '../../Widgets/footer_page.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Image.network(
            'images/support.png',
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
