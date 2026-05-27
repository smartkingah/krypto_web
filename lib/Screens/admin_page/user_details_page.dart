import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFF0F1014),
      body: Container(
        margin: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF15161D),
          border: Border.all(color: const Color(0xFF22242F), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: amber,
                      strokeWidth: 1.5,
                    ),
                  );
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text(
                      'Account details unavailable.',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: fWLargerFont,
                      ),
                    ),
                  );
                }
                return UserDetailsContPage(data: snapshot.data);
              },
            ),
          ),
        ),
      ),
    );
  }
}
