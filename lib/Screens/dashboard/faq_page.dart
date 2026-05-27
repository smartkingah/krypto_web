import 'package:flutter/material.dart';

import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import '../../Widgets/footer_page.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  int _selectedCategory = 0;
  final Set<int> _expandedItems = {};

  final List<String> _categories = [
    'All',
    'Getting Started',
    'Deposits & Withdrawals',
    'Security',
    'Trading',
    'Account',
  ];

  final List<Map<String, dynamic>> _faqs = [
    {
      'category': 'Getting Started',
      'question': 'How do I create an account on CryptoUSD?',
      'answer':
          'Creating an account is simple. Click "Sign Up" on the top right, enter your email address and a strong password, then verify your email. Once verified, you can immediately start exploring the platform. To unlock full features like deposits and withdrawals, you will need to complete KYC verification.',
    },
    {
      'category': 'Getting Started',
      'question': 'What cryptocurrencies are supported?',
      'answer':
          'CryptoUSD supports a wide range of cryptocurrencies including Bitcoin (BTC), Ethereum (ETH), Solana (SOL), Tether (USDT), BNB, Cardano (ADA), Ripple (XRP), and many more. We regularly add new assets based on community demand and market relevance.',
    },
    {
      'category': 'Getting Started',
      'question': 'Is CryptoUSD available in my country?',
      'answer':
          'CryptoUSD is available in most countries worldwide. However, due to regulatory requirements, some services may be restricted in certain jurisdictions including the United States, China, and a few other regions. Please check our Terms of Service for the full list of restricted countries.',
    },
    {
      'category': 'Deposits & Withdrawals',
      'question': 'How do I deposit cryptocurrency into my account?',
      'answer':
          'To deposit crypto, log in to your account and navigate to the Dashboard. Select the asset you want to deposit, then click "Deposit" to get your unique wallet address. Send your crypto to that address from any external wallet or exchange. Deposits typically confirm within 10–30 minutes depending on network congestion.',
    },
    {
      'category': 'Deposits & Withdrawals',
      'question': 'What are the withdrawal fees and limits?',
      'answer':
          'Withdrawal fees vary by asset and are displayed before you confirm any transaction. Standard users have a daily withdrawal limit of \$10,000. Verified users (KYC Level 2) have a daily limit of \$100,000. There is no minimum withdrawal amount, though very small withdrawals may be uneconomical due to network fees.',
    },
    {
      'category': 'Deposits & Withdrawals',
      'question': 'How long do withdrawals take?',
      'answer':
          'Withdrawal processing time depends on the cryptocurrency network. Bitcoin withdrawals typically take 20–60 minutes. Ethereum withdrawals take 5–15 minutes. USDT on TRC20 can be near-instant. All withdrawals go through a security review which may add up to 30 minutes for first-time addresses.',
    },
    {
      'category': 'Security',
      'question': 'How does CryptoUSD keep my funds safe?',
      'answer':
          'We use industry-leading security measures including cold storage for 95% of user funds, multi-signature wallets, 256-bit SSL encryption for all data transfers, two-factor authentication (2FA), real-time fraud monitoring, and regular third-party security audits. Our platform has never experienced a security breach.',
    },
    {
      'category': 'Security',
      'question': 'How do I enable Two-Factor Authentication (2FA)?',
      'answer':
          'To enable 2FA, go to Settings → Security → Two-Factor Authentication. Toggle the switch to enable it. You can use any TOTP-compatible authenticator app such as Google Authenticator, Authy, or Microsoft Authenticator. Scan the QR code shown and enter the 6-digit code to confirm. We strongly recommend enabling 2FA on your account.',
    },
    {
      'category': 'Security',
      'question': 'What should I do if I suspect unauthorized access to my account?',
      'answer':
          'Immediately change your password and revoke all active sessions from Settings → Security → Active Sessions. Enable 2FA if not already active. Contact our support team via the Help page and report the incident. We will investigate and can temporarily freeze your account to prevent further unauthorized activity.',
    },
    {
      'category': 'Trading',
      'question': 'What is the difference between a market order and a limit order?',
      'answer':
          'A market order executes immediately at the current best available price. A limit order lets you set a specific price at which you want to buy or sell — it will only execute when the market reaches your specified price. Market orders are faster but may have slight slippage; limit orders give you price control but may not fill immediately.',
    },
    {
      'category': 'Trading',
      'question': 'What trading fees does CryptoUSD charge?',
      'answer':
          'CryptoUSD uses a maker-taker fee model. Makers (who add liquidity with limit orders) pay 0.1% per trade. Takers (who execute against existing orders) pay 0.15% per trade. High-volume traders receive progressive discounts — traders with monthly volume over \$500,000 enjoy fees as low as 0.02%.',
    },
    {
      'category': 'Account',
      'question': 'How do I complete KYC verification?',
      'answer':
          'KYC verification is done through our secure verification portal. You will need to provide a valid government-issued photo ID (passport, national ID, or driver\'s license), a selfie holding your ID, and proof of address (utility bill or bank statement dated within 3 months). Most verifications are completed within 24 hours.',
    },
    {
      'category': 'Account',
      'question': 'Can I have multiple accounts?',
      'answer':
          'No. Our Terms of Service prohibit creating multiple accounts per person. Each individual is allowed exactly one CryptoUSD account. Creating multiple accounts may result in all associated accounts being permanently suspended. If you have trouble accessing your account, please contact support.',
    },
    {
      'category': 'Account',
      'question': 'How do I close my account?',
      'answer':
          'To close your account, first withdraw all your remaining funds to an external wallet. Then go to Settings → Preferences → Danger Zone and click "Delete Account". Note that account deletion is permanent and cannot be undone. Any unclaimed funds at time of deletion may be forfeited. Please contact support if you need assistance.',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == 0) return _faqs;
    final cat = _categories[_selectedCategory];
    return _faqs.where((f) => f['category'] == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Color(0xFF141416)),
      child: ListView(
        children: [
          SizedBox(height: 30),
          _header(),
          SizedBox(height: 20),
          _categoryRow(),
          SizedBox(height: 20),
          _faqList(),
          SizedBox(height: 30),
          _contactBanner(),
          SizedBox(height: 20),
          FooterPage(),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Frequently Asked Questions',
              style: TextStyle(
                  color: white,
                  fontSize: kTextLarge,
                  fontWeight: fWLargeFont)),
          SizedBox(height: 6),
          Text(
            'Find answers to the most common questions about CryptoUSD.',
            style: TextStyle(color: Colors.grey, fontSize: kTextSmaller),
          ),
        ],
      ),
    );
  }

  Widget _categoryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_categories.length, (i) {
            final isSelected = _selectedCategory == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = i),
              child: Container(
                margin: EdgeInsets.only(right: 8),
                padding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        fontWeight: isSelected ? fWLargeFont : fWSmallFont)),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _faqList() {
    final items = _filtered;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: List.generate(items.length, (i) {
          final faq = items[i];
          final isExpanded = _expandedItems.contains(i);
          return Container(
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Color(0xFF18191D),
              borderRadius: BorderRadius.circular(12),
              border: isExpanded
                  ? Border.all(color: amber.withOpacity(0.3))
                  : null,
            ),
            child: Theme(
              data: ThemeData(
                dividerColor: Colors.transparent,
                colorScheme: ColorScheme.dark(),
              ),
              child: ExpansionTile(
                key: ValueKey(i),
                initiallyExpanded: isExpanded,
                onExpansionChanged: (v) {
                  setState(() {
                    if (v) {
                      _expandedItems.add(i);
                    } else {
                      _expandedItems.remove(i);
                    }
                  });
                },
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isExpanded
                        ? amber.withOpacity(0.1)
                        : Color(0xFF141416),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isExpanded
                        ? Icons.remove
                        : Icons.add,
                    color: isExpanded ? amber : Colors.grey,
                    size: 16,
                  ),
                ),
                title: Text(
                  faq['question'],
                  style: TextStyle(
                      color: isExpanded ? white : Colors.grey[300],
                      fontSize: kTextSmaller,
                      fontWeight:
                          isExpanded ? fWLargeFont : fWSmallFont),
                ),
                trailing: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(faq['category'],
                      style: TextStyle(
                          color: amber, fontSize: 10)),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      faq['answer'],
                      style: TextStyle(
                          color: Colors.grey, fontSize: kTextSmaller, height: 1.6),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _contactBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF18191D), Color(0xFF1a1a2e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(Icons.support_agent, color: amber, size: 40),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Still have questions?',
                      style: TextStyle(
                          color: white,
                          fontSize: kTextSmall,
                          fontWeight: fWLargeFont)),
                  SizedBox(height: 4),
                  Text(
                      'Our support team is available 24/7 to help you with anything.',
                      style: TextStyle(
                          color: Colors.grey, fontSize: kTextSmaller)),
                ],
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: amber,
                foregroundColor: black,
                padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Contact Support',
                  style: TextStyle(
                      fontWeight: fWLargeFont,
                      fontSize: kTextSmaller)),
            ),
          ],
        ),
      ),
    );
  }
}
