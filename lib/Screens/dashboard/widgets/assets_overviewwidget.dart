import 'package:Cryptousd/providers/general_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class AssetOverviewWidget extends StatefulWidget {
  // final double totalBalance;

  // const AssetOverviewWidget({
  //   Key? key,
  //   required this.totalBalance,
  // }) : super(key: key);

  // Static values
  static const double percentageChange = 6.3;
  static const String currency = 'USDT';
  static const List<double> chartData = [4.0, 3.0, 6.0, 7.0, 5.0, 6.0, 8.0];
  static const String bottomValue = '\$6,100.23';

  @override
  State<AssetOverviewWidget> createState() => _AssetOverviewWidgetState();
}

class _AssetOverviewWidgetState extends State<AssetOverviewWidget> {
  String userBalance = '0.0'; // e.g. 200.0

  Future<void> updateUserBalance() async {
    final cryptosRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cryptos');

    final cryptosSnapshot = await cryptosRef.get();

    double totalBalance = 0.0;

    for (var cryptoDoc in cryptosSnapshot.docs) {
      final rawUsdValue = cryptoDoc['usdValue'];

      // Convert to double safely
      double usdValue = 0.0;
      if (rawUsdValue is String) {
        usdValue = double.tryParse(rawUsdValue) ?? 0.0;
      } else if (rawUsdValue is num) {
        usdValue = rawUsdValue.toDouble();
      }

      totalBalance += usdValue;
    }

    setState(() {
      userBalance = totalBalance.toString();
      Provider.of<GeneralProvider>(context, listen: false)
          .setUserBalance(data: userBalance);
      print(
          "userBalace=========================---------===========> ${Provider.of<GeneralProvider>(context, listen: false).setUserBalance(data: userBalance)}");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUserBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF18191D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Total Asset',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.visibility_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AssetOverviewWidget.currency,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Asset Value and Percentage
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${double.tryParse(userBalance)?.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${AssetOverviewWidget.percentageChange > 0 ? '+' : ''}${AssetOverviewWidget.percentageChange.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: AssetOverviewWidget.percentageChange > 0
                      ? Colors.green
                      : Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                AssetOverviewWidget.percentageChange > 0
                    ? Icons.trending_up
                    : Icons.trending_down,
                color: AssetOverviewWidget.percentageChange > 0
                    ? Colors.green
                    : Colors.red,
                size: 16,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Chart
          SizedBox(
            height: 120,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: LineChartPainter(AssetOverviewWidget.chartData),
            ),
          ),

          const SizedBox(height: 16),

          // Date Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('09/8', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text('09/9', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text('09/10', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text('09/11', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text('09/12', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text('09/13', style: TextStyle(color: Colors.grey, fontSize: 10)),
              Text('09/14', style: TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),

          const SizedBox(height: 16),

          // Bottom value with highlight
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  AssetOverviewWidget.bottomValue,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;

  LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 0.5;

    // Draw horizontal grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Line paint
    final linePaint = Paint()
      ..color = const Color(0xFFFFD700) // Golden yellow
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Dot paint
    final dotPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = const Color(0xFF2C2C2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Calculate points
    final minValue = data.reduce(math.min);
    final maxValue = data.reduce(math.max);
    final valueRange = maxValue - minValue;

    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final normalizedValue =
          valueRange == 0 ? 0.5 : (data[i] - minValue) / valueRange;
      final y = size.height -
          (normalizedValue * size.height * 0.8) -
          (size.height * 0.1);
      points.add(Offset(x, y));
    }

    // Draw line segments
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, linePaint);

    // Draw dots
    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(point, 4, dotBorderPaint);
    }

    // Highlight specific point (middle point)
    if (points.length > 3) {
      final highlightPoint = points[3]; // 4th point (09/11)
      final highlightPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;

      canvas.drawCircle(highlightPoint, 6, highlightPaint);
      canvas.drawCircle(highlightPoint, 6, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Example usage
class AssetTrackerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: AssetOverviewWidget(),
        ),
      ),
    );
  }
}
