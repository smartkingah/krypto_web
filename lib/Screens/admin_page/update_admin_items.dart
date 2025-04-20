import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import 'local_widget/add_crypto_to_dialog.dart';
import 'local_widget/update_admin_items.dart';

class UpdateAdminItem extends StatefulWidget {
  const UpdateAdminItem({super.key});

  @override
  State<UpdateAdminItem> createState() => _UpdateAdminItemState();
}

class _UpdateAdminItemState extends State<UpdateAdminItem> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('admins')
          .doc('adminDetails')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 0.8,
              color: black,
            ),
          );
        }
        if (snapshot.hasData) {
          var data = snapshot.data;
          return Row(
            children: [
              _contItem(title: 'Gas Fee', sub: data!['gas_fee']),
              SizedBox(width: 10),
              _contItem(title: 'Network', sub: data['network']),
              SizedBox(width: 10),
              _contWalletItem(
                  title: 'Wallet Address', sub: data['wallet_address']),
              SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: submitUserDataCont(
                      width: 120,
                      title: 'Update Details',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => UpdateAdminDetails(),
                        );
                      }),
                ),
              ),
            ],
          );
        }
        return Row(
          children: [
            _contItem(title: 'Gas Fee', sub: '3.0'),
            SizedBox(width: 10),
            _contItem(title: 'Network', sub: 'ERC20'),
            SizedBox(width: 10),
            _contWalletItem(
                title: 'Wallet Address',
                sub: 'aklsdjalksjdalksjdalskdjalskdjalskdjalskdjalskdj'),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: submitUserDataCont(
                  width: 120,
                  title: 'Update Details',
                  onTap: () => AddCryptoDialog(userId: 'asd'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ///widgets

  Widget submitUserDataCont({title, onTap, width = 150}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 0.6),
        ),
        child: Center(
          child: Text(
            title.toString(),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: white,
              fontWeight: fWLargerFont,
            ),
          ),
        ),
      ),
    );
  }

  _contItem({title, sub}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.6,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            '$title:  ',
            style: TextStyle(
              fontWeight: fWLargerFont,
              fontSize: kTextMini,
            ),
          ),
          Text(
            "$sub ETH",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: fWLargerFont,
              fontSize: kTextTinyHigh,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  _contWalletItem({title, sub}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.6,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            '$title:  ',
            style: TextStyle(
              fontWeight: fWLargerFont,
              fontSize: kTextMini,
            ),
          ),
          Container(
            width: 120,
            child: Text(
              "$sub ",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: fWLargerFont,
                fontSize: kTextTiny,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
