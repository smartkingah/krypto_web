import 'package:flutter/material.dart';

import '../../Reponsive/dimensions.dart';
import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import '../../Widgets/footer_page.dart';
import '../../Mobile_widgets/local_widgets/mobile_footer.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _selectedCategory = 'Account Issues';
  bool _submitted = false;

  final List<String> _categories = [
    'Account Issues',
    'Deposits & Withdrawals',
    'Trading Problems',
    'KYC Verification',
    'Security Concern',
    'Technical Bug',
    'Other',
  ];

  final List<Map<String, dynamic>> _channels = [
    {
      'icon': Icons.chat_bubble_outline,
      'title': 'Live Chat',
      'detail': 'Average wait: < 2 min',
      'badge': 'Online',
      'badgeColor': Color(0xFF00C076),
      'action': 'Start Chat',
    },
    {
      'icon': Icons.email_outlined,
      'title': 'Email Support',
      'detail': 'support@cryptousd.com',
      'badge': '< 24h reply',
      'badgeColor': Color(0xFF3B82F6),
      'action': 'Send Email',
    },
    {
      'icon': Icons.forum_outlined,
      'title': 'Community Forum',
      'detail': '42,000+ members helping each other',
      'badge': 'Community',
      'badgeColor': amber,
      'action': 'Visit Forum',
    },
  ];

  final List<Map<String, dynamic>> _quickLinks = [
    {'icon': Icons.lock_reset, 'text': 'Reset my password'},
    {'icon': Icons.verified_user_outlined, 'text': 'KYC verification guide'},
    {'icon': Icons.account_balance_wallet_outlined, 'text': 'How to deposit funds'},
    {'icon': Icons.swap_horiz, 'text': 'Withdrawal troubleshooting'},
    {'icon': Icons.security, 'text': 'Enable two-factor authentication'},
    {'icon': Icons.receipt_long_outlined, 'text': 'Understanding transaction fees'},
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
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
            const SizedBox(height: 28),
            _pageHeader(isDesktop),
            const SizedBox(height: 28),
            _channelsRow(isDesktop),
            const SizedBox(height: 32),
            isDesktop
                ? _desktopLayout()
                : _mobileLayout(),
            const SizedBox(height: 36),
            isDesktop ? FooterPage() : MobileFooterPage(),
          ],
        ),
      ),
    );
  }

  Widget _pageHeader(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How can we help you?',
            style: TextStyle(
                color: white,
                fontSize: isDesktop ? 28 : 22,
                fontWeight: fWLargeFont),
          ),
          const SizedBox(height: 6),
          Text(
            'Our support team is available 24/7. Choose a channel or submit a ticket below.',
            style: TextStyle(color: Colors.grey[500], fontSize: kTextSmaller),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF18191D),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600], size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search help articles, guides, FAQs…',
                      hintStyle: TextStyle(
                          color: Colors.grey[600], fontSize: 13),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _channelsRow(bool isDesktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 20),
      child: isDesktop
          ? Row(
              children: _channels
                  .map((c) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: _channelCard(c),
                        ),
                      ))
                  .toList(),
            )
          : Column(
              children: _channels
                  .map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _channelCard(c),
                      ))
                  .toList(),
            ),
    );
  }

  Widget _channelCard(Map<String, dynamic> c) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF18191D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.09)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(c['icon'] as IconData, color: amber, size: 20),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (c['badgeColor'] as Color).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(c['badge'] as String,
                    style: TextStyle(
                        color: c['badgeColor'] as Color,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(c['title'] as String,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(c['detail'] as String,
              style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: amber,
                side: BorderSide(color: amber.withValues(alpha: 0.4)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: Text(c['action'] as String,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: _ticketForm()),
          const SizedBox(width: 28),
          Expanded(flex: 3, child: _quickLinksPanel()),
        ],
      ),
    );
  }

  Widget _mobileLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _ticketForm(),
          const SizedBox(height: 28),
          _quickLinksPanel(),
        ],
      ),
    );
  }

  Widget _ticketForm() {
    if (_submitted) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: const Color(0xFF18191D),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF00C076).withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF00C076).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline,
                  color: Color(0xFF00C076), size: 48),
            ),
            const SizedBox(height: 20),
            const Text('Ticket Submitted!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'We\'ve received your request and will respond to ${_emailCtrl.text} within 24 hours.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => setState(() => _submitted = false),
              child: Text('Submit another ticket',
                  style: TextStyle(color: amber)),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF18191D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Submit a Support Ticket',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('We typically reply within 24 hours.',
                style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _field('Full Name', _nameCtrl, Icons.person_outline)),
                const SizedBox(width: 14),
                Expanded(child: _field('Email Address', _emailCtrl, Icons.email_outlined, isEmail: true)),
              ],
            ),
            const SizedBox(height: 14),
            _categoryDropdown(),
            const SizedBox(height: 14),
            _messageField(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: amber,
                  foregroundColor: black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Send Ticket',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon,
      {bool isEmail = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600], size: 18),
            filled: true,
            fillColor: const Color(0xFF141416),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: amber.withValues(alpha: 0.6)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFFF4747)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Required';
            if (isEmail && !v.contains('@')) return 'Invalid email';
            return null;
          },
        ),
      ],
    );
  }

  Widget _categoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category',
            style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF141416),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              dropdownColor: const Color(0xFF18191D),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              icon: Icon(Icons.keyboard_arrow_down,
                  color: Colors.grey[500], size: 20),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _messageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Describe your issue',
            style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _messageCtrl,
          maxLines: 5,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Please provide as much detail as possible…',
            hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
            filled: true,
            fillColor: const Color(0xFF141416),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: amber.withValues(alpha: 0.6)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFFF4747)),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
          validator: (v) {
            if (v == null || v.trim().length < 20) {
              return 'Please describe your issue (min. 20 characters)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _quickLinksPanel() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF18191D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Help',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Popular guides & articles',
              style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          const SizedBox(height: 18),
          ..._quickLinks.map((q) => _quickLinkTile(q)),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFF222226)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: amber.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: amber.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: amber, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Support Hours',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('Live chat: 24/7\nEmail: Mon–Sun, < 24h',
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 11, height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickLinkTile(Map<String, dynamic> q) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            Icon(q['icon'] as IconData, color: amber, size: 16),
            const SizedBox(width: 12),
            Expanded(
              child: Text(q['text'] as String,
                  style:
                      const TextStyle(color: Colors.white70, fontSize: 13)),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[700], size: 16),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _submitted = true);
    }
  }
}
