import 'package:Cryptousd/Utils/color/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateAdminDetails extends StatefulWidget {
  final String userId;
  const UpdateAdminDetails({required this.userId, super.key});

  @override
  State<UpdateAdminDetails> createState() => _UpdateAdminDetailsState();
}

class _UpdateAdminDetailsState extends State<UpdateAdminDetails> {
  final TextEditingController gasFeeController = TextEditingController();
  final TextEditingController ethNetController = TextEditingController();
  final TextEditingController walletAddressController = TextEditingController();

  bool isAdding = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Please make sure the GAS FEE is only Digits',
            style: TextStyle(
              color: red,
            ),
          ),
          TextField(
            // maxLength: 7,
            controller: gasFeeController,
            decoration: InputDecoration(labelText: 'Gas Fee (e.g., 0.03)'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
          ),
          TextField(
            controller: ethNetController,
            decoration:
                InputDecoration(labelText: 'ETH Network (e.g.,  ERC20)'),
            keyboardType: TextInputType.text,
          ),
          TextField(
            controller: walletAddressController,
            decoration:
                InputDecoration(labelText: 'Wallet address (e.g., yuioihj...)'),
            keyboardType: TextInputType.text,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isAdding
              ? null
              : () async {
                  setState(() => isAdding = true);

                  await updateAdminItems(
                      context: context, userId: widget.userId);

                  Navigator.of(context).pop(); // Close dialog
                },
          child: isAdding
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Add'),
        ),
      ],
    );
  }

  ///function to update admin
  Future<void> updateAdminItems({context, userId}) async {
    final cryptoDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('admins')
        .doc("adminDetails");

    final docSnapshot = await cryptoDocRef.get();

    await cryptoDocRef.set({
      'gas_fee': gasFeeController.text,
      'network': ethNetController.text,
      'wallet_address': walletAddressController.text,
      'bitcoin_price_to_usd': 89988,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Admin details updated successfully.')),
    );
  }
}
