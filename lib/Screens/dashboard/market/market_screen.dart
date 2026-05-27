import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../Mobile_widgets/local_widgets/mobile_footer.dart';
import '../../../Reponsive/dimensions.dart';
import '../../../Utils/color/color.dart';
import '../../../Utils/dimens.dart';
import '../../../Widgets/footer_page.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  List<dynamic> cryptoData = [];
  bool isLoading = true;
  bool hasError = false;
  String _sortColumn = 'market_cap';
  bool _sortAscending = false;

  @override
  void initState() {
    super.initState();
    fetchCryptoData();
  }

  Future<void> fetchCryptoData() async {
    setState(() { isLoading = true; hasError = false; });
    try {
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd'
          '&order=market_cap_desc&per_page=25&page=1&sparkline=true'));
      if (response.statusCode == 200) {
        setState(() {
          cryptoData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() { isLoading = false; hasError = true; });
      }
    } catch (_) {
      setState(() { isLoading = false; hasError = true; });
    }
  }

  String _fmtPrice(dynamic v) {
    if (v == null) return '--';
    final d = (v as num).toDouble();
    if (d >= 1000) return '\$${d.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    if (d >= 1) return '\$${d.toStringAsFixed(2)}';
    return '\$${d.toStringAsFixed(6)}';
  }

  String _fmtLarge(dynamic v) {
    if (v == null) return '--';
    final d = (v as num).toDouble();
    if (d >= 1e12) return '\$${(d / 1e12).toStringAsFixed(2)}T';
    if (d >= 1e9)  return '\$${(d / 1e9).toStringAsFixed(2)}B';
    if (d >= 1e6)  return '\$${(d / 1e6).toStringAsFixed(2)}M';
    return '\$${d.toStringAsFixed(0)}';
  }

  double get _totalMarketCap {
    if (cryptoData.isEmpty) return 0;
    return cryptoData.fold(0.0, (sum, c) => sum + (c['market_cap'] ?? 0));
  }

  double get _btcDominance {
    if (cryptoData.isEmpty) return 0;
    final total = _totalMarketCap;
    if (total == 0) return 0;
    final btc = cryptoData.firstWhere(
        (c) => c['symbol'] == 'btc', orElse: () => null);
    if (btc == null) return 0;
    return ((btc['market_cap'] ?? 0) / total) * 100;
  }

  int get _gainers {
    return cryptoData.where((c) =>
        (c['price_change_percentage_24h'] ?? 0) >= 0).length;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= mobileWidth;

    return Container(
      width: width,
      color: const Color(0xFF141416),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildPageHeader(isDesktop),
            const SizedBox(height: 20),
            if (!isLoading && !hasError) _buildStatsRow(isDesktop),
            const SizedBox(height: 24),
            if (isLoading) _buildLoading(),
            if (hasError) _buildError(),
            if (!isLoading && !hasError) _buildTable(isDesktop),
            const SizedBox(height: 30),
            isDesktop ? FooterPage() : MobileFooterPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cryptocurrency Markets',
                  style: TextStyle(
                      color: white,
                      fontSize: isDesktop ? 26 : 20,
                      fontWeight: fWLargeFont)),
              const SizedBox(height: 4),
              Text('Top 25 coins by market capitalization · Live prices',
                  style: TextStyle(
                      color: Colors.grey[500], fontSize: kTextSmaller)),
            ],
          ),
          TextButton.icon(
            onPressed: fetchCryptoData,
            icon: Icon(Icons.refresh, size: 16, color: amber),
            label: Text('Refresh',
                style: TextStyle(color: amber, fontSize: kTextSmaller)),
            style: TextButton.styleFrom(
              backgroundColor: amber.withOpacity(0.08),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isDesktop) {
    final stats = [
      {
        'label': 'Total Market Cap',
        'value': _fmtLarge(_totalMarketCap),
        'icon': Icons.pie_chart_outline,
      },
      {
        'label': 'BTC Dominance',
        'value': '${_btcDominance.toStringAsFixed(1)}%',
        'icon': Icons.currency_bitcoin,
      },
      {
        'label': 'Gainers (24h)',
        'value': '$_gainers / ${cryptoData.length}',
        'icon': Icons.trending_up,
      },
      {
        'label': 'Coins Tracked',
        'value': '${cryptoData.length}',
        'icon': Icons.bar_chart,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16),
      child: isDesktop
          ? Row(
              children: stats
                  .map((s) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _statCard(s),
                        ),
                      ))
                  .toList(),
            )
          : GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
              children: stats.map((s) => _statCard(s)).toList(),
            ),
    );
  }

  Widget _statCard(Map<String, dynamic> s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF18191D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(s['icon'] as IconData, color: amber, size: 16),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(s['label'] as String,
                  style: TextStyle(
                      color: Colors.grey[500], fontSize: 10)),
              const SizedBox(height: 2),
              Text(s['value'] as String,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      height: 300,
      child: Center(
        child: CircularProgressIndicator(color: amber),
      ),
    );
  }

  Widget _buildError() {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, color: Colors.grey[600], size: 48),
            const SizedBox(height: 16),
            Text('Could not load market data',
                style: TextStyle(color: Colors.grey[400], fontSize: 14)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: fetchCryptoData,
              style: ElevatedButton.styleFrom(
                  backgroundColor: amber, foregroundColor: black),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF18191D),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.08)),
        ),
        child: Column(
          children: [
            _tableHeader(isDesktop),
            const Divider(height: 1, color: Color(0xFF222226)),
            ...cryptoData.asMap().entries.map((e) =>
                _tableRow(e.key, e.value, isDesktop)),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader(bool isDesktop) {
    final cols = isDesktop
        ? ['#', 'Asset', 'Price', '24h Change', 'Market Cap', '24h Volume', '7d Chart']
        : ['Asset', 'Price', '24h'];
    final flexes = isDesktop ? [1, 3, 2, 2, 2, 2, 2] : [3, 2, 1];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(cols.length, (i) => Expanded(
          flex: flexes[i],
          child: Text(cols[i],
              style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5)),
        )),
      ),
    );
  }

  Widget _tableRow(int rank, dynamic coin, bool isDesktop) {
    final change = (coin['price_change_percentage_24h'] ?? 0.0) as double;
    final isUp = change >= 0;
    final changeColor = isUp ? const Color(0xFF00C076) : const Color(0xFFFF4747);

    final sparkPrices = (coin['sparkline_in_7d']?['price'] as List<dynamic>?)
        ?.map((v) => (v as num).toDouble())
        .toList();

    return Column(
      children: [
        InkWell(
          onTap: () {},
          hoverColor: Colors.white.withOpacity(0.02),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: isDesktop
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text('${rank + 1}',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12)),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: coin['image'] ?? '',
                              width: 28,
                              height: 28,
                              errorWidget: (_, __, ___) => Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: amber.withOpacity(0.1),
                                ),
                                child: Icon(Icons.currency_bitcoin,
                                    size: 14, color: amber),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    (coin['name'] as String? ?? '').length > 14
                                        ? (coin['name'] as String)
                                            .substring(0, 14)
                                        : (coin['name'] as String? ?? ''),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    (coin['symbol'] as String? ?? '')
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(_fmtPrice(coin['current_price']),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: changeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                  isUp
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: changeColor,
                                  size: 16),
                              Text(
                                  '${change.abs().toStringAsFixed(2)}%',
                                  style: TextStyle(
                                      color: changeColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(_fmtLarge(coin['market_cap']),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(_fmtLarge(coin['total_volume']),
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 13)),
                      ),
                      Expanded(
                        flex: 2,
                        child: sparkPrices != null && sparkPrices.length > 1
                            ? SizedBox(
                                width: 80,
                                height: 36,
                                child: CustomPaint(
                                  painter: _SparklinePainter(
                                      sparkPrices, changeColor),
                                ),
                              )
                            : Text('--',
                                style: TextStyle(color: Colors.grey[600])),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: coin['image'] ?? '',
                              width: 24,
                              height: 24,
                              errorWidget: (_, __, ___) => Icon(
                                  Icons.currency_bitcoin,
                                  size: 20,
                                  color: amber),
                            ),
                            const SizedBox(width: 8),
                            Text(
                                (coin['symbol'] as String? ?? '')
                                    .toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(_fmtPrice(coin['current_price']),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                            '${isUp ? '+' : ''}${change.toStringAsFixed(2)}%',
                            style: TextStyle(
                                color: changeColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFF222226)),
      ],
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> prices;
  final Color color;
  _SparklinePainter(this.prices, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (prices.length < 2) return;

    final minP = prices.reduce(min);
    final maxP = prices.reduce(max);
    final range = maxP - minP;
    if (range == 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.2), color.withOpacity(0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final step = size.width / (prices.length - 1);
    for (int i = 0; i < prices.length; i++) {
      final x = i * step;
      final y = size.height - ((prices[i] - minP) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.prices != prices || old.color != color;
}
