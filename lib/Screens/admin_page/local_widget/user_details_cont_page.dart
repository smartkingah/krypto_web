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
    super.initState();
    setUserDataForEdit();
  }

  setUserDataForEdit() {
    nameController.text = widget.data['fullName']?.toString() ?? '';
    emailController.text = widget.data['email']?.toString() ?? '';
    usdBalanceController.text = widget.data['balance']?.toString() ?? '0';
    passwordController.text = widget.data['password']?.toString() ?? '';
    phoneNumberController.text = widget.data['phoneNumber']?.toString() ?? '';
    userIdController.text = widget.data['userId']?.toString() ?? '';
    setState(() {});
  }

  @override
  void dispose() {
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

  LinearGradient _getProfileGradient(String name) {
    return const LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = widget.data['fullName']?.toString() ?? "Krypto User";
    final String email = widget.data['email']?.toString() ?? "No email";
    final String balance = widget.data['balance']?.toString() ?? "0";

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Action Row
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E202B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF2A2D3C), width: 0.8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Spacer(),
                // Gas, Network, Wallet update panel
                UpdateAdminItem(userId: widget.data['userId']),
              ],
            ),
            const SizedBox(height: 28),

            // Profile Header Summary Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E202B), Color(0xFF15161D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2A2D3C), width: 0.8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: _getProfileGradient(fullName),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        fullName.isNotEmpty ? fullName[0].toUpperCase() : "U",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Styled USD Wallet Balance
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "VALUATION BALANCE",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$${balance.toString()}",
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Profile Edit Form Title Card
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: amber.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.manage_accounts_outlined,
                    color: amber,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Account Profile Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                isUserProfileLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: amber,
                        ),
                      )
                    : _gradientActionButton(
                        title: 'Save Profile Changes',
                        onTap: () => updateUserData(),
                      ),
              ],
            ),
            const SizedBox(height: 20),

            // User Personal Details Grid (Completely excluding Password field)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E202B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2A2D3C), width: 0.8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          label: "Full Name",
                          controller: nameController,
                          enabled: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          label: "Email Address",
                          controller: emailController,
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          label: "USD Balance (\$)",
                          controller: usdBalanceController,
                          enabled: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          label: "Phone Number",
                          controller: phoneNumberController,
                          enabled: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: "User Unique Identifier (System Blocked)",
                    controller: userIdController,
                    enabled: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Crypto Assets Title Area
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.monetization_on_outlined,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Allocated Cryptocurrency Balances',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                _gradientActionButton(
                  title: 'Allocate New Asset',
                  icon: Icons.add,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddCryptoDialog(userId: widget.data['userId']),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Crypto Assets List Card Container
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E202B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2A2D3C), width: 0.8),
              ),
              padding: const EdgeInsets.all(20),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.data['userId'])
                    .collection('cryptos')
                    .snapshots(),
                builder: (context, cryptoSnapshot) {
                  if (cryptoSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: amber,
                        ),
                      ),
                    );
                  }
                  if (!cryptoSnapshot.hasData || cryptoSnapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.pie_chart_outline, size: 40, color: Colors.white.withValues(alpha: 0.15)),
                            const SizedBox(height: 12),
                            Text(
                              "No crypto balances currently allocated to this user.",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.3),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  cryptoControllerValue.clear();
                  usdController.clear();
                  priceController.clear();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cryptoSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = cryptoSnapshot.data!.docs[index];

                      final controller = TextEditingController(text: data['cryptoValue'].toString());
                      final controller2 = TextEditingController(text: data['usdValue'].toString());
                      final priceControllerItem = TextEditingController(text: data['amount'].toString());

                      cryptoControllerValue.add(controller);
                      usdController.add(controller2);
                      priceController.add(priceControllerItem);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF15161D),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF22242F), width: 0.8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Coin Identity Header
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: amber.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: amber.withValues(alpha: 0.2), width: 0.8),
                                  ),
                                  child: Text(
                                    data.id.toString().toUpperCase(),
                                    style: TextStyle(
                                      color: amber,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12.5,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Asset Configuration",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Dynamic Editing Forms
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: _buildAssetField(
                                    label: "Crypto Price (\$)",
                                    controller: priceControllerItem,
                                    isLoading: isCryptoPriceLoading && _updatingIndex == index,
                                    buttonText: "Set Price",
                                    onUpdate: () => updateUserCryptoField(
                                      isCrypto: true,
                                      docId: data.id,
                                      valueToUpdate: 'amount',
                                      newValue: priceControllerItem.text,
                                      isUsd: false,
                                      index: index,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _buildAssetField(
                                    label: "Crypto Balance",
                                    controller: controller,
                                    isLoading: isCryptoLoading && _updatingIndex == index,
                                    buttonText: "Set Balance",
                                    onUpdate: () => updateUserCryptoField(
                                      isCrypto: false,
                                      docId: data.id,
                                      valueToUpdate: 'cryptoValue',
                                      newValue: controller.text,
                                      isUsd: false,
                                      index: index,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _buildAssetField(
                                    label: "USD Valuation (\$)",
                                    controller: controller2,
                                    isLoading: isUsdLoading && _updatingIndex == index,
                                    buttonText: "Set Valuation",
                                    onUpdate: () => updateUserCryptoField(
                                      isCrypto: false,
                                      docId: data.id,
                                      valueToUpdate: 'usdValue',
                                      newValue: controller2.text,
                                      isUsd: true,
                                      index: index,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 36),

            // Tip & Safety Warning Cards
            _buildTipCard(
              title: "Value Inputs",
              message: "Verify values are numbers. Use dot (.) decimals. Commas (,) are disallowed.",
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              title: "Mutual Synchronization",
              message: "Always update both Crypto Balance and USD Valuation values after user transactions to keep ledger parity.",
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              title: "Asset Allocation Policy",
              message: "Ensure coin symbols are entered accurately. Verify layouts on mobile devices before confirming live deployments.",
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Beautiful styled text field for user profile editing
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.35),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: enabled ? const Color(0xFF15161D) : const Color(0xFF101116),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: enabled ? const Color(0xFF22242F) : const Color(0xFF1A1B24),
              width: 0.8,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: TextField(
              controller: controller,
              enabled: enabled,
              inputFormatters: inputFormatters,
              style: TextStyle(
                color: enabled ? Colors.white : Colors.white.withValues(alpha: 0.35),
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Highly premium custom component for sub-asset forms
  Widget _buildAssetField({
    required String label,
    required TextEditingController controller,
    required bool isLoading,
    required String buttonText,
    required VoidCallback onUpdate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.35),
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1D26),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2A2D3C), width: 0.8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: TextField(
                    controller: controller,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ],
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            isLoading
                ?  SizedBox(
                    width: 24,
                    height: 24,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: CircularProgressIndicator(strokeWidth: 1.5, color: amber),
                    ),
                  )
                : _gradientActionButton(
                    title: buttonText,
                    onTap: onUpdate,
                    height: 40.0,
                    fontSize: 11.0,
                    borderRadius: 8.0,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
          ],
        ),
      ],
    );
  }

  // Premium multi-use gradient action buttons
  Widget _gradientActionButton({
    required String title,
    IconData? icon,
    LinearGradient? gradient,
    required VoidCallback onTap,
    double height = 44.0,
    double fontSize = 12.0,
    double borderRadius = 10.0,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16),
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          gradient: gradient ??
              LinearGradient(
                colors: [amber, const Color(0xFFFF9900)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: (gradient?.colors.first ?? amber).withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.black, size: 14),
              const SizedBox(width: 6),
            ],
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom premium warnings/tips container card
  Widget _buildTipCard({required String title, required String message}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withValues(alpha: 0.12), width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.redAccent,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Updated function for backend modification
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

    try {
      double usdAmount = double.parse(newValue);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.data['userId'])
          .collection('cryptos')
          .doc(docId)
          .update({
        valueToUpdate: usdAmount.toInt(),
      });
    } catch (e) {
      print("Error updating user crypto field: $e");
    }

    setState(() {
      if (isUsd) {
        isUsdLoading = false;
      } else if (isCrypto) {
        isCryptoLoading = false;
      } else {
        isCryptoPriceLoading = false;
      }
      _updatingIndex = -1;
    });
  }

  Future updateUserData() async {
    setState(() {
      isUserProfileLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.data['userId'])
          .update({
        "fullName": nameController.text,
        "balance": usdBalanceController.text,
        "phoneNumber": phoneNumberController.text,
      });
    } catch (e) {
      print("Error updating user profile data: $e");
    }
    setState(() {
      isUserProfileLoading = false;
    });
  }
}
