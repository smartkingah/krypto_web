import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import '../../Widgets/footer_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchTransactions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchTransactions() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .orderBy('date', descending: true)
          .limit(50)
          .get();

      setState(() {
        _transactions = snap.docs.map((d) => d.data()).toList();
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _transactions = _sampleTransactions();
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> _sampleTransactions() {
    return [
      {
        'type': 'Deposit',
        'asset': 'Bitcoin',
        'symbol': 'BTC',
        'amount': '0.0432',
        'usdValue': '2,840.50',
        'status': 'Completed',
        'date': '2025-05-24 14:32',
        'txId': 'tx_8f3a1b2c9d4e5f6a',
      },
      {
        'type': 'Withdrawal',
        'asset': 'Ethereum',
        'symbol': 'ETH',
        'amount': '1.250',
        'usdValue': '3,125.00',
        'status': 'Completed',
        'date': '2025-05-23 09:15',
        'txId': 'tx_2a3b4c5d6e7f8a9b',
      },
      {
        'type': 'Swap',
        'asset': 'USDT → BTC',
        'symbol': 'USDT',
        'amount': '500.00',
        'usdValue': '500.00',
        'status': 'Completed',
        'date': '2025-05-22 18:45',
        'txId': 'tx_3c4d5e6f7a8b9c0d',
      },
      {
        'type': 'Deposit',
        'asset': 'Solana',
        'symbol': 'SOL',
        'amount': '12.500',
        'usdValue': '1,875.00',
        'status': 'Pending',
        'date': '2025-05-21 11:20',
        'txId': 'tx_4d5e6f7a8b9c0d1e',
      },
      {
        'type': 'Withdrawal',
        'asset': 'Bitcoin',
        'symbol': 'BTC',
        'amount': '0.0210',
        'usdValue': '1,382.20',
        'status': 'Completed',
        'date': '2025-05-20 16:05',
        'txId': 'tx_5e6f7a8b9c0d1e2f',
      },
      {
        'type': 'Swap',
        'asset': 'ETH → SOL',
        'symbol': 'ETH',
        'amount': '0.500',
        'usdValue': '1,250.00',
        'status': 'Completed',
        'date': '2025-05-19 08:30',
        'txId': 'tx_6f7a8b9c0d1e2f3a',
      },
      {
        'type': 'Deposit',
        'asset': 'USDT',
        'symbol': 'USDT',
        'amount': '1,000.00',
        'usdValue': '1,000.00',
        'status': 'Completed',
        'date': '2025-05-18 13:55',
        'txId': 'tx_7a8b9c0d1e2f3a4b',
      },
      {
        'type': 'Withdrawal',
        'asset': 'Solana',
        'symbol': 'SOL',
        'amount': '5.000',
        'usdValue': '750.00',
        'status': 'Failed',
        'date': '2025-05-17 10:40',
        'txId': 'tx_8b9c0d1e2f3a4b5c',
      },
    ];
  }

  List<Map<String, dynamic>> _filtered(String type) {
    if (type == 'All') return _transactions;
    return _transactions.where((t) => t['type'] == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Color(0xFF141416)),
      child: _loading
          ? Center(child: CircularProgressIndicator(color: amber))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  _header(),
                  SizedBox(height: 20),
                  _statsRow(),
                  SizedBox(height: 24),
                  _tabBar(),
                  SizedBox(height: 16),
                  _tabContent(),
                  SizedBox(height: 30),
                  FooterPage(),
                ],
              ),
            ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction History',
            style: TextStyle(
              color: white,
              fontSize: kTextLarge,
              fontWeight: fWLargeFont,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Track all your deposits, withdrawals, and swaps.',
            style: TextStyle(color: Colors.grey, fontSize: kTextSmaller),
          ),
        ],
      ),
    );
  }

  Widget _statsRow() {
    final deposits = _transactions
        .where((t) => t['type'] == 'Deposit' && t['status'] == 'Completed')
        .length;
    final withdrawals = _transactions
        .where((t) => t['type'] == 'Withdrawal' && t['status'] == 'Completed')
        .length;
    final swaps = _transactions
        .where((t) => t['type'] == 'Swap' && t['status'] == 'Completed')
        .length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          _statCard('Total Transactions', '${_transactions.length}',
              Icons.receipt_long, Colors.blue),
          SizedBox(width: 16),
          _statCard(
              'Deposits', '$deposits', Icons.arrow_downward, Colors.green),
          SizedBox(width: 16),
          _statCard('Withdrawals', '$withdrawals', Icons.arrow_upward,
              Colors.orange),
          SizedBox(width: 16),
          _statCard('Swaps', '$swaps', Icons.swap_horiz, Colors.purple),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF18191D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                        color: white,
                        fontSize: kTextSmall,
                        fontWeight: fWLargeFont)),
                Text(label,
                    style: TextStyle(
                        color: Colors.grey, fontSize: kTextMini)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF18191D),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: amber,
            borderRadius: BorderRadius.circular(10),
          ),
          labelColor: black,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(fontWeight: fWLargeFont, fontSize: kTextSmaller),
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Deposits'),
            Tab(text: 'Withdrawals'),
          ],
        ),
      ),
    );
  }

  Widget _tabContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        constraints: BoxConstraints(minHeight: 300),
        decoration: BoxDecoration(
          color: Color(0xFF18191D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _table(_filtered('All')),
            _table(_filtered('Deposit')),
            _table(_filtered('Withdrawal')),
          ],
        ),
      ),
    );
  }

  Widget _table(List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox, color: Colors.grey, size: 48),
              SizedBox(height: 12),
              Text('No transactions found',
                  style: TextStyle(color: Colors.grey, fontSize: kTextSmaller)),
            ],
          ),
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dividerThickness: 0.2,
        headingRowColor:
            MaterialStateColor.resolveWith((_) => Color(0xFF141416)),
        columns: [
          DataColumn(
              label: Text('Type', style: TextStyle(color: Colors.grey))),
          DataColumn(
              label: Text('Asset', style: TextStyle(color: Colors.grey))),
          DataColumn(
              label: Text('Amount', style: TextStyle(color: Colors.grey))),
          DataColumn(
              label: Text('USD Value', style: TextStyle(color: Colors.grey))),
          DataColumn(
              label: Text('Status', style: TextStyle(color: Colors.grey))),
          DataColumn(
              label: Text('Date', style: TextStyle(color: Colors.grey))),
        ],
        rows: rows.map((tx) {
          final Color statusColor = tx['status'] == 'Completed'
              ? Colors.green
              : tx['status'] == 'Pending'
                  ? Colors.orange
                  : Colors.red;
          final Color typeColor = tx['type'] == 'Deposit'
              ? Colors.green
              : tx['type'] == 'Withdrawal'
                  ? Colors.orange
                  : Colors.blue;
          return DataRow(cells: [
            DataCell(Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(tx['type'],
                  style: TextStyle(color: typeColor, fontSize: kTextMini)),
            )),
            DataCell(Text(tx['asset'],
                style: TextStyle(color: white, fontSize: kTextSmaller))),
            DataCell(Text(tx['amount'],
                style: TextStyle(color: white, fontSize: kTextSmaller))),
            DataCell(Text('\$${tx['usdValue']}',
                style: TextStyle(color: amber, fontSize: kTextSmaller))),
            DataCell(Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(tx['status'],
                  style:
                      TextStyle(color: statusColor, fontSize: kTextMini)),
            )),
            DataCell(Text(tx['date'],
                style: TextStyle(color: Colors.grey, fontSize: kTextMini))),
          ]);
        }).toList(),
      ),
    );
  }
}
