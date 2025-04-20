import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Widgets/customeAppBar.dart';
import '../../Widgets/footer_page.dart';
import '../../Widgets/subCont.dart';
import 'local_widgets/mobile_footer.dart';
import 'local_widgets/mobile_sub_cont.dart';
import '../providers/general_provider.dart';

class MobileLandingPage extends StatefulWidget {
  const MobileLandingPage({super.key});

  @override
  State<MobileLandingPage> createState() => _MobileLandingPageState();
}

class _MobileLandingPageState extends State<MobileLandingPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 20),

        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width / 20),
          child: Image.network(
            filterQuality: FilterQuality.low,
            'images/mobile/ld1.png',
            scale: 1,
          ),
        ),

        ///item counts
        GestureDetector(
          onTap: () {
            Provider.of<GeneralProvider>(context, listen: false)
                .setPage(data: 'loginPage');
          },
          child: Container(
            // height: 70,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: Image.network(
              filterQuality: FilterQuality.low,
              'images/mobile/2.png',
              scale: 1,
            ),
          ),
        ),
        SizedBox(height: 50),

        ///partners
        Container(
          // height: 70,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Image.network(
            filterQuality: FilterQuality.low,
            'images/mobile/20.png',
            scale: 1.6,
          ),
        ),

        ///features
        cont(img: '1'),

        cont(img: '5'),

        cont(img: '6'),

        cont(img: '7'),

        Container(
          margin: EdgeInsets.only(top: 20),
          // height: 70,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Image.network(
            'images/mobile/9.png',
            scale: 1.6,
          ),
        ),

        ///
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          // height: 70,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Image.network(
            'images/mobile/8.png',
            filterQuality: FilterQuality.low,
            scale: 1.6,
          ),
        ),

        cont(img: '12'),

        cont(img: '14'),

        cont(img: '13'),

        cont(img: '15'),

        GestureDetector(
          onTap: () {
            Provider.of<GeneralProvider>(context, listen: false)
                .setPage(data: 'loginPage');
          },
          child: Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            // height: 70,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: Image.network(
              filterQuality: FilterQuality.low,
              'images/mobile/16.png',
              scale: 1.6,
            ),
          ),
        ),

        ///sub cont
        MobileSubscriptionCont(),

        ///footer
        MobileFooterPage(),
      ],
    );
  }

  Widget cont({img}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 120.0,
        right: 120,
        top: 20,
        bottom: 20,
      ),
      child: Image.network(
        'images/mobile/$img.png',
        filterQuality: FilterQuality.low,
      ),
    );
  }
}
