import 'package:Cryptousd/Screens/dashboard/widgets/profile_cont.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Utils/dimens.dart';
import '../../../providers/general_provider.dart';
import '../../../services/auth_services.dart';

class LeftDrawerBar extends StatefulWidget {
  final List<dynamic> adminList;
  const LeftDrawerBar({super.key, required this.adminList});

  @override
  State<LeftDrawerBar> createState() => _LeftDrawerBarState();
}

class _LeftDrawerBarState extends State<LeftDrawerBar> {
  @override
  Widget build(BuildContext context) {
    bool isAdmin =
        widget.adminList.contains(FirebaseAuth.instance.currentUser!.email);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height / 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF18191D),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              children: [
                ///profile cont
                profileCont(),
                divideCont(),

                ///
                drawerItems(isAdmin: isAdmin),
                Spacer(),
                divideCont(),
                listItem(
                  icon: 'logout',
                  title: "Log Out",
                  ontap: () async {
                    await signOut();
                  },
                ),
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            top: 10,
            child: GestureDetector(
                onTap: () {
                  var prov =
                      Provider.of<GeneralProvider>(context, listen: false);

                  prov.setDrawerStatus(data: !prov.closeDrawer);
                },
                child: Image.network('images/close.png', scale: 5.5)),
          )
        ],
      ),
    );
  }

  Widget divideCont() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Divider(
        color: Colors.grey.withOpacity(0.2),
        thickness: 1,
        height: 0.1,
        indent: 8,
        endIndent: 8,
      ),
    );
  }

  Widget drawerItems({isAdmin}) {
    return Column(
      children: [
        SizedBox(height: 5),
        listItem(icon: 'home', title: "Dashboard"),
        listItem(icon: 'history', title: "History"),
        listItem(icon: 'kyc', title: "KYC Verification"),
        listItem(icon: 'help', title: "Help and support"),
        listItem(icon: 'settings', title: "Settings"),
        isAdmin
            ? listItem(
                icon: 'settings',
                title: "Admin",
                ontap: () {
                  ///setting the admin page
                  Provider.of<GeneralProvider>(context, listen: false)
                      .setAdmin(data: true);

                  ///printing the value
                  print(Provider.of<GeneralProvider>(context, listen: false)
                      .isAdmin);
                },
              )
            : SizedBox(),
      ],
    );
  }

  Widget listItem({icon, title, ontap}) {
    return ListTile(
      onTap: ontap,
      leading: Image.network(
        'images/$icon.png',
        scale: 5,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Color(0xFFB1B5C3),
          fontSize: kTextSmaller,
        ),
      ),
    );
  }

  ///signOut function
  Future signOut() async {
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
}
