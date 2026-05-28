import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import 'local_widget/add_crypto_to_dialog.dart';
import 'local_widget/update_admin_items.dart';

class UpdateAdminItem extends StatefulWidget {
  final String userId;

  const UpdateAdminItem({super.key, required this.userId});

  @override
  State<UpdateAdminItem> createState() => _UpdateAdminItemState();
}

class _UpdateAdminItemState extends State<UpdateAdminItem> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('admins')
          .doc('adminDetails')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 100,
            height: 40,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: amber,
              ),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data!.exists) {
          var data = snapshot.data;
          return Row(
            children: [
              _contItem(
                title: 'Gas Fee',
                sub: "${data?['gas_fee'] ?? '0.00'} ETH",
                icon: Icons.local_gas_station_outlined,
                accentColor: amber,
              ),
              const SizedBox(width: 10),
              _contItem(
                title: 'Network',
                sub: data?['network']?.toString() ?? 'ERC20',
                icon: Icons.lan_outlined,
                accentColor: const Color(0xFF6366F1),
              ),
              const SizedBox(width: 10),
              _contWalletItem(
                title: 'Wallet Address',
                sub: data?['wallet_address']?.toString() ?? 'Not Set',
                icon: Icons.wallet_outlined,
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: submitUserDataCont(
                  width: 130,
                  title: 'Update Settings',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => UpdateAdminDetails(userId: widget.userId),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget submitUserDataCont({required String title, required VoidCallback onTap, double width = 130}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 40,
        width: width,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E202B), Color(0xFF15161D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF2A2D3C), width: 0.8),
        ),
        child: Center(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _contItem({required String title, required String sub, required IconData icon, required Color accentColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E202B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2A2D3C), width: 0.8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.35), size: 16),
          const SizedBox(width: 8),
          Text(
            '$title:  ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
          Text(
            sub,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contWalletItem({required String title, required String sub, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E202B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2A2D3C), width: 0.8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.35), size: 16),
          const SizedBox(width: 8),
          Text(
            '$title:  ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 140,
            child: Text(
              sub,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFF10B981),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
