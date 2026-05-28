import 'package:flutter/material.dart';

import '../Screens/MyHomePage.dart';

class DesktopBody extends StatefulWidget {
  const DesktopBody({super.key});

  @override
  State<DesktopBody> createState() => _DesktopBodyState();
}

class _DesktopBodyState extends State<DesktopBody> {
  // List adminLists = [];
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   fetchAdminList();
  // }
  //
  // fetchAdminList() async {
  //   await FirebaseFirestore.instance
  //       .collection('admins')
  //       .doc('adminsList')
  //       .get()
  //       .then(
  //     (v) {
  //       var data = v.data();
  //       setState(() {
  //         adminLists = data!['email'];
  //         print(adminLists);
  //       });
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // bool isAdmin =
    //     adminLists.contains(FirebaseAuth.instance.currentUser!.email);
    return MyHomePage();
    // return AdminPage();
    // if (isAdmin) {
    //   return AdminPage();
    // } else {
    //   return MyHomePage();
    // }
  }
}
