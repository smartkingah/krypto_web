import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import '../../providers/general_provider.dart';
import 'admin_users_tab.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    var prov = Provider.of<GeneralProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xFF0F1014),
      body: Row(
        children: [
          // Sleek Dark Sidebar
          Container(
            width: 270,
            decoration: const BoxDecoration(
              color: Color(0xFF15161D),
              border: Border(
                right: BorderSide(color: Color(0xFF22242F), width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _logoCont(),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "NAVIGATION",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _sidebarItem(
                  icon: Icons.people_alt_outlined,
                  title: "Users Overview",
                  isActive: true,
                  onTap: () {
                    prov.setAdminPage(data: 'users');
                    setState(() {});
                  },
                ),
                _sidebarItem(
                  icon: Icons.shield_outlined,
                  title: "System Updates",
                  isActive: false,
                  onTap: () {
                    // Placeholder
                  },
                ),
                _sidebarItem(
                  icon: Icons.settings_outlined,
                  title: "Preferences",
                  isActive: false,
                  onTap: () {
                    // Placeholder
                  },
                ),
                const Spacer(),
                // Elegant Admin Console Profile Box
                _adminProfileSection(),
              ],
            ),
          ),
          // Users List Content Pane
          const Expanded(
            child: AdminUsersTab(),
          ),
        ],
      ),
    );
  }

  Widget _logoCont() {
    return Container(
      padding: const EdgeInsets.only(left: 24, top: 28, right: 24, bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: amber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.network(
              "images/icon.png",
              height: 24,
              width: 24,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.currency_bitcoin,
                color: amber,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'CryptoUSD',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
            decoration: BoxDecoration(
              color: amber,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'PRO',
              style: TextStyle(
                color: Colors.black,
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _sidebarItem({
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: isActive ? amber.withValues(alpha: 0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isActive
                ? Border.all(color: amber.withValues(alpha: 0.2), width: 1)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? amber : Colors.white.withValues(alpha: 0.4),
                size: 18,
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.55),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              if (isActive) ...[
                const Spacer(),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: amber,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: amber.withValues(alpha: 0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _adminProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E202B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2B2D3C), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [amber, const Color(0xFFFF9900)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Admin Console',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Secure Connection Active',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
