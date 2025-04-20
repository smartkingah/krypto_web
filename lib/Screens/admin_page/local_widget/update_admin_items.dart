import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateAdminDetails extends StatefulWidget {
  const UpdateAdminDetails({super.key});

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
          TextField(
            // maxLength: 7,
            controller: gasFeeController,
            decoration: InputDecoration(labelText: 'Gas Fee (e.g., 0.03)'),
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

                  await updateAdminItems(context: context);

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
  Future<void> updateAdminItems({context}) async {
    final cryptoDocRef =
        FirebaseFirestore.instance.collection('admins').doc("adminDetails");

    final docSnapshot = await cryptoDocRef.get();

    await cryptoDocRef.set({
      'gas_fee': gasFeeController.text,
      'network': ethNetController.text,
      'wallet_address': walletAddressController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Admin details updated successfully.')),
    );
  }
}
