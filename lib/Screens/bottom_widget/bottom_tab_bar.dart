import 'package:Cryptousd/Mobile_widgets/local_widgets/mobile_support.dart';
import 'package:Cryptousd/Screens/dashboard/support_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Mobile_widgets/mobile_dashboard/deposit_wallet_screen.dart';
import '../../Mobile_widgets/mobile_dashboard/mobile_dashboard_page.dart';
import '../../Mobile_widgets/mobile_dashboard/swap_wallet_screen.dart';
import '../../Mobile_widgets/transfer_screen.dart';
import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import '../dashboard/dashboard_page.dart';

class BottomTabBar extends StatefulWidget {
  const BottomTabBar({super.key});

  @override
  State<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  List<Widget> screens = [
    MobileDashBoardPage(fromPage: 'home'),
    TransferScreen(fromPage: 'home'),
    DepositWalletScreen(fromPage: 'home'),
    SwapWalletScreen(fromPage: 'home'),
    MobileSupportPage(fromPage: 'home'),
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF161719),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF161719),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF161719), // <-- Add this line
          selectedItemColor: amber,
          unselectedItemColor: Colors.grey,
          currentIndex: currentIndex,
          iconSize: kTextSmallHigh,
          type: BottomNavigationBarType.fixed,
          onTap: (v) {
            setState(() {
              currentIndex = v;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_downward),
              label: 'Transfer',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.creditcard),
              label: 'Deposit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              label: 'Swap',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outline),
              label: 'Support',
            )
          ],
        ),
      ),
    );
  }
}
