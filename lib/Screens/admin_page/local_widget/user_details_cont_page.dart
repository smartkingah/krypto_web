import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart';

import '../../../Utils/color/color.dart';
import '../../../Utils/dimens.dart';
import '../update_admin_items.dart';
import 'add_crypto_to_dialog.dart';

class UserDetailsContPage extends StatefulWidget {
  final dynamic data;

  const UserDetailsContPage({required this.data, super.key});

  @override
  State<UserDetailsContPage> createState() => _UserDetailsContPageState();
}

class _UserDetailsContPageState extends State<UserDetailsContPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usdBalanceController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController cryptoController = TextEditingController();

  /// Create a list of controllers
  List<TextEditingController> cryptoControllerValue = [];
  List<TextEditingController> usdController = [];
  List<TextEditingController> priceController = [];

  int _updatingIndex = 0;

  bool isUsdLoading = false;
  bool isUserProfileLoading = false;
  bool isCryptoLoading = false;
  bool isCryptoPriceLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserDataForEdit();
  }

  setUserDataForEdit() {
    nameController.text = widget.data['fullName'].toString();
    emailController.text = widget.data['email'].toString();
    usdBalanceController.text = widget.data['balance'].toString();
    passwordController.text = widget.data['password'].toString();
    phoneNumberController.text = widget.data['phoneNumber'].toString();
    userIdController.text = widget.data['userId'].toString();
    setState(() {});
  }

  @override
  void dispose() {
    // Dispose all controllers
    nameController.dispose();
    emailController.dispose();
    usdBalanceController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    userIdController.dispose();
    for (var c in cryptoControllerValue) {
      c.dispose();
    }
    for (var c in usdController) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BackButton(color: Colors.black),
                Spacer(),
                UpdateAdminItem(
                  userId: widget.data['userId'],
                ),
              ],
            ),

            ///update of user datas
            SizedBox(height: 30),
            isUserProfileLoading
                ? Center(
                    child: const CircularProgressIndicator(strokeWidth: 1),
                  )
                : Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[400],
                        child: Icon(
                          Icons.person,
                          color: white,
                        ),
                      ),
                      Text(
                        '  User Personal Info',
                        style: TextStyle(
                          fontWeight: fWxLargeFont,
                          fontSize: kTextLarge,
                        ),
                      ),
                      Spacer(),
                      submitUserDataCont(
                          title: 'Update User Data',
                          onTap: () {
                            updateUserData();
                          }),
                    ],
                  ),
            SizedBox(height: 25),
            rowCont(title: 'Name', contr: nameController),
            SizedBox(height: 10),
            rowCont(title: 'Email', contr: emailController, enabled: false),
            SizedBox(height: 10),
            rowCont(title: 'Usd Balance', contr: usdBalanceController),
            SizedBox(height: 10),
            rowCont(
                title: 'Password', contr: passwordController, enabled: false),
            SizedBox(height: 10),
            rowCont(title: 'Phone Number', contr: phoneNumberController),
            SizedBox(height: 10),
            rowCont(title: 'User Id', contr: userIdController, enabled: false),

            ///divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),

            ///update of user crypto datas
            SizedBox(height: 50),

            ///appbar
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey[400],
                  child: Icon(
                    Icons.currency_bitcoin,
                    color: white,
                  ),
                ),
                Text(
                  ' User Crypto Data',
                  style: TextStyle(
                    fontWeight: fWxLargeFont,
                    fontSize: kTextLarge,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: submitUserDataCont(
                        width: 200,
                        title: '  Add crypto to ${widget.data["fullName"]}',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                AddCryptoDialog(userId: widget.data['userId']),
                          );
                        }),
                  ),
                ),
              ],
            ),

            ///
            SizedBox(height: 25),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.data['userId'])
                  .collection('cryptos')
                  .snapshots(),
              builder: (context, cryptoSnapshot) {
                if (cryptoSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 0.8,
                    color: black,
                  ));
                }
                cryptoControllerValue.clear();
                usdController.clear();
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: cryptoSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = cryptoSnapshot.data!.docs[index];

                    /// Create a new controller for each item
                    final controller = TextEditingController(
                        text: data['cryptoValue'].toString());
                    final controller2 = TextEditingController(
                        text: data['usdValue'].toString());
                    final priceControllerItem =
                        TextEditingController(text: data['amount'].toString());

                    ///for storage
                    cryptoControllerValue.add(controller);
                    usdController.add(controller2);
                    priceController.add(priceControllerItem);

                    ///for display
                    controller.text = data['cryptoValue'].toString();
                    controller2.text = data['usdValue'].toString();
                    priceControllerItem.text = data['amount'].toString();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.id.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: fWLargerFont,
                              fontSize: kTextMini,
                            ),
                          ),
                          SizedBox(width: 20),
                          Row(
                            children: [
                              tField(
                                enabled: true,
                                contr: priceControllerItem,
                                label: 'Crypto Price',
                                filter: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$')),
                                ],
                              ),
                              tField(
                                enabled: true,
                                contr: controller,
                                label: 'Crypto Amount',
                                filter: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$')),
                                ],
                              ),
                              tField(
                                  enabled: true,
                                  contr: controller2,
                                  label: "Usd Amount",
                                  filter: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*$')),
                                  ]),
                            ],
                          ),

                          ///updates functions
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                ///updating crypto price
                                isCryptoPriceLoading && _updatingIndex == index
                                    ? const CircularProgressIndicator(
                                        strokeWidth: 1)
                                    : submitUserDataCont(
                                        title: 'Update Crypto Price',
                                        onTap: () => updateUserCryptoField(
                                              isCrypto: true,
                                              docId: data.id,
                                              valueToUpdate: 'amount',
                                              newValue:
                                                  priceControllerItem.text,
                                              isUsd: false,
                                              index: index,
                                            )),
                                SizedBox(width: 20),

                                ///updating crypto value
                                isCryptoLoading && _updatingIndex == index
                                    ? const CircularProgressIndicator(
                                        strokeWidth: 1)
                                    : submitUserDataCont(
                                        title: 'Update Crypto Value',
                                        onTap: () => updateUserCryptoField(
                                              isCrypto: false,
                                              docId: data.id,
                                              valueToUpdate: 'cryptoValue',
                                              newValue: controller.text,
                                              isUsd: false,
                                              index: index,
                                            )),
                                SizedBox(width: 20),

                                ///updating usd value
                                isUsdLoading && _updatingIndex == index
                                    ? const CircularProgressIndicator(
                                        strokeWidth: 1)
                                    : submitUserDataCont(
                                        title: 'Update USD',
                                        onTap: () => updateUserCryptoField(
                                              isCrypto: false,
                                              docId: data.id,
                                              valueToUpdate: 'usdValue',
                                              newValue: controller2.text,
                                              isUsd: true,
                                              index: index,
                                            )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 50),
            Text(
              'Notes: Please make sure to always add only ( figures and full stop.) when adding crypto and usd values',
              style: TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic,
                fontSize: kTextSmall,
                fontWeight: fWxxLargeFont,
              ),
            ),

            SizedBox(height: 20),
            Text(
              'Notes: Please make sure to always update both the crypto and usd values after manipulating their figures respectively',
              style: TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic,
                fontSize: kTextSmall,
                fontWeight: fWxxLargeFont,
              ),
            ),

            SizedBox(height: 20),
            Text(
              'Notes: Also that when adding a coin be very careful about the coin symbol, make sure you test out the account on mobile view to be sure there are no errors... some coins like PEPE bring error so avoid such meme coins and use another... ',
              style: TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic,
                fontSize: kTextSmall,
                fontWeight: fWxxLargeFont,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///widgets
  Widget rowCont({title, contr, enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              color: Colors.black,
              fontWeight: fWLargerFont,
              fontSize: kTextMini,
            ),
          ),
          SizedBox(width: 20),
          tField(enabled: enabled, contr: contr),
        ],
      ),
    );
  }

  Widget tField({
    enabled,
    contr,
    label = '',
    filter,
  }) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      height: 45,
      width: 170,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        inputFormatters: filter,
        enabled: enabled,
        controller: contr,
        style: TextStyle(
          fontWeight: fWLargerFont,
          fontSize: kTextMini,
        ),
        decoration: InputDecoration(
            label: Text(label),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            )),
      ),
    );
  }

  Widget submitUserDataCont({title, onTap, width = 120}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: width,
        decoration: BoxDecoration(
          color: black,
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
              fontSize: kTextTiny,
              fontWeight: fWLargerFont,
            ),
          ),
        ),
      ),
    );
  }

  ///function

  Future<void> updateUserCryptoField({
    required String docId,
    required String valueToUpdate,
    required dynamic newValue,
    required bool isUsd,
    required bool isCrypto,
    required int index,
  }) async {
    setState(() {
      if (isUsd) {
        isUsdLoading = true;
      } else if (isCrypto) {
        isCryptoLoading = true;
      } else {
        isCryptoPriceLoading = true;
      }
      _updatingIndex = index;
    });
    double usdAmount = double.parse(newValue);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.data['userId'])
        .collection('cryptos')
        .doc(docId)
        .update({
      valueToUpdate: usdAmount.toInt(),
    });

    setState(() {
      isUsd
          ? isUsdLoading = false
          : isCrypto
              ? isCryptoPriceLoading = false
              : isCryptoLoading = false;
      _updatingIndex = -1;
    });
  }

  Future updateUserData() async {
    setState(() {
      isUserProfileLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.data['userId'])
        .update({
      "fullName": nameController.text,
      "balance": usdBalanceController.text,
      "phoneNumber": phoneNumberController.text,
    }).then((v) {
      setState(() {
        isUserProfileLoading = false;
      });
    });
  }
}
