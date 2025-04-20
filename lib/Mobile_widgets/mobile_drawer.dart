import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/color/color.dart';
import '../Utils/dimens.dart';
import '../providers/general_provider.dart';
import '../services/auth_services.dart';

Widget mobileDrawer({context}) {
  var prov = Provider.of<GeneralProvider>(context);
  var isLoggedIn = getStorage.read('authState');
  return Drawer(
      child: Stack(
    alignment: Alignment.topRight,
    children: [
      bg(context),
      Builder(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _logoCont(),

            ///
            _listCont(
              onTap: () {
                isLoggedIn
                    ? prov.setPage(data: 'dashBoardPage')
                    : prov.setPage(data: 'landingPage');
                Scaffold.of(context).closeEndDrawer();
              },
              title: 'Home',
              icon: Icons.home,
            ),

            ///
            isLoggedIn
                ? _listCont(
                    onTap: () {
                      prov.setPage(data: 'market');
                      Scaffold.of(context).closeEndDrawer();
                    },
                    title: 'Market',
                    icon: CupertinoIcons.cart,
                  )
                : SizedBox(),

            ///
            _listCont(
                title: 'FAQ',
                icon: Icons.question_answer,
                onTap: () {
                  prov.setPage(data: 'faq');
                  Scaffold.of(context).closeEndDrawer();
                }),

            ///
            _listCont(
              onTap: () {
                prov.setPage(data: 'support');
                Scaffold.of(context).closeEndDrawer();
              },
              title: 'Support',
              icon: Icons.support_agent,
            ),

            SizedBox(height: 10),

            isLoggedIn
                ? _listCont(
                    icon: Icons.logout_outlined,
                    title: "Log Out",
                    onTap: () async {
                      await signOut(context);
                      Scaffold.of(context).closeEndDrawer();
                    },
                  )
                : SizedBox(),
            !isLoggedIn
                ? prov.page == "loginPage"
                    ? SizedBox.shrink()
                    : Row(
                        children: [
                          Builder(builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                prov.setPage(data: 'loginPage');
                                Scaffold.of(context).closeEndDrawer();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                margin: EdgeInsets.only(left: 20, right: 30),
                                decoration: BoxDecoration(
                                  color: amber,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: black,
                                    fontWeight: fWLargeFont,
                                    fontSize: kTextSmall,
                                  ),
                                ),
                              ),
                            );
                          }),

                          ///signup button
                          Builder(builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                prov.setPage(data: 'loginPage');
                                Scaffold.of(context).closeEndDrawer();
                              },
                              child: Container(
                                // height: 80,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
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
                            );
                          })
                        ],
                      )
                : SizedBox(),
          ],
        );
      }),
    ],
  ));
}

_listCont({title, icon, onTap}) {
  return Padding(
    padding: const EdgeInsets.only(left: 5.0),
    child: ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: amber,
      ),
      title: Text(
        title,
        style: TextStyle(color: white),
      ),
    ),
  );
}

Widget bg(context) {
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

Widget _logoCont() {
  return Container(
    height: 50,
    color: Colors.transparent,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
    child: Row(
      children: [
        Image.network(
          "images/icon.png",
          scale: 1.3,
        ),
        Text(
          ' Cryptousd',
          style: TextStyle(
            color: white,
            fontWeight: fWLargeFont,
            fontSize: kTextSmall,
          ),
        )
      ],
    ),
  );
}

///signOut function
Future signOut(context) async {
  await AuthService().signOut(context: context).then((v) async {
    var prov = Provider.of<GeneralProvider>(context, listen: false);

    prov.warningToast(
      context: context,
      title: 'You just Logged Out of your Krypto account',
    );

    ///move to landing page
    Future.delayed(Duration(seconds: 1), () async {
      await prov.setPage(data: 'landingPage');
    });
  });
}
