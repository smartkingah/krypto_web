import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/color/color.dart';
import '../Utils/dimens.dart';
import '../providers/general_provider.dart';
import '../services/auth_services.dart';

AppBar CustomAppbar({context}) {
  var prov = Provider.of<GeneralProvider>(context);
  var isLoggedIn = getStorage.read('authState');
  return AppBar(
    backgroundColor: Color(0xFF18191c),
    title: Row(
      children: [
        logoCont(context, isLoggedIn),
        textBar(
          title: 'Home',
          color: prov.page == 'landingPage'
              ? amber
              : prov.page == 'dashBoardPage'
                  ? amber
                  : white,
          onTap: () {
            isLoggedIn
                ? prov.setPage(data: 'dashBoardPage')
                : prov.setPage(data: 'landingPage');
          },
        ),
        isLoggedIn
            ? textBar(
                title: 'Market',
                color: prov.page == 'market' ? amber : white,
                onTap: () {
                  prov.setPage(data: 'market');
                },
              )
            : SizedBox(),
        textBar(
          title: 'FAQ',
          color: prov.page == 'faq' ? amber : white,
          onTap: () {
            prov.setPage(data: 'faq');
          },
        ),
        // support
        textBar(
          title: 'Support',
          color: prov.page == 'support' ? amber : white,
          onTap: () {
            prov.setPage(data: 'support');
          },
        ),
        textBar(title: 'Community', color: white),
      ],
    ),
    actions: isLoggedIn
        ? [
            Text(
              MediaQuery.of(context).size.width.toString(),
              style: TextStyle(color: white),
            ),

            ///search item
            GestureDetector(
              onTap: () async {
                await AuthService().signOut(context: context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(
                  "images/search.png",
                  scale: 2,
                ),
              ),
            ),
            SizedBox(width: 10),

            ///web icon
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                "images/web.png",
                scale: 4,
              ),
            ),
            SizedBox(width: 15),

            ///wallet
            Icon(Icons.wallet, color: Colors.white),
            SizedBox(width: 15),

            ///notification
            Icon(Icons.notifications_none_rounded, color: Colors.white),
            SizedBox(width: 15),

            ///circular
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                color: Colors.grey[200],
              ),
            ),
            SizedBox(width: 30),
          ]
        : [
            Text(
              MediaQuery.of(context).size.width.toString(),
              style: TextStyle(color: white),
            ),

            ///search item
            GestureDetector(
              onTap: () async {
                await AuthService().signOut(context: context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(
                  "images/search.png",
                  scale: 2,
                ),
              ),
            ),

            ///web icon
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                "images/web.png",
                scale: 4,
              ),
            ),

            prov.page == "loginPage"
                ? SizedBox.shrink()
                : Row(
                    children: [
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          prov.setPage(data: 'loginPage');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: white,
                            fontWeight: fWLargeFont,
                            fontSize: kTextSmall,
                          ),
                        ),
                      ),

                      ///signup button
                      GestureDetector(
                        onTap: () {
                          prov.setPage(data: 'loginPage');
                        },
                        child: Container(
                          // height: 80,
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          margin: EdgeInsets.only(left: 20, right: 30),
                          decoration: BoxDecoration(
                            color: amber,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: black,
                              fontWeight: fWLargeFont,
                              fontSize: kTextSmall,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
          ],
  );
}

///text in bar
Widget textBar({title, color, onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: kTextSmaller,
        ),
      ),
    ),
  );
}

///logo
Widget logoCont(context, isLoggedIn) {
  var prov = Provider.of<GeneralProvider>(context);
  return GestureDetector(
    onTap: () {
      isLoggedIn
          ? prov.setPage(data: 'dashBoardPage')
          : prov.setPage(data: 'landingPage');
    },
    child: Container(
      height: 200,
      width: 180,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Image.network(
        "images/logo1.png",
        scale: 2,
      ),
    ),
  );
}
