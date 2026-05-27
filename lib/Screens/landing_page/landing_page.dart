import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../Reponsive/dimensions.dart';
import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import '../../Widgets/footer_page.dart';
import '../../Widgets/subCont.dart';
import '../../providers/general_provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  List<dynamic> _liveCoins = [];
  late AnimationController _heroAnim;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;

  @override
  void initState() {
    super.initState();
    _heroAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _heroFade = CurvedAnimation(parent: _heroAnim, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(
            begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _heroAnim, curve: Curves.easeOut));
    _heroAnim.forward();
    _fetchCoins();
  }

  @override
  void dispose() {
    _heroAnim.dispose();
    super.dispose();
  }

  Future<void> _fetchCoins() async {
    try {
      final res = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd'
          '&order=market_cap_desc&per_page=8&page=1&sparkline=false'));
      if (res.statusCode == 200 && mounted) {
        setState(() => _liveCoins = json.decode(res.body));
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= mobileWidth;
    final pad = isDesktop ? 60.0 : 20.0;

    return ListView(
      children: [
        _hero(isDesktop, pad),
        _statsBar(isDesktop),
        _liveMarketStrip(isDesktop, pad),
        _features(isDesktop, pad),
        _howItWorks(isDesktop, pad),
        _testimonials(isDesktop, pad),
        _appCta(isDesktop, pad),
        SubscriptionCont(),
        FooterPage(),
      ],
    );
  }

  // ─── HERO ────────────────────────────────────────────────────────────────
  Widget _hero(bool isDesktop, double pad) {
    return FadeTransition(
      opacity: _heroFade,
      child: SlideTransition(
        position: _heroSlide,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: pad, vertical: isDesktop ? 70 : 40),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF141416), Color(0xFF0e0e12)],
            ),
          ),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: _heroText(isDesktop)),
                    const SizedBox(width: 48),
                    Expanded(flex: 4, child: _heroPriceCards()),
                  ],
                )
              : Column(
                  children: [
                    _heroText(isDesktop),
                    const SizedBox(height: 36),
                    _heroPriceCards(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _heroText(bool isDesktop) {
    final prov = Provider.of<GeneralProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: amber.withOpacity(0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                      color: Color(0xFF00C076), shape: BoxShape.circle)),
              const SizedBox(width: 7),
              Text('Markets are open · Live prices',
                  style: TextStyle(
                      color: amber,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Trade Crypto\nWith Confidence.',
          style: TextStyle(
            color: white,
            fontSize: isDesktop ? 50 : 34,
            fontWeight: FontWeight.w800,
            height: 1.12,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (r) => LinearGradient(
            colors: [amber, const Color(0xFFFF8C00)],
          ).createShader(r),
          child: Text(
            'Zero fees. Real-time data.',
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 28 : 20,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Buy, sell, and receive 300+ cryptocurrencies in minutes.\nWorld-class security, instant transfers, and no hidden fees.',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: isDesktop ? 15 : 14,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 14,
          runSpacing: 12,
          children: [
            _heroCta(
              label: 'Get Started Free',
              filled: true,
              onTap: () => prov.setPage(data: 'loginPage'),
            ),
            _heroCta(
              label: 'View Markets',
              filled: false,
              onTap: () => prov.setPage(data: 'market'),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _trustBadges(),
      ],
    );
  }

  Widget _heroCta(
      {required String label,
      required bool filled,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: filled ? amber : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: filled ? amber : Colors.grey.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: filled ? black : white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _trustBadges() {
    final badges = [
      {'icon': Icons.verified_user_outlined, 'label': 'Regulated & Licensed'},
      {'icon': Icons.lock_outline, 'label': '256-bit SSL'},
      {'icon': Icons.support_agent, 'label': '24/7 Support'},
    ];
    return Wrap(
      spacing: 20,
      runSpacing: 10,
      children: badges.map((b) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(b['icon'] as IconData,
              color: Colors.grey[500], size: 14),
          const SizedBox(width: 5),
          Text(b['label'] as String,
              style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      )).toList(),
    );
  }

  Widget _heroPriceCards() {
    final featured = _liveCoins.isEmpty
        ? [
            {'symbol': 'BTC', 'name': 'Bitcoin', 'current_price': null, 'price_change_percentage_24h': null},
            {'symbol': 'ETH', 'name': 'Ethereum', 'current_price': null, 'price_change_percentage_24h': null},
            {'symbol': 'SOL', 'name': 'Solana', 'current_price': null, 'price_change_percentage_24h': null},
          ]
        : _liveCoins.take(3).toList();

    return Column(
      children: [
        // Main glow card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF18191D),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: amber.withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                color: amber.withOpacity(0.06),
                blurRadius: 40,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Color(0xFF00C076), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 7),
                  Text('Live Prices',
                      style: TextStyle(
                          color: Colors.grey[400], fontSize: 12)),
                  const Spacer(),
                  Text('Updated just now',
                      style: TextStyle(
                          color: Colors.grey[600], fontSize: 11)),
                ],
              ),
              const SizedBox(height: 20),
              ...featured.asMap().entries.map((e) {
                final i = e.key;
                final coin = e.value;
                final change =
                    coin['price_change_percentage_24h'] as double?;
                final isUp = change == null || change >= 0;
                final changeColor = isUp
                    ? const Color(0xFF00C076)
                    : const Color(0xFFFF4747);
                return Column(
                  children: [
                    if (i > 0)
                      Divider(
                          height: 20,
                          color: Colors.grey.withOpacity(0.08)),
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: amber.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (coin['symbol'] as String)
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: amber,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (coin['symbol'] as String).toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ),
                            Text(
                              coin['name'] as String? ?? '',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 11),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              coin['current_price'] != null
                                  ? _fmtPrice(coin['current_price'])
                                  : '---',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: changeColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                change != null
                                    ? '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%'
                                    : '--',
                                style: TextStyle(
                                    color: changeColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),
              _miniBarChart(),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Small stat cards row
        Row(
          children: [
            Expanded(child: _miniStatCard('2.5M+', 'Active Users', Icons.people_outline)),
            const SizedBox(width: 10),
            Expanded(child: _miniStatCard('\$10B+', 'Daily Volume', Icons.bar_chart)),
          ],
        ),
      ],
    );
  }

  Widget _miniBarChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Portfolio growth (simulated)',
            style: TextStyle(color: Colors.grey[600], fontSize: 10)),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          child: CustomPaint(painter: _BarChartPainter()),
        ),
      ],
    );
  }

  Widget _miniStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF18191D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, color: amber, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800)),
              Text(label,
                  style: TextStyle(color: Colors.grey[500], fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  // ─── STATS BAR ────────────────────────────────────────────────────────────
  Widget _statsBar(bool isDesktop) {
    final stats = [
      {'value': '2.5M+', 'label': 'Active Users', 'icon': Icons.people_outline},
      {'value': '150+', 'label': 'Countries', 'icon': Icons.public},
      {'value': '300+', 'label': 'Coins Listed', 'icon': Icons.monetization_on_outlined},
      {'value': '\$10B+', 'label': 'Daily Volume', 'icon': Icons.trending_up},
      {'value': '0%', 'label': 'Recurring Fees', 'icon': Icons.star_outline},
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E0F12),
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.grey.withOpacity(0.08)),
        ),
      ),
      padding: EdgeInsets.symmetric(
          vertical: 24, horizontal: isDesktop ? 60 : 20),
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: stats.map((s) => _statItem(s)).toList(),
            )
          : GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: stats.map((s) => _statItem(s)).toList(),
            ),
    );
  }

  Widget _statItem(Map<String, dynamic> s) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: amber.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(s['icon'] as IconData, color: amber, size: 16),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(s['value'] as String,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800)),
            Text(s['label'] as String,
                style: TextStyle(color: Colors.grey[500], fontSize: 11)),
          ],
        ),
      ],
    );
  }

  // ─── LIVE MARKET STRIP ───────────────────────────────────────────────────
  Widget _liveMarketStrip(bool isDesktop, double pad) {
    return Container(
      color: const Color(0xFF141416),
      padding: EdgeInsets.symmetric(
          horizontal: pad, vertical: isDesktop ? 60 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Live Market', 'Real-time prices updated every minute'),
          const SizedBox(height: 28),
          _liveCoins.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: CircularProgressIndicator(color: amber, strokeWidth: 2),
                  ),
                )
              : Column(
                  children: [
                    // Header row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: Text('Asset',
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 11,
                                      fontWeight: FontWeight.w600))),
                          Expanded(
                              flex: 2,
                              child: Text('Price',
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 11,
                                      fontWeight: FontWeight.w600))),
                          if (isDesktop)
                            Expanded(
                                flex: 2,
                                child: Text('Market Cap',
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600))),
                          Expanded(
                              flex: 2,
                              child: Text('24h Change',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 11,
                                      fontWeight: FontWeight.w600))),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF18191D),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.08)),
                      ),
                      child: Column(
                        children: _liveCoins.take(5).toList().asMap().entries.map((e) {
                          final i = e.key;
                          final coin = e.value;
                          final change = coin['price_change_percentage_24h'] as double? ?? 0;
                          final isUp = change >= 0;
                          final cc = isUp ? const Color(0xFF00C076) : const Color(0xFFFF4747);
                          return Column(
                            children: [
                              if (i > 0)
                                const Divider(height: 1, color: Color(0xFF222226)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Row(children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: amber.withOpacity(0.08),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              (coin['symbol'] as String).substring(0, 1).toUpperCase(),
                                              style: TextStyle(color: amber, fontWeight: FontWeight.w800, fontSize: 13),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text((coin['symbol'] as String).toUpperCase(),
                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                                            Text(coin['name'] as String? ?? '',
                                                style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                                          ],
                                        ),
                                      ]),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _fmtPrice(coin['current_price']),
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                                      ),
                                    ),
                                    if (isDesktop)
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          _fmtLarge(coin['market_cap']),
                                          style: TextStyle(color: Colors.grey[400], fontSize: 13),
                                        ),
                                      ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: cc.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: cc, size: 16),
                                              Text('${change.abs().toStringAsFixed(2)}%',
                                                  style: TextStyle(color: cc, fontSize: 12, fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Provider.of<GeneralProvider>(context, listen: false)
                            .setPage(data: 'market'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: amber.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: amber.withOpacity(0.25)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('View all markets',
                                  style: TextStyle(
                                      color: amber,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(width: 6),
                              Icon(Icons.arrow_forward, color: amber, size: 14),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // ─── FEATURES ─────────────────────────────────────────────────────────────
  Widget _features(bool isDesktop, double pad) {
    final features = [
      {
        'icon': Icons.money_off_csred_outlined,
        'title': 'Zero Recurring Fees',
        'desc': 'Set up recurring crypto purchases and pay absolutely nothing. No hidden charges, ever.',
        'color': const Color(0xFF00C076),
      },
      {
        'icon': Icons.shield_outlined,
        'title': 'Military-Grade Security',
        'desc': '95% of funds in cold storage. Multi-sig wallets, 2FA, and real-time fraud monitoring.',
        'color': const Color(0xFF3B82F6),
      },
      {
        'icon': Icons.bolt_outlined,
        'title': 'Instant Transfers',
        'desc': 'Send crypto to anyone in the world in seconds, regardless of borders or time zones.',
        'color': amber,
      },
      {
        'icon': Icons.support_agent,
        'title': '24/7 Live Support',
        'desc': 'Real humans available around the clock via live chat, email, and community forums.',
        'color': const Color(0xFFFF6B6B),
      },
      {
        'icon': Icons.bar_chart,
        'title': 'Real-Time Market Data',
        'desc': 'Live prices, depth charts, and portfolio analytics so you can trade with confidence.',
        'color': const Color(0xFFAB5CF7),
      },
      {
        'icon': Icons.verified_outlined,
        'title': 'Regulatory Compliant',
        'desc': 'Licensed and regulated in 150+ countries. Your funds are protected by industry-leading standards.',
        'color': const Color(0xFF06B6D4),
      },
    ];

    return Container(
      color: const Color(0xFF0E0F12),
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: isDesktop ? 70 : 40),
      child: Column(
        children: [
          _sectionHeader('Why CryptoUSD?', 'Everything you need to trade smarter'),
          const SizedBox(height: 36),
          isDesktop
              ? _featureGrid(features, 3)
              : _featureGrid(features, 1),
        ],
      ),
    );
  }

  Widget _featureGrid(List<Map<String, dynamic>> features, int cols) {
    final rows = <Widget>[];
    for (int i = 0; i < features.length; i += cols) {
      final rowItems = features.skip(i).take(cols).toList();
      rows.add(Row(
        children: rowItems.asMap().entries.map((e) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: e.key < rowItems.length - 1 ? 16 : 0,
                bottom: 16,
              ),
              child: _featureCard(e.value),
            ),
          );
        }).toList(),
      ));
    }
    return Column(children: rows);
  }

  Widget _featureCard(Map<String, dynamic> f) {
    final color = f['color'] as Color;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF18191D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(f['icon'] as IconData, color: color, size: 22),
          ),
          const SizedBox(height: 16),
          Text(f['title'] as String,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(f['desc'] as String,
              style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 13,
                  height: 1.6)),
        ],
      ),
    );
  }

  // ─── HOW IT WORKS ─────────────────────────────────────────────────────────
  Widget _howItWorks(bool isDesktop, double pad) {
    final steps = [
      {
        'step': '01',
        'icon': Icons.person_add_outlined,
        'title': 'Create Your Account',
        'desc': 'Sign up in under 2 minutes with just your email. Verify your identity to unlock full trading features.',
      },
      {
        'step': '02',
        'icon': Icons.account_balance_wallet_outlined,
        'title': 'Deposit Funds',
        'desc': 'Add crypto from any wallet or exchange. We support 300+ assets with deposits confirming in minutes.',
      },
      {
        'step': '03',
        'icon': Icons.trending_up,
        'title': 'Start Trading',
        'desc': 'Buy, sell, and manage your portfolio with real-time data, limit orders, and zero recurring fees.',
      },
    ];

    return Container(
      color: const Color(0xFF141416),
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: isDesktop ? 70 : 40),
      child: Column(
        children: [
          _sectionHeader('How It Works', 'Three simple steps to get started'),
          const SizedBox(height: 40),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: steps.asMap().entries.map((e) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: e.key < steps.length - 1 ? 24 : 0),
                      child: _stepCard(e.value, e.key, steps.length, isDesktop),
                    ),
                  )).toList(),
                )
              : Column(
                  children: steps.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _stepCard(e.value, e.key, steps.length, isDesktop),
                  )).toList(),
                ),
        ],
      ),
    );
  }

  Widget _stepCard(Map<String, dynamic> step, int idx, int total, bool isDesktop) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF18191D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.07)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(step['icon'] as IconData, color: amber, size: 22),
                  ),
                  const Spacer(),
                  Text(
                    step['step'] as String,
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.12),
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(step['title'] as String,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(step['desc'] as String,
                  style: TextStyle(
                      color: Colors.grey[500], fontSize: 13, height: 1.65)),
            ],
          ),
        ),
        if (isDesktop && idx < total - 1)
          Positioned(
            right: -13,
            top: 38,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFF141416),
                border: Border.all(color: Colors.grey.withOpacity(0.15)),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward,
                  size: 12, color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }

  // ─── TESTIMONIALS ─────────────────────────────────────────────────────────
  Widget _testimonials(bool isDesktop, double pad) {
    final reviews = [
      {
        'name': 'Marcus T.',
        'role': 'Day Trader · New York',
        'rating': 5,
        'text': 'The real-time market data and zero recurring fees have transformed how I trade. Switched from Binance 6 months ago and never looked back. The sparkline charts on the market page are a great touch.',
        'initials': 'MT',
      },
      {
        'name': 'Sofia R.',
        'role': 'Portfolio Investor · London',
        'rating': 5,
        'text': 'I love that my funds are safe with cold storage and 2FA. The support team responded to my KYC query in under an hour. The interface is clean and fast — exactly what I was looking for.',
        'initials': 'SR',
      },
      {
        'name': 'James K.',
        'role': 'Crypto Enthusiast · Lagos',
        'rating': 5,
        'text': 'CryptoUSD actually works in Nigeria — that alone made me a customer. The instant transfer feature is phenomenal. Sent BTC in under 10 minutes with confirmation. Incredibly reliable.',
        'initials': 'JK',
      },
    ];

    return Container(
      color: const Color(0xFF0E0F12),
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: isDesktop ? 70 : 40),
      child: Column(
        children: [
          _sectionHeader('What Our Users Say', 'Trusted by 2.5 million traders worldwide'),
          const SizedBox(height: 36),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: reviews.asMap().entries.map((e) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: e.key < reviews.length - 1 ? 16 : 0),
                      child: _reviewCard(e.value),
                    ),
                  )).toList(),
                )
              : Column(
                  children: reviews.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _reviewCard(r),
                  )).toList(),
                ),
        ],
      ),
    );
  }

  Widget _reviewCard(Map<String, dynamic> r) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF18191D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(5, (i) => Icon(
              i < (r['rating'] as int) ? Icons.star : Icons.star_border,
              color: amber,
              size: 16,
            )),
          ),
          const SizedBox(height: 14),
          Text(
            '"${r['text']}"',
            style: TextStyle(
                color: Colors.grey[300], fontSize: 13, height: 1.7),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: amber.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(r['initials'] as String,
                      style: TextStyle(
                          color: amber,
                          fontWeight: FontWeight.w800,
                          fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r['name'] as String,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  Text(r['role'] as String,
                      style: TextStyle(
                          color: Colors.grey[500], fontSize: 11)),
                ],
              ),
              const Spacer(),
              Icon(Icons.verified, color: amber, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  // ─── APP CTA ──────────────────────────────────────────────────────────────
  Widget _appCta(bool isDesktop, double pad) {
    final prov = Provider.of<GeneralProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: pad, vertical: isDesktop ? 60 : 36),
      padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 60 : 28, vertical: isDesktop ? 56 : 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF18191D),
            const Color(0xFF1a1400),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: amber.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: amber.withOpacity(0.04),
            blurRadius: 60,
            spreadRadius: 8,
          ),
        ],
      ),
      child: isDesktop
          ? Row(
              children: [
                Expanded(flex: 3, child: _ctaText(prov)),
                const SizedBox(width: 40),
                Expanded(flex: 2, child: _platformBadges()),
              ],
            )
          : Column(
              children: [
                _ctaText(prov),
                const SizedBox(height: 30),
                _platformBadges(),
              ],
            ),
    );
  }

  Widget _ctaText(GeneralProvider prov) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (r) => LinearGradient(
            colors: [amber, const Color(0xFFFF8C00)],
          ).createShader(r),
          child: const Text(
            'Start Trading Today',
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                height: 1.2),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Join 2.5 million users already trading smarter with CryptoUSD. No credit card required. Free forever.',
          style: TextStyle(color: Colors.grey[400], fontSize: 14, height: 1.6),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => prov.setPage(data: 'loginPage'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
            decoration: BoxDecoration(
              color: amber,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('Create Free Account',
                style: const TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w800,
                    fontSize: 15)),
          ),
        ),
      ],
    );
  }

  Widget _platformBadges() {
    final platforms = [
      {'icon': Icons.language, 'label': 'Web App', 'sub': 'Any browser, no install'},
      {'icon': Icons.phone_iphone, 'label': 'iOS App', 'sub': 'Coming to App Store'},
      {'icon': Icons.android, 'label': 'Android', 'sub': 'Coming to Google Play'},
    ];
    return Column(
      children: platforms.map((p) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF141416),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(p['icon'] as IconData, color: amber, size: 22),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['label'] as String,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                Text(p['sub'] as String,
                    style: TextStyle(color: Colors.grey[500], fontSize: 11)),
              ],
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey[700], size: 18),
          ],
        ),
      )).toList(),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5)),
        const SizedBox(height: 6),
        Text(sub,
            style: TextStyle(color: Colors.grey[500], fontSize: 14)),
      ],
    );
  }

  String _fmtPrice(dynamic v) {
    if (v == null) return '--';
    final d = (v as num).toDouble();
    if (d >= 1000)
      return '\$${d.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    if (d >= 1) return '\$${d.toStringAsFixed(2)}';
    return '\$${d.toStringAsFixed(6)}';
  }

  String _fmtLarge(dynamic v) {
    if (v == null) return '--';
    final d = (v as num).toDouble();
    if (d >= 1e12) return '\$${(d / 1e12).toStringAsFixed(2)}T';
    if (d >= 1e9) return '\$${(d / 1e9).toStringAsFixed(2)}B';
    if (d >= 1e6) return '\$${(d / 1e6).toStringAsFixed(2)}M';
    return '\$${d.toStringAsFixed(0)}';
  }
}

// ─── BAR CHART PAINTER ────────────────────────────────────────────────────
class _BarChartPainter extends CustomPainter {
  final List<double> _values;

  _BarChartPainter()
      : _values = List.generate(
            14,
            (i) => 0.3 +
                0.6 *
                    ((sin(i * 0.7) + cos(i * 0.4) + 2) /
                        4));

  @override
  void paint(Canvas canvas, Size size) {
    final barW = size.width / (_values.length * 1.6);
    final gap = barW * 0.6;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < _values.length; i++) {
      final x = i * (barW + gap);
      final h = _values[i] * size.height;
      final isUp = i > 0 && _values[i] >= _values[i - 1];
      paint.color = isUp
          ? const Color(0xFF00C076).withOpacity(0.75)
          : const Color(0xFFFF4747).withOpacity(0.65);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - h, barW, h),
          const Radius.circular(3),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter old) => false;
}
