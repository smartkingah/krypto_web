import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';

class MobileFooterPage extends StatefulWidget {
  const MobileFooterPage({super.key});

  @override
  State<MobileFooterPage> createState() => _MobileFooterPageState();
}

class _MobileFooterPageState extends State<MobileFooterPage> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Color(0xFF18191D),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                contItem(
                                  title1: 'Explore',
                                  title2: 'Markets',
                                  title3: 'Spot',
                                  title4: 'Join FalconX',
                                ),
                                contItem(
                                  title1: 'Blog',
                                  title2: 'Articles',
                                  title3: 'Videos',
                                  title4: 'Podcast',
                                ),
                                contItem(
                                  title1: 'Support',
                                  title2: 'Customer Support',
                                  title3: 'Tickets',
                                  title4: 'FAQs',
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                contItem(
                                  title1: 'About us',
                                  title2: 'About FalconX',
                                  title3: 'Careers',
                                  title4: 'Contact Us',
                                ),
                                contItem(
                                  title1: 'Legal',
                                  title2: 'Privacy Policy',
                                  title3: 'Use Agreement',
                                  title4: 'Cookie Policy',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///
                  Column(
                    children: [
                      Image.network(
                        height: 60,
                        width: 120,
                        'images/logo1.png',
                        filterQuality: FilterQuality.low,
                        scale: 20,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Trade Smarter, Grow faster',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: fWxxLargeFont,
                          fontSize: kTextSmall,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 100,
                            color: Colors.transparent,
                            child: Image.network(
                              height: 200,

                              'images/socials.png',
                              filterQuality: FilterQuality.low,
                              // scale: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0),
              child: Image.network('images/mobile/19.png'),
            ),
            SizedBox(height: 20),
            Text(
              '© 2024 Cryptousd. All Rights Reserved.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: kTextTiny,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  contItem({
    title1,
    title2,
    title3,
    title4,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title1,
          style: TextStyle(
            color: white,
            fontWeight: fWxxLargeFont,
            fontSize: kTextSmall,
          ),
        ),
        SizedBox(height: 10),
        Text(
          title2,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: fWLargeFont,
            fontSize: kTextMini,
          ),
        ),
        SizedBox(height: 10),
        Text(
          title3,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: fWLargeFont,
            fontSize: kTextMini,
          ),
        ),
        SizedBox(height: 10),
        Text(
          title4,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: fWLargeFont,
            fontSize: kTextMini,
          ),
        ),
      ],
    );
  }
}
