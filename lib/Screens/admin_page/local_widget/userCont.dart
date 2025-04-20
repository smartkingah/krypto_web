import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart';

import '../../../Utils/color/color.dart';
import '../../../Utils/dimens.dart';
import '../update_admin_items.dart';
import '../user_details_page.dart';

class UserCont extends StatefulWidget {
  final dynamic data;
  const UserCont({super.key, required this.data});

  @override
  State<UserCont> createState() => _UserContState();
}

class _UserContState extends State<UserCont> {
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
    bool isAdmin =
        adminLists.contains(FirebaseAuth.instance.currentUser!.email);
    var dataItem = widget.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Users",
              style: TextStyle(
                color: Colors.black,
                fontWeight: fWxLargeFont,
                fontSize: kTextLarge,
              ),
            ),
            SizedBox(width: 40),
            Text(
              "${dataItem.length} Users",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: fWxLargeFont,
                fontSize: kTextSmaller,
              ),
            ),
            Spacer(),
            UpdateAdminItem(),
          ],
        ),
        SizedBox(height: 30),
        ListView.builder(
          shrinkWrap: true,
          itemCount: dataItem.length,
          itemBuilder: (context, index) {
            var timestamp = widget.data[index]['timeStamp'].toDate();
            return ListTile(
              onTap: () {
                // setState(() {});
                //
                // ///open user details
                // Provider.of<GeneralProvider>(context, listen: false)
                //     .setAdminPage(data: 'userDetailsPage');
                // Provider.of<GeneralProvider>(context, listen: false)
                //     .setAdminPageUserId(userId: widget.data[index]["userId"]);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UserDetailsPage(userId: widget.data[index]["userId"]);
                }));
              },
              leading: CircleAvatar(
                child: Icon(Icons.person_2_outlined),
              ),
              title: Row(
                children: [
                  Text(
                    widget.data[index]['fullName'].toString(),
                    style: TextStyle(fontWeight: fWLargerFont),
                  ),
                  // isAdmin ? adminCont() : SizedBox(),
                ],
              ),
              subtitle: Text(
                widget.data[index]['email'],
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              trailing: Text(
                "Date Joined ${GetTimeAgo.parse(timestamp)}",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: fWLargerFont,
                  fontSize: kTextMini,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget adminCont() {
    return Container(
      width: 100,
      height: 25,
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          'Admin',
          style: TextStyle(
            color: white,
            fontWeight: fWLargerFont,
            fontSize: kTextSmaller,
          ),
        ),
      ),
    );
  }
}
