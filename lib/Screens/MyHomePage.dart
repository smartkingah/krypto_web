import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/customeAppBar.dart';
import '../Widgets/login_body.dart';
import '../providers/general_provider.dart';
import 'admin_page/adminPage.dart';
import 'dashboard/dashboard_page.dart';
import 'dashboard/faq_page.dart';
import 'dashboard/market/market_screen.dart';
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
      body: Stack(
        alignment: Alignment.center,
        children: [
          bg(),
          // prov.page == "landingPage"
          //     ? LandingPage()
          //     :
          prov.page == "support"
              ? SupportPage()
              : prov.page == "faq"
                  ? FaqPage()
                  : prov.page == "market"
                      ? MarketScreen()
                      : isLoggedIn
                          ? DashboardPage()
                          : prov.page == "loginPage"
                              ? LoginSignUpBody()
                              : prov.page == "dashBoardPage"
                                  ? DashboardPage()
                                  : LandingPage(),
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
