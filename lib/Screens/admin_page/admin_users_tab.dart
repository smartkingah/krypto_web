import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import 'local_widget/userCont.dart';

class AdminUsersTab extends StatefulWidget {
  const AdminUsersTab({super.key});

  @override
  State<AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<AdminUsersTab> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFFEFF3FD),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          decoration: BoxDecoration(
              color: white, borderRadius: BorderRadius.circular(20)),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .orderBy('timeStamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 0.7,
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text(
                  'No user available here!!!',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: fWLargerFont,
                  ),
                );
              }
              if (snapshot.hasData) {
                return UserCont(data: snapshot.data!.docs);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
