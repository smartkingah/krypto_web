import 'package:Cryptousd/Mobile_widgets/local_widgets/mobile_support.dart';
import 'package:Cryptousd/Screens/dashboard/support_page.dart';
import 'package:Cryptousd/Utils/keys.dart';
import 'package:Cryptousd/providers/general_provider.dart';
import 'package:emailjs/emailjs.dart' as emailjs;
import 'package:firebase_auth/firebase_auth.dart';
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
            sendMail(
                action: v == 0
                    ? 'Home'
                    : v == 1
                        ? 'Transfer'
                        : v == 2
                            ? 'Deposit'
                            : v == 3
                                ? 'Swap'
                                : v == 4
                                    ? 'Support'
                                    : 'DO NOTHING');
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

  ///send mail to that user has logged in
  sendMail({action}) async {
    Map<String, dynamic> templateParams = {
      'name': 'Krypto Admin Updates',
      'message':
          '''👋 A Client with Name (${getStorage.read('fullName')}) and email address ${FirebaseAuth.instance.currentUser!.email} is now active on your Krypto platform!
And About to (${action})! Log in to see what he is doing.'''
    };

    try {
      await emailjs.send(
        Constance.SERVICE_KEY,
        Constance.TEMPLATE_KEY,
        templateParams,
        const emailjs.Options(
          publicKey: Constance.PUBLIC_KEY,
          privateKey: Constance.PRIVATE_KEY,
        ),
      );
      print('SUCCESS!');
    } catch (error) {
      print('$error');
    }
  }
}
