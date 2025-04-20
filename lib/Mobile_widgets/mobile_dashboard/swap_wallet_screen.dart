import 'dart:convert';
import 'package:Cryptousd/Screens/dashboard/transactions_screens/select_network_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Mobile_widgets/local_widgets/input_formatter.dart';
import '../../../Mobile_widgets/mobile_dashboard/local_widgets/dashboard_cont.dart';
import '../../../Utils/color/color.dart';
import '../../../Utils/dimens.dart';
import '../../../providers/general_provider.dart';
import '../../Screens/dashboard/transactions_screens/no_gas_fee_cont.dart';

class SwapWalletScreen extends StatefulWidget {
  final String fromPage;
  const SwapWalletScreen({this.fromPage = "", super.key});

  @override
  State<SwapWalletScreen> createState() => _SwapWalletScreenState();
}

class _SwapWalletScreenState extends State<SwapWalletScreen> {
  final TextEditingController _usdController = TextEditingController();

  ///
  Future<double> fetchBtcConversionRateFromCoinGecko() async {
    // CoinGecko API: Current Bitcoin Price in USD
    const url =
        'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // The structure: {"bitcoin":{"usd":current_price}}
      final rate = data['bitcoin']['usd'];
      if (rate is num) {
        return rate.toDouble();
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception('Failed to fetch Bitcoin rate: ${response.statusCode}');
    }
  }

  String? selectedTransferOption; // Holds dropdown selection (e.g., "PayPal")
  bool showTransferDetails = false; // Controls visibility of the input field
  final TextEditingController _transferDetailsController =
      TextEditingController();
  String? _fromCrypto = 'BTC'; // Default: Swap FROM BTC
  String? _toCrypto = 'ETH'; // Default: Swap TO ETH
  double _conversionRate = 0.0; // Fetched from API/Firebase
  bool _isSwapping = false; // Toggle swap direction

  /// BTC value that will be computed.
  String usdInput = '';
  double? btcValue;
  dynamic ethCryptoValue = 0;
  double btcValueFromFirebase = 0.0;
  bool isLoading = true;
  bool popUp = false;
  String errorMessage = '';
  String adminWalletAddress = '';
  String gasFee = '--';
  String network = '--';
  double _textWidth = 40.0;
  // Fetch conversion rate (mock example)
  Future<void> _fetchConversionRate() async {
    // Replace with actual API call (CoinGecko/Firebase)
    setState(() => _conversionRate = 16.5); // Mock: 1 BTC = 16.5 ETH
  }

// Swap currencies (flip direction)
  void _swapCurrencies() {
    setState(() {
      _isSwapping = !_isSwapping;
      _fromCrypto = _isSwapping ? 'ETH' : 'BTC';
      _toCrypto = _isSwapping ? 'BTC' : 'ETH';
    });
  }

  bool gasFeeIsLoading = false;
  Future _fetchAdminInfo() async {
    setState(() {
      gasFeeIsLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('admins')
        .doc('adminDetails')
        .get()
        .then((v) {
      var data = v.data();
      setState(() {
        gasFee = data!['gas_fee'];
        adminWalletAddress = data['wallet_address'];
        network = data['network'];
        // btcValueFromFirebase = data['bitcoin_price_to_usd'];
      });
    }).then((v) {
      setState(() {
        gasFeeIsLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAdminInfo();
    _fetchUserEthValue();
    _usdController.addListener(_onUsdInputChanged);
    _usdController.addListener(_updateWidth);
  }

  void _updateWidth() {
    final text = _usdController.text.isEmpty ? '0.0' : _usdController.text;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    setState(() {
      _textWidth = textPainter.width + 10; // Add a little padding
    });
  }

  void _onUsdInputChange() {
    if (btcValueFromFirebase != 0.0) {
      final input = _usdController.text;
      final usd = double.tryParse(input);
      if (usd != null) {
        setState(() {
          btcValue = usd / btcValueFromFirebase;
        });
      } else {
        setState(() {
          btcValue = null;
        });
      }
    }
  }

  void _onUsdInputChanged() {
    if (btcValueFromFirebase != 0.0) {
      final input = _usdController.text;

      // Strip everything except numbers and decimal points
      final cleanedInput = input.replaceAll(RegExp(r'[^\d.]'), '');

      final usd = double.tryParse(cleanedInput);
      if (usd != null) {
        setState(() {
          btcValue = usd / btcValueFromFirebase;
        });
      } else {
        setState(() {
          btcValue = null;
        });
      }
    }
  }

  Future _fetchUserEthValue() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cryptos')
        .doc('ETH')
        .get()
        .then((v) {
      var data = v.data();
      setState(() {
        ethCryptoValue = data!['cryptoValue'];
      });
    });
  }

  Future<void> _fetchConversion() async {
    double usdValue = double.parse(
        Provider.of<GeneralProvider>(context, listen: false).userBalance);
    try {
      final btcRate = await fetchBtcConversionRateFromCoinGecko();
      setState(() {
        /// Compute the BTC equivalent (USD divided by current USD-per-BTC rate)
        btcValue = usdValue / btcRate;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching conversion rate: $e';
        isLoading = false;
      });
    }
  }

  Future<void> openGasDocs() async {
    html.window.open('https://ethereum.org/en/developers/docs/gas/', '_blank');
  }

  @override
  Widget build(BuildContext context) {
    // Colors (Feel free to replace with your brand colors)
    const primaryColor = Color(0xFF111111); // A dark color
    const accentColor =
        Color(0xFFFFC107); // Example accent color (amber/yellow)
    const backgroundColor = Color(0xFF121212);
    const cardColor = Color(0xFF1E1E1E);
    dynamic btcValueReplacement = double.parse(
            Provider.of<GeneralProvider>(context, listen: false).userBalance) /
        btcValueFromFirebase.toDouble();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xFF212429),
        elevation: 0,
        title: const Text(
          'Swap',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 120,
        leading: widget.fromPage.isEmpty
            ? GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: white))
            : SizedBox(),
      ),
      body: gasFeeIsLoading
          ? Center(
              child: CircularProgressIndicator(
              color: amber,
              strokeWidth: 0.8,
            ))
          : Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // From Card
                      _buildCryptoCard(
                        crypto: _fromCrypto!,
                        isFrom: true,
                        amount: _usdController.text.isEmpty
                            ? '0.0'
                            : _usdController.text,
                      ),

                      // Swap Button
                      IconButton(
                        icon: Icon(Icons.swap_vert, color: Colors.amber),
                        onPressed: _swapCurrencies,
                      ),

                      // To Card
                      _buildCryptoCard(
                        crypto: _toCrypto!,
                        isFrom: false,
                        amount: _usdController.text.isEmpty
                            ? '0.0'
                            : (double.parse(_usdController.text) *
                                    _conversionRate)
                                .toStringAsFixed(8),
                      ),
                      SizedBox(height: 20),
                      // Transfer Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            // Handle swap logic

                            // TODO: handle withdrawal
                            if (_usdController.text.isEmpty) {
                              setState(() {});
                              generalProvider.warningToast(
                                context: context,
                                title: "Amount field must not be empty!",
                              );
                            } else if (ethCryptoValue < 0.03) {
                              setState(() {
                                popUp = true;
                              });
                              generalProvider.warningToast(
                                context: context,
                                title: 'ETH is too low for gas fee',
                              );
                            } else {
                              ///proceed to swapping
                              print(
                                  'Swapping ${_usdController.text} $_fromCrypto → $_toCrypto');
                            }
                          },
                          child: Text(
                            'Confirm Swap',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: fWLargerFont,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                popUp
                    ? Positioned(
                        bottom: 0,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          height: MediaQuery.of(context).size.height / 2.3,
                          width: MediaQuery.of(context).size.width,
                          // decoration: BoxDecoration(
                          //   color: Color(0xFF212429),
                          // ),
                          child: GasFeeInfo(
                            depositAmount: double.parse(gasFee),
                            onDepositClicked: () {
                              setState(() {
                                popUp = false;
                              });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SelectNetworkScreen(
                                  tonAddress: adminWalletAddress,
                                  ethNetwork: network,
                                );
                              }));
                            },
                            onLearnMoreClicked: () {
                              setState(() {
                                popUp = false;
                              });
                              openGasDocs();
                            },
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
    );
  }

// Reusable Card Widget
  Widget _buildCryptoCard(
      {required String crypto, required bool isFrom, required String amount}) {
    return Card(
      color: Color(0xFF1E1E1E),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isFrom ? 'From' : 'To',
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: isFrom ? _usdController : null,
                    readOnly: !isFrom,
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    decoration: InputDecoration(
                      hintText: '0.0',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: crypto,
                  items: ['BTC', 'ETH'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: isFrom
                      ? (newValue) => setState(() => _fromCrypto = newValue)
                      : null, // Disable dropdown for "To" card
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget tFieldAmount() {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 300, // max expansion limit
        ),
        child: IntrinsicWidth(
          child: TextField(
            inputFormatters: [CurrencyInputFormatter()],
            controller: _usdController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            cursorColor: amber,
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: Text(
                '\$',
                style: TextStyle(
                  color: amber,
                  fontSize: kTextXxLarge,
                  fontWeight: fWLargerFont,
                ),
              ),
              hintText: '0.0',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: amber),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: amber),
              ),
              hintStyle: TextStyle(
                color: amber.withOpacity(0.5),
                fontSize: kTextXxLarge,
                fontWeight: fWLargerFont,
              ),
            ),
            style: TextStyle(
              color: amber,
              fontSize: kTextXLarge,
              fontWeight: fWLargerFont,
            ),
          ),
        ),
      ),
    );
  }
}

// Helper to build each row in the Info Card
Widget _infoRow({required String title, required String value}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
