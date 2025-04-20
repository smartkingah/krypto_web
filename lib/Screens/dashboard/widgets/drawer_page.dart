import 'package:flutter/material.dart';

import 'crypto_assets.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey.shade300,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.network('images/dashB.png'),
            SizedBox(height: 10),
            AssetsListScreen(),
          ],
        ),
      ),
    );
  }
}
