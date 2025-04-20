import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import '../../providers/general_provider.dart';
import 'admin_users_tab.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<GeneralProvider>(context, listen: false);
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 15,
              color: Color(0xFFFFFFFF),
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: MediaQuery.of(context).size.height / 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _logoCont(),
                      listItem(
                        icon: 'mobile/users',
                        title: "Updates",
                        ontap: () async {
                          // await signOut();
                          // Provider.of<GeneralProvider>(context, listen: false)
                          //     .clearProviders();
                          prov.setAdminPage(data: 'users');
                          setState(() {});
                        },
                      ),
                    ],
                  )),
            ),
          ),
          // prov.adminPage == "users"
          //     ? AdminUsersTab()
          //     : prov.adminPage == "userDetailsPage"
          //         ? UserDetailsPage()
          //         :
          AdminUsersTab(),
        ],
      ),
    );
  }

  Widget listItem({icon, title, ontap}) {
    return ListTile(
      onTap: ontap,
      leading: Image.network(
        'images/$icon.png',
        scale: 1.8,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: fWLargerFont,
          fontSize: kTextSmallHigh,
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
}
