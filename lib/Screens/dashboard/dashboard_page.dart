import 'package:Cryptousd/Screens/dashboard/widgets/drawer_page.dart';
import 'package:Cryptousd/Screens/dashboard/widgets/leftDrawerBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/footer_page.dart';
import '../../providers/general_provider.dart';
import '../admin_page/adminPage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List adminLists = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAdminList();
  }

  fetchAdminList() async {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc('adminsList')
        .get()
        .then(
      (v) {
        var data = v.data();
        setState(() {
          adminLists = data!['email'];
          print(adminLists);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<GeneralProvider>(context, listen: false);
    bool isAdmin =
        adminLists.contains(FirebaseAuth.instance.currentUser!.email);
    if (isAdmin) {
      return AdminPage();
    } else {
      return ListView(
        children: [
          SizedBox(height: 5),

          // Text(
          //   FirebaseAuth.instance.currentUser!.email!,
          //   style: TextStyle(color: white),
          // ),
          // Text(
          //   getStorage.read('fullName'),
          //   style: TextStyle(color: white),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 100.0),
          //   child:  Image.network(
          //     'images/la.png',
          //     scale: 5.4,
          //   ),
          // ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: prov.closeDrawer ? 0 : 1,
                child: prov.closeDrawer
                    ? closedDrawerCont()
                    : LeftDrawerBar(adminList: adminLists),
              ),
              Expanded(
                  flex: prov.closeDrawer ? 1 : 5, child: MainPageHomeScreen()),
            ],
          ),
          SizedBox(height: 20),

          ///footer
          FooterPage(),
        ],
      );
    }
  }

  // prov.closeDrawer ?
  Widget closedDrawerCont() {
    return Container(
      width: 30,
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF18191D),
      ),
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
            onTap: () {
              var prov = Provider.of<GeneralProvider>(context, listen: false);

              prov.setDrawerStatus(data: !prov.closeDrawer);
            },
            child: Center(child: Image.network('images/close.png', scale: 5))),
      ),
    );
  }
}
