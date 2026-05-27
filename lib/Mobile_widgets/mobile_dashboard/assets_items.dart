import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import 'assets_items_cont.dart';

class AssetsItems extends StatefulWidget {
  const AssetsItems({super.key});

  @override
  State<AssetsItems> createState() => _AssetsItemsState();
}

class _AssetsItemsState extends State<AssetsItems> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        bg(),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
            children: [
              header(),
              AssetsItemsCont(
                userId: FirebaseAuth.instance.currentUser!.uid,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Assets',
            style: TextStyle(
              color: white,
              fontWeight: fWxLargeFont,
              fontSize: kTextLarge,
            ),
          ),
          Text(
            'See All',
            style: TextStyle(
              color: amber,
              fontWeight: fWLargeFont,
            ),
          ),
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
          image: NetworkImage('images/bggg.png'),
        ),
      ),
    );
  }
}
