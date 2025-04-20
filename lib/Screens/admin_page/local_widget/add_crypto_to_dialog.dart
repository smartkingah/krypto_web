import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCryptoDialog extends StatefulWidget {
  final String userId;

  const AddCryptoDialog({super.key, required this.userId});

  @override
  State<AddCryptoDialog> createState() => _AddCryptoDialogState();
}

class _AddCryptoDialogState extends State<AddCryptoDialog> {
  final TextEditingController cryptoIdController = TextEditingController();
  final TextEditingController cryptoValueController = TextEditingController();
  final TextEditingController usdValueController = TextEditingController();

  bool isAdding = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Crypto Asset'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            // maxLength: 7,
            controller: cryptoIdController,
            decoration: InputDecoration(labelText: 'Crypto ID (e.g., BTC)'),
          ),
          TextField(
            controller: cryptoValueController,
            decoration:
                InputDecoration(labelText: 'Crypto Value (e.g., 0.022)'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          TextField(
            controller: usdValueController,
            decoration: InputDecoration(labelText: 'USD Value (e.g., \$100)'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
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

                  await addCryptoAsset(
                    context: context,
                    userId: widget.userId,
                    cryptoId: cryptoIdController.text.trim().toUpperCase(),
                    cryptoValue:
                        double.tryParse(cryptoValueController.text) ?? 0,
                    usdValue: double.tryParse(usdValueController.text) ?? 0,
                  );

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

  ///function to add crypto
  Future<void> addCryptoAsset({
    required String userId,
    required String cryptoId,
    required double cryptoValue,
    required double usdValue,
    context,
  }) async {
    final cryptoDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cryptos')
        .doc(cryptoId);

    final docSnapshot = await cryptoDocRef.get();

    if (docSnapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$cryptoId already exists.')),
      );
      return;
    }

    await cryptoDocRef.set({
      'cryptoValue': cryptoValue.toString(),
      'usdValue': usdValue.toString(),
      'amount': "0",
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$cryptoId added successfully.')),
    );
  }
}
