import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../Utils/color/color.dart';
import '../../../Utils/dimens.dart';

class SelectNetworkScreen extends StatefulWidget {
  final String tonAddress, ethNetwork;

  const SelectNetworkScreen(
      {super.key, required this.ethNetwork, required this.tonAddress});

  @override
  State<SelectNetworkScreen> createState() => _SelectNetworkScreenState();
}

class _SelectNetworkScreenState extends State<SelectNetworkScreen> {
  String selectedNetwork = 'Loading...'; // default before fetching
  List<String> networkOptions = []; // optional, if you plan to show multiple

  @override
  void initState() {
    super.initState();
    fetchNetworkFromBackend();
  }

  Future<void> fetchNetworkFromBackend() async {
    // Simulating a backend fetch – replace this with your actual logic
    await Future.delayed(Duration(seconds: 1));
    final fetchedNetwork = widget.ethNetwork; // This is the string from backend

    setState(() {
      selectedNetwork = fetchedNetwork;
      networkOptions = [fetchedNetwork]; // If it's only one, keep it single
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: white)),
        backgroundColor: const Color(0xFF212429),
        title: Text(
          "Select Network",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedNetwork,
              decoration: InputDecoration(
                labelText: 'Select Network',
                filled: true,
                fillColor: Colors.black26,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              dropdownColor: Colors.black87,
              style: TextStyle(color: Colors.white),
              items: networkOptions.map((network) {
                return DropdownMenuItem<String>(
                  value: network,
                  child: Text(network, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedNetwork = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            const Text(
              "Expected Arrival: 2min 50sec",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.ethNetwork} address is published!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: kTextLarge,
                            ),
                          ),
                          QrImageView(
                            data: widget.tonAddress,
                            version: QrVersions.auto,
                            size: 120.0,
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Please use the address below to deposit your cryptocurrency using the $selectedNetwork network. You can either copy the address or scan the QR code for convenience.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: fWSmallFont,
                          fontSize: kTextMini,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF292929),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.tonAddress,
                            style: const TextStyle(color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.white),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: widget.tonAddress));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Address copied to clipboard!"),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                onPressed: () {},
                child: const Text(
                  'Deposit',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // TODO: Navigate to ETH deposit for gas
              },
              child: const Text(
                'To deposit ETH if you do not have sufficient gas fee kindly click Here',
                style: TextStyle(
                  color: Colors.amber,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: amber.withOpacity(0.1),
                border: Border.all(color: Colors.amber, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Crypto coin Always recommend the  use ',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextSpan(
                      text: 'ERC20 network ',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          'for every ETH deposit  its the fastest to process payment',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // TODO: Handle funding confirmation
              },
              child: const Center(
                child: Text(
                  'Click here if you have deposited to get funded',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
