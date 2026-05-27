import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Reponsive/dimensions.dart';
import '../Utils/color/color.dart';
import '../Utils/dimens.dart';

class PriceTicker extends StatefulWidget {
  const PriceTicker({super.key});

  @override
  State<PriceTicker> createState() => _PriceTickerState();
}

class _PriceTickerState extends State<PriceTicker> {
  List<dynamic> _coins = [];
  bool _loading = true;
  bool _error = false;

  late ScrollController _scrollController;
  Timer? _scrollTimer;
  Timer? _refreshTimer;

  static const double _itemWidth = 230.0;
  static const double _scrollSpeed = 0.6; // pixels per tick
  static const int _tickMs = 16; // ~60fps

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fetchPrices();
    // Refresh data every 60 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _fetchPrices();
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _refreshTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchPrices() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        if (mounted) {
          setState(() {
            _coins = data;
            _loading = false;
            _error = false;
          });
          // Start scrolling once data is loaded
          _startScrolling();
        }
      } else {
        if (mounted) setState(() => _error = true);
      }
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  void _startScrolling() {
    _scrollTimer?.cancel();
    if (!_scrollController.hasClients || _coins.isEmpty) return;

    _scrollTimer = Timer.periodic(Duration(milliseconds: _tickMs), (_) {
      if (!_scrollController.hasClients) return;
      final max = _scrollController.position.maxScrollExtent;
      final current = _scrollController.offset;
      if (max <= 0) return;

      final next = current + _scrollSpeed;
      // When we reach the halfway point (the duplicate), jump back seamlessly
      if (next >= max / 2) {
        _scrollController.jumpTo(0);
      } else {
        _scrollController.jumpTo(next);
      }
    });
  }

  void _pauseScrolling() => _scrollTimer?.cancel();

  void _resumeScrolling() => _startScrolling();

  String _formatPrice(dynamic price) {
    if (price == null) return '--';
    final p = (price as num).toDouble();
    if (p >= 1000) {
      return '\$${p.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    } else if (p >= 1) {
      return '\$${p.toStringAsFixed(2)}';
    } else {
      return '\$${p.toStringAsFixed(6)}';
    }
  }

  String _formatChange(dynamic change) {
    if (change == null) return '0.00%';
    final c = (change as num).toDouble();
    final sign = c >= 0 ? '+' : '';
    return '$sign${c.toStringAsFixed(2)}%';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Only show on desktop
    if (width < mobileWidth) return const SizedBox.shrink();

    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF0E0F12),
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1),
          top: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1),
        ),
      ),
      child: _loading
          ? _buildLoadingShimmer()
          : _error
              ? _buildError()
              : _buildTicker(),
    );
  }

  Widget _buildTicker() {
    // Duplicate the list so we can scroll infinitely
    final doubled = [..._coins, ..._coins];

    return MouseRegion(
      onEnter: (_) => _pauseScrolling(),
      onExit: (_) => _resumeScrolling(),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: doubled.length,
        itemBuilder: (context, index) {
          final coin = doubled[index];
          final change = coin['price_change_percentage_24h'];
          final isPositive = change != null && (change as num) >= 0;
          final changeColor = isPositive ? const Color(0xFF00C076) : const Color(0xFFFF4747);

          return SizedBox(
            width: _itemWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Divider
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey.withOpacity(0.15),
                  margin: const EdgeInsets.only(right: 12),
                ),
                // Icon
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CachedNetworkImage(
                    imageUrl: coin['image'] ?? '',
                    width: 18,
                    height: 18,
                    errorWidget: (_, __, ___) => Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: amber.withOpacity(0.2),
                      ),
                      child: Icon(Icons.currency_bitcoin,
                          size: 10, color: amber),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Symbol
                Text(
                  (coin['symbol'] as String).toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFB1B5C3),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 6),
                // Price
                Text(
                  _formatPrice(coin['current_price']),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 5),
                // Change badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: changeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatChange(change),
                    style: TextStyle(
                      color: changeColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      itemBuilder: (_, i) => SizedBox(
        width: _itemWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 1,
              height: 20,
              color: Colors.grey.withOpacity(0.15),
              margin: const EdgeInsets.only(right: 12),
            ),
            _shimmerBox(18, 18, circular: true),
            const SizedBox(width: 8),
            _shimmerBox(30, 10),
            const SizedBox(width: 6),
            _shimmerBox(60, 10),
            const SizedBox(width: 5),
            _shimmerBox(40, 14),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox(double w, double h, {bool circular = false}) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        borderRadius: circular
            ? BorderRadius.circular(9999)
            : BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_outlined,
              color: Colors.grey.withOpacity(0.5), size: 14),
          const SizedBox(width: 6),
          Text(
            'Live prices unavailable — tap to retry',
            style: TextStyle(
                color: Colors.grey.withOpacity(0.5), fontSize: kTextMini),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _loading = true;
                _error = false;
              });
              _fetchPrices();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: amber.withOpacity(0.3)),
              ),
              child: Text('Retry',
                  style: TextStyle(
                      color: amber,
                      fontSize: kTextMini,
                      fontWeight: fWLargeFont)),
            ),
          ),
        ],
      ),
    );
  }
}
