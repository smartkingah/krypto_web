import 'package:flutter/material.dart';
import '../../../Utils/color/color.dart';
import '../../../Utils/dimens.dart';
import '../../../providers/general_provider.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///circular
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(
              Icons.person,
              color: Colors.grey[200],
            ),
          ),

          ///names
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Text(
                      'Hey ',
                      style: TextStyle(
                        color: Colors.grey,
                        height: 1,
                        fontSize: kTextMini,
                      ),
                    ),
                    Image.network('images/wave.png', scale: 5)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 2),
                child: Container(
                  width: 200,
                  color: Colors.transparent,
                  child: Text(
                    getStorage.read('fullName'),
                    maxLines: 1,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: fWLargeFont,
                      color: white,
                      fontSize: kTextSmaller,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
