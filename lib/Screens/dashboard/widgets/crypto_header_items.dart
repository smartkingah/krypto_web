import 'package:Cryptousd/Screens/dashboard/widgets/search_and_others.dart';
import 'package:flutter/cupertino.dart';

class CryptoHeaderItems extends StatelessWidget {
  const CryptoHeaderItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SearchFilterBar(),
        ],
      ),
    );
  }
}
