import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import '../../providers/general_provider.dart';
import 'local_widget/user_details_cont_page.dart';

class UserDetailsPage extends StatefulWidget {
  final String userId;
  const UserDetailsPage({super.key, required this.userId});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              .doc(widget.userId)
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
            if (!snapshot.hasData) {
              return Text(
                'No user available here!!!',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: fWLargerFont,
                ),
              );
            }
            if (snapshot.hasData) {
              return UserDetailsContPage(data: snapshot.data);
            }
            return Container();
          },
        ),
      ),
    );
  }
}
