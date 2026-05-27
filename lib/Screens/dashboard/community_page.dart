import 'package:flutter/material.dart';

import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import '../../Widgets/footer_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategory = 0;

  final List<String> _categories = [
    'All', 'Bitcoin', 'Ethereum', 'DeFi', 'NFTs', 'Trading'
  ];

  final List<Map<String, dynamic>> _posts = [
    {
      'author': 'CryptoWhale',
      'avatar': 'CW',
      'avatarColor': Color(0xFF6C5CE7),
      'time': '2 hours ago',
      'category': 'Bitcoin',
      'title': 'Bitcoin just broke the \$70k resistance — what\'s next?',
      'body':
          'After months of consolidation, BTC has finally broken through the key \$70,000 resistance level. Volume is supporting the move and on-chain data looks healthy. Here\'s my technical analysis...',
      'likes': 248,
      'replies': 47,
      'pinned': true,
    },
    {
      'author': 'ETHMaster',
      'avatar': 'EM',
      'avatarColor': Color(0xFF00CEC9),
      'time': '4 hours ago',
      'category': 'Ethereum',
      'title': 'Ethereum staking rewards just increased — here\'s how to maximize',
      'body':
          'With the recent network upgrade, ETH staking yields have climbed to ~4.8% APY. I\'ve been running a validator for 8 months and here are my tips to maximize returns...',
      'likes': 182,
      'replies': 34,
      'pinned': false,
    },
    {
      'author': 'DeFiDave',
      'avatar': 'DD',
      'avatarColor': Color(0xFFE17055),
      'time': '6 hours ago',
      'category': 'DeFi',
      'title': 'Top 5 yield farming strategies for Q2 2025',
      'body':
          'DeFi has matured significantly. Here\'s a rundown of the top protocols I\'m currently farming on and the risk/reward profile of each. Always DYOR before depositing funds...',
      'likes': 134,
      'replies': 29,
      'pinned': false,
    },
    {
      'author': 'SolanaKing',
      'avatar': 'SK',
      'avatarColor': Color(0xFF74B9FF),
      'time': '8 hours ago',
      'category': 'Trading',
      'title': 'My trading setup that turned \$5k into \$42k in 6 months',
      'body':
          'I want to share the exact indicators and risk management rules I use. This is not financial advice — just my personal experience. The key was strict position sizing and...',
      'likes': 421,
      'replies': 88,
      'pinned': false,
    },
    {
      'author': 'NFTCollector',
      'avatar': 'NC',
      'avatarColor': Color(0xFFFD79A8),
      'time': '12 hours ago',
      'category': 'NFTs',
      'title': 'NFT market is quietly recovering — these collections are leading',
      'body':
          'After the 2023 bear market wiped out many projects, a select few NFT collections are showing real strength. Floor prices are up 40% this month for these specific projects...',
      'likes': 96,
      'replies': 21,
      'pinned': false,
    },
    {
      'author': 'BlockchainBob',
      'avatar': 'BB',
      'avatarColor': Color(0xFF55EFC4),
      'time': '1 day ago',
      'category': 'Bitcoin',
      'title': 'Beginner\'s guide to reading Bitcoin order books',
      'body':
          'Understanding order flow is one of the most underrated skills in crypto trading. I\'ll walk you through bid/ask spreads, market depth, and what large orders tell us...',
      'likes': 203,
      'replies': 56,
      'pinned': false,
    },
  ];

  final List<Map<String, dynamic>> _topMembers = [
    {'name': 'CryptoWhale', 'posts': 1243, 'avatar': 'CW', 'color': Color(0xFF6C5CE7)},
    {'name': 'ETHMaster', 'posts': 987, 'avatar': 'EM', 'color': Color(0xFF00CEC9)},
    {'name': 'DeFiDave', 'posts': 856, 'avatar': 'DD', 'color': Color(0xFFE17055)},
    {'name': 'SolanaKing', 'posts': 742, 'avatar': 'SK', 'color': Color(0xFF74B9FF)},
    {'name': 'BlockchainBob', 'posts': 631, 'avatar': 'BB', 'color': Color(0xFF55EFC4)},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredPosts {
    if (_selectedCategory == 0) return _posts;
    final cat = _categories[_selectedCategory];
    return _posts.where((p) => p['category'] == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Color(0xFF141416)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            _header(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _mainFeed()),
                  SizedBox(width: 20),
                  SizedBox(width: 240, child: _sidebar()),
                ],
              ),
            ),
            SizedBox(height: 30),
            FooterPage(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF18191D),
            Color(0xFF1a1a2e),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Community',
                    style: TextStyle(
                        color: white,
                        fontSize: kTextLarge,
                        fontWeight: fWLargeFont)),
                SizedBox(height: 6),
                Text(
                    'Join thousands of crypto enthusiasts. Share insights, learn, and grow together.',
                    style: TextStyle(
                        color: Colors.grey, fontSize: kTextSmaller)),
                SizedBox(height: 16),
                Row(
                  children: [
                    _statBadge('12.4K', 'Members'),
                    SizedBox(width: 20),
                    _statBadge('348', 'Posts Today'),
                    SizedBox(width: 20),
                    _statBadge('2.1K', 'Online Now'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add, size: 16),
            label: Text('New Post'),
            style: ElevatedButton.styleFrom(
              backgroundColor: amber,
              foregroundColor: black,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBadge(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: TextStyle(
                color: amber,
                fontSize: kTextSmall,
                fontWeight: fWLargeFont)),
        Text(label,
            style: TextStyle(color: Colors.grey, fontSize: kTextMini)),
      ],
    );
  }

  Widget _mainFeed() {
    return Column(
      children: [
        _categoryFilter(),
        SizedBox(height: 16),
        ..._filteredPosts.map((post) => Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: _postCard(post),
            )),
        if (_filteredPosts.isEmpty)
          Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Color(0xFF18191D),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.forum_outlined, color: Colors.grey, size: 48),
                  SizedBox(height: 12),
                  Text('No posts in this category yet.',
                      style: TextStyle(
                          color: Colors.grey, fontSize: kTextSmaller)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _categoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_categories.length, (i) {
          final isSelected = _selectedCategory == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? amber : Color(0xFF18191D),
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Text(_categories[i],
                  style: TextStyle(
                      color: isSelected ? black : Colors.grey,
                      fontSize: kTextSmaller,
                      fontWeight:
                          isSelected ? fWLargeFont : fWSmallFont)),
            ),
          );
        }),
      ),
    );
  }

  Widget _postCard(Map<String, dynamic> post) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF18191D),
        borderRadius: BorderRadius.circular(12),
        border: post['pinned'] == true
            ? Border.all(color: amber.withOpacity(0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post['pinned'] == true)
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(Icons.push_pin, color: amber, size: 14),
                  SizedBox(width: 4),
                  Text('Pinned Post',
                      style: TextStyle(color: amber, fontSize: kTextMini)),
                ],
              ),
            ),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: post['avatarColor'],
                child: Text(post['avatar'],
                    style: TextStyle(
                        color: white,
                        fontSize: kTextMini,
                        fontWeight: fWLargeFont)),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post['author'],
                        style: TextStyle(
                            color: white,
                            fontSize: kTextSmaller,
                            fontWeight: fWLargeFont)),
                    Text(post['time'],
                        style: TextStyle(
                            color: Colors.grey, fontSize: kTextMini)),
                  ],
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(post['category'],
                    style: TextStyle(
                        color: amber, fontSize: kTextMini)),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(post['title'],
              style: TextStyle(
                  color: white,
                  fontSize: kTextSmall,
                  fontWeight: fWLargeFont)),
          SizedBox(height: 6),
          Text(post['body'],
              style: TextStyle(
                  color: Colors.grey, fontSize: kTextSmaller),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
          SizedBox(height: 14),
          Row(
            children: [
              _actionBtn(Icons.thumb_up_outlined, '${post['likes']}',
                  Colors.grey),
              SizedBox(width: 16),
              _actionBtn(Icons.chat_bubble_outline, '${post['replies']}',
                  Colors.grey),
              SizedBox(width: 16),
              _actionBtn(Icons.share_outlined, 'Share', Colors.grey),
              Spacer(),
              TextButton(
                onPressed: () {},
                child: Text('Read more',
                    style:
                        TextStyle(color: amber, fontSize: kTextMini)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(width: 4),
          Text(label,
              style: TextStyle(color: color, fontSize: kTextMini)),
        ],
      ),
    );
  }

  Widget _sidebar() {
    return Column(
      children: [
        _topMembersCard(),
        SizedBox(height: 16),
        _joinDiscordCard(),
        SizedBox(height: 16),
        _rulesCard(),
      ],
    );
  }

  Widget _topMembersCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF18191D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Contributors',
              style: TextStyle(
                  color: white,
                  fontSize: kTextSmaller,
                  fontWeight: fWLargeFont)),
          SizedBox(height: 12),
          ...List.generate(_topMembers.length, (i) {
            final m = _topMembers[i];
            return Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text('${i + 1}',
                      style: TextStyle(
                          color: Colors.grey.withOpacity(0.5),
                          fontSize: kTextMini,
                          fontWeight: fWLargeFont),
                      textAlign: TextAlign.center),
                  SizedBox(width: 10),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: m['color'],
                    child: Text(m['avatar'],
                        style: TextStyle(
                            color: white,
                            fontSize: 10,
                            fontWeight: fWLargeFont)),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m['name'],
                            style: TextStyle(
                                color: white, fontSize: kTextMini)),
                        Text('${m['posts']} posts',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _joinDiscordCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5865F2), Color(0xFF7289DA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.discord, color: white, size: 28),
          SizedBox(height: 8),
          Text('Join our Discord',
              style: TextStyle(
                  color: white,
                  fontSize: kTextSmaller,
                  fontWeight: fWLargeFont)),
          SizedBox(height: 4),
          Text('Connect with 8,000+ traders in real time.',
              style: TextStyle(
                  color: white.withOpacity(0.8), fontSize: kTextMini)),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: white,
                foregroundColor: Color(0xFF5865F2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              child: Text('Join Now',
                  style: TextStyle(
                      fontWeight: fWLargeFont,
                      fontSize: kTextSmaller)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rulesCard() {
    final rules = [
      'Be respectful to all members',
      'No spam or self-promotion',
      'No financial advice — DYOR',
      'Keep discussions on-topic',
      'Report harmful content',
    ];
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF18191D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Community Rules',
              style: TextStyle(
                  color: white,
                  fontSize: kTextSmaller,
                  fontWeight: fWLargeFont)),
          SizedBox(height: 10),
          ...List.generate(rules.length, (i) => Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Text('${i + 1}.',
                        style: TextStyle(
                            color: amber,
                            fontSize: kTextMini,
                            fontWeight: fWLargeFont)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(rules[i],
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: kTextMini)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
