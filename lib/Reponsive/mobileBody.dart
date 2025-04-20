import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Mobile_widgets/local_widgets/mobile_faq.dart';
import '../Mobile_widgets/local_widgets/mobile_support.dart';
import '../Mobile_widgets/mobile_appBar.dart';
import '../Mobile_widgets/mobile_dashboard/mobile_dashboard_page.dart';
import '../Mobile_widgets/mobile_drawer.dart';
import '../Mobile_widgets/mobile_landing_page.dart';
import '../Mobile_widgets/mobile_login_signup_page.dart';
import '../Screens/bottom_widget/bottom_tab_bar.dart';
import '../Screens/dashboard/dashboard_page.dart';
import '../Screens/dashboard/faq_page.dart';
import '../Screens/dashboard/market/market_screen.dart';
import '../Screens/dashboard/support_page.dart';
import '../Screens/landing_page/landing_page.dart';
import '../Widgets/customeAppBar.dart';
import '../Widgets/login_body.dart';
import '../providers/general_provider.dart';

class MobileBody extends StatefulWidget {
  const MobileBody({super.key});

  @override
  State<MobileBody> createState() => _MobileBodyState();
}

class _MobileBodyState extends State<MobileBody> {
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<GeneralProvider>(context, listen: false);
    var isLoggedIn = getStorage.read('authState');
    return Scaffold(
      appBar: mobileCustomAppbar(context: context),
      endDrawer: mobileDrawer(context: context),
      body: Stack(
        alignment: Alignment.center,
        children: [
          bg(),
          prov.page == "support"
              ? MobileSupportPage()
              : prov.page == "faq"
                  ? MobileFaq()
                  : prov.page == "market"
                      ? MarketScreen()
                      : isLoggedIn
                          ? BottomTabBar()
                          : prov.page == "loginPage"
                              ? MobileLoginSignUpBody()
                              : prov.page == "dashBoardPage"
                                  ? BottomTabBar()
                                  : MobileLandingPage(),
        ],
      ),
    );
  }

  Widget bg() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
          image: NetworkImage('images/bg.png'),
        ),
      ),
    );
  }
}
