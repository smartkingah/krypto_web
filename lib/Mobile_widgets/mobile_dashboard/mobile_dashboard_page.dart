import 'package:Cryptousd/Mobile_widgets/mobile_dashboard/swap_wallet_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../Screens/dashboard/transactions_screens/select_network_screen.dart';
import '../../Screens/dashboard/transactions_screens/withdrawal_screen.dart';
import '../transfer_screen.dart';
import 'assets_items.dart';
import 'deposit_wallet_screen.dart';
import 'local_widgets/cont_item.dart';
import 'local_widgets/dashboard_cont.dart';
import 'local_widgets/header_widget.dart';

class MobileDashBoardPage extends StatefulWidget {
  const MobileDashBoardPage({super.key});

  @override
  State<MobileDashBoardPage> createState() => _MobileDashBoardPageState();
}

class _MobileDashBoardPageState extends State<MobileDashBoardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF161719),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///header
              HeaderWidget(),

              ///dashboard
              DashboardCont(),

              ///withdrawal conts
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    contItem(
                      icon: Icons.arrow_downward,
                      title: 'Withdrawal',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return WithdrawalScreen();
                            },
                          ),
                        );
                      },
                    ),
                    contItem(
                      icon: Icons.send_outlined,
                      title: 'Transfer',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return TransferScreen();
                            },
                          ),
                        );
                      },
                    ),
                    contItem(
                      icon: Icons.add,
                      title: 'Deposit',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return DepositWalletScreen();
                            },
                          ),
                        );
                      },
                    ),
                    contItem(
                      icon: Icons.swap_horizontal_circle,
                      title: 'Swap',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SwapWalletScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              ///assets items
              AssetsItems()
            ],
          ),
        ),
      ),
    );
  }
}
