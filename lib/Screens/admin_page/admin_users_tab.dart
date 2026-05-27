import 'package:cloud_firestore/cloud_firestore.dart';
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
      flex: 3,
      child: Container(
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
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .orderBy('timeStamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: amber,
                          strokeWidth: 1.5,
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 80.0),
                      child: Center(
                        child: Text(
                          'No registered users available yet.',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: fWLargerFont,
                            fontSize: 15,
                          ),
                        ),
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
        ),
      ),
    );
  }
}
