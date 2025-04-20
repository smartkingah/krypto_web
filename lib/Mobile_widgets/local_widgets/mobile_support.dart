import 'package:flutter/material.dart';
import '../../Widgets/footer_page.dart';
import 'mobile_footer.dart';

class MobileSupportPage extends StatefulWidget {
  const MobileSupportPage({super.key});

  @override
  State<MobileSupportPage> createState() => _MobileSupportPageState();
}

class _MobileSupportPageState extends State<MobileSupportPage> {
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
        MobileFooterPage(),
      ],
    );
  }
}
