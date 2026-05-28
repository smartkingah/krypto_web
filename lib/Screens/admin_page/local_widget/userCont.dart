import 'package:Cryptousd/Utils/keys.dart';
import 'package:Cryptousd/providers/general_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailjs/emailjs.dart' as emailjs;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:provider/provider.dart';

import '../../../Utils/color/color.dart';
import '../../../Utils/dimens.dart';
import '../update_admin_items.dart';
import '../user_details_page.dart';

class UserCont extends StatefulWidget {
  final dynamic data;
  const UserCont({super.key, required this.data});

  @override
  State<UserCont> createState() => _UserContState();
}

class _UserContState extends State<UserCont> {
  List adminLists = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchAdminList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  fetchAdminList() async {
    try {
      await FirebaseFirestore.instance
          .collection('admins')
          .doc('adminsList')
          .get()
          .then((v) {
        if (v.exists) {
          var data = v.data();
          setState(() {
            adminLists = data?['email'] ?? [];
          });
        }
      });
    } catch (e) {
      print("Error fetching admin list: $e");
    }
  }

  // Generate beautiful consistent gradients based on username
  LinearGradient _getAvatarGradient(String name) {
    final int hash = name.codeUnits.fold(0, (prev, element) => prev + element);
    final List<List<Color>> gradients = [
      [const Color(0xFF6366F1), const Color(0xFFA855F7)], // Indigo -> Purple
      [const Color(0xFFEC4899), const Color(0xFFF43F5E)], // Pink -> Rose
      [const Color(0xFF3B82F6), const Color(0xFF06B6D4)], // Blue -> Cyan
      [const Color(0xFF10B981), const Color(0xFF059669)], // Emerald -> Green
      [const Color(0xFFF59E0B), const Color(0xFFD97706)], // Amber -> Orange
    ];
    return LinearGradient(
      colors: gradients[hash % gradients.length],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    var rawDocs = widget.data as List<dynamic>;
    
    // Filter docs based on search query
    var filteredDocs = rawDocs.where((doc) {
      final name = doc['fullName']?.toString().toLowerCase() ?? '';
      final email = doc['email']?.toString().toLowerCase() ?? '';
      return name.contains(_searchQuery) || email.contains(_searchQuery);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Premium Header & Summary Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Platform Directory",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Manage, view and allocate assets to registered accounts.",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
            // Quick Stat Badges
            Row(
              children: [
                _buildStatBadge(
                  label: "Total Accounts",
                  value: rawDocs.length.toString(),
                  color: amber,
                ),
                const SizedBox(width: 12),
                _buildStatBadge(
                  label: "Admins",
                  value: adminLists.length.toString(),
                  color: const Color(0xFF10B981),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Search Input Bar
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF1E202B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2B2D3C), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.white.withValues(alpha: 0.3), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 13.5),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search accounts by full name or email address...",
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.25),
                      fontSize: 13.5,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear, color: Colors.white.withValues(alpha: 0.5), size: 18),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = "";
                    });
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // User list view
        filteredDocs.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60.0),
                  child: Column(
                    children: [
                      Icon(Icons.person_search, size: 48, color: Colors.white.withValues(alpha: 0.15)),
                      const SizedBox(height: 12),
                      Text(
                        "No matches found for '$_searchQuery'",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final doc = filteredDocs[index];
                  final timestamp = doc['timeStamp']?.toDate() ?? DateTime.now();
                  final fullName = doc['fullName']?.toString() ?? "Krypto User";
                  final email = doc['email']?.toString() ?? "No email provided";
                  final isUserAdmin = adminLists.contains(email);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E202B),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF2A2D3C), width: 0.8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          await sendMail();
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return UserDetailsPage(userId: doc["userId"]);
                          }));
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: Row(
                            children: [
                              // Avatar circle with elegant name gradient
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: _getAvatarGradient(fullName),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    fullName.isNotEmpty ? fullName[0].toUpperCase() : "U",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Name & Email
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          fullName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.5,
                                          ),
                                        ),
                                        if (isUserAdmin) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.red.withValues(alpha: 0.12),
                                              border: Border.all(color: Colors.red.withValues(alpha: 0.3), width: 0.6),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'ADMIN',
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 8.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      email,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.4),
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Date Joined
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF15161D),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFF22242F), width: 0.8),
                                    ),
                                    child: Text(
                                      "Joined ${GetTimeAgo.parse(timestamp)}",
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.55),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              // View details arrow
                              Icon(
                                Icons.chevron_right,
                                color: Colors.white.withValues(alpha: 0.2),
                                size: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildStatBadge({required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E202B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF2A2D3C), width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  sendMail() async {
    Map<String, dynamic> templateParams = {
      'name': 'Krypto Admin Updates',
      'message':
          '''An Admin (${getStorage.read('fullName')}), with email address ${FirebaseAuth.instance.currentUser!.email} is now active on your Krypto platform!
Log in to see what they are doing.'''
    };

    try {
      await emailjs.send(
        Constance.SERVICE_KEY,
        Constance.TEMPLATE_KEY,
        templateParams,
        const emailjs.Options(
          publicKey: Constance.PUBLIC_KEY,
          privateKey: Constance.PRIVATE_KEY,
        ),
      );
      print('SUCCESS!');
    } catch (error) {
      print('$error');
    }
  }
}
