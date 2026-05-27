import 'dart:async';

import 'package:flutter/material.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon or Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.construction,
                  size: 40,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'We\'ll be back soon!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Message
              const Text(
                'Our team is working hard to improve your experience.\nWe’ll be back online shortly.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFAAAAAA),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Optional: Countdown Timer (uncomment to use)
              /*
              const _CountdownTimer(
                targetDateTime: DateTime(2025, 6, 15, 14, 0), // YYYY, MM, DD, HH, MM
              ),
              const SizedBox(height: 24),
              */

              // Contact Info
              // RichText(
              //   textAlign: TextAlign.center,
              //   text: const TextSpan(
              //     style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
              //     children: [
              //       TextSpan(text: 'Need help? Contact us @ '),
              //       TextSpan(
              //         text: 'admin',
              //         style: TextStyle(
              //             color: Colors.amber, fontWeight: FontWeight.w500),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// Optional: Countdown Timer Widget
class _CountdownTimer extends StatefulWidget {
  final DateTime targetDateTime;

  const _CountdownTimer({required this.targetDateTime});

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  Duration get _remaining => widget.targetDateTime.difference(DateTime.now());
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    if (_remaining.inSeconds > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted && _remaining.inSeconds > 0) {
          setState(() {});
        } else {
          _timer.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining.inSeconds <= 0) {
      return const Text(
        'Back online soon!',
        style: TextStyle(color: Colors.green, fontSize: 16),
      );
    }

    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeBox(hours, 'HRS'),
        const SizedBox(width: 8),
        _buildTimeBox(minutes, 'MIN'),
        const SizedBox(width: 8),
        _buildTimeBox(seconds, 'SEC'),
      ],
    );
  }

  Widget _buildTimeBox(int value, String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF888888),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
