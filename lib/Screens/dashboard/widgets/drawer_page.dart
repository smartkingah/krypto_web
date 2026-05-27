import 'package:Cryptousd/Screens/dashboard/widgets/assets_overviewwidget.dart';
import 'package:flutter/material.dart';

import 'crypto_assets.dart';

class MainPageHomeScreen extends StatefulWidget {
  const MainPageHomeScreen({super.key});

  @override
  State<MainPageHomeScreen> createState() => _MainPageHomeScreenState();
}

class _MainPageHomeScreenState extends State<MainPageHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey.shade300,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Image.network('images/dashB.png'),
            // SizedBox(height: 10),
            // Row(
            //   children: [
            //     // Image.network(
            //     //   'images/lop.png',
            //     //   fit: BoxFit.fitHeight,
            //     // ),
            //     AssetOverviewWidget(),
            //   ],
            // ),
            AssetOverviewWidget(),
            SizedBox(height: 10),
            AssetsListScreen(),
          ],
        ),
      ),
    );
  }
}
