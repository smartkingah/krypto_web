import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/customeAppBar.dart';
import '../Widgets/login_body.dart';
import '../Widgets/price_ticker.dart';
import '../providers/general_provider.dart';
import 'dashboard/community_page.dart';
import 'dashboard/dashboard_page.dart';
import 'dashboard/faq_page.dart';
import 'dashboard/history_page.dart';
import 'dashboard/kyc_page.dart';
import 'dashboard/market/market_screen.dart';
import 'dashboard/settings_page.dart';
import 'dashboard/support_page.dart';
import 'landing_page/landing_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<GeneralProvider>(context, listen: false);
    var isLoggedIn = getStorage.read('authState');
    return Scaffold(
      appBar: CustomAppbar(context: context),
      body: Column(
        children: [
          const PriceTicker(),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                bg(),
                Consumer<GeneralProvider>(
                  builder: (context, prov, _) {
                    if (prov.page == "support") return SupportPage();
                    if (prov.page == "faq") return FaqPage();
                    if (prov.page == "market") return MarketScreen();
                    if (prov.page == "community") return CommunityPage();
                    if (prov.page == "history") return HistoryPage();
                    if (prov.page == "kyc") return KycPage();
                    if (prov.page == "settings") return SettingsPage();
                    if (prov.page == "loginPage") return LoginSignUpBody();
                    if (isLoggedIn || prov.page == "dashBoardPage") return DashboardPage();
                    return LandingPage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // persistentFooterButtons: [
      //   Text('apkaniko'),
      // ],
    );
  }

  Widget bg() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage('images/bg.png'),
        ),
      ),
    );
  }
}
