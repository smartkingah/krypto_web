import 'package:flutter/material.dart';
import '../Utils/color/color.dart';
import '../Utils/dimens.dart';

class FooterPage extends StatefulWidget {
  const FooterPage({super.key});

  @override
  State<FooterPage> createState() => _FooterPageState();
}

class _FooterPageState extends State<FooterPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: MediaQuery.of(context).size.width,
      color: Color(0xFF18191D),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    padding: EdgeInsets.only(bottom: 12),
                    color: Colors.transparent,
                    height: 120,
                    width: 120,
                    child: Center(child: Image.network('images/ft.png'))),
                SizedBox(width: 60),
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
          SizedBox(height: 20),
          Text(
            '© 2024 Krypto. All Rights Reserved.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: kTextTiny,
            ),
          )
        ],
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
