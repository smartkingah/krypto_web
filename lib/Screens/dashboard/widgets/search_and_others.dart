import 'package:flutter/material.dart';

import '../../../Utils/color/color.dart';
import '../../../Utils/dimens.dart';
import '../../../Widgets/tField.dart';

class SearchFilterBar extends StatefulWidget {
  const SearchFilterBar({super.key});

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  bool hideZeroBalance = false;
  bool simplifiedList = false;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Asset List',
            style: TextStyle(
              color: white,
              fontSize: kTextSmaller,
            ),
          ),
          SizedBox(width: 300),
          Row(
            children: [
              Container(
                width: 200,
                child: Tfield(
                  contr: searchController,
                  preIcon: Icon(Icons.search),
                  title: 'Search..',
                  hint: 'usdt',
                  suffixIcon: SizedBox(),
                ),
              ),
              const SizedBox(width: 20),
              // Hide Zero Balance Checkbox
              Row(
                children: [
                  Checkbox(
                    activeColor: amber,
                    value: hideZeroBalance,
                    onChanged: (value) {
                      setState(() {
                        hideZeroBalance = value!;
                      });
                    },
                  ),
                  const Text("Hide Zero Balance Assets",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(width: 20),
              // Simplified List Checkbox
              Row(
                children: [
                  Checkbox(
                    activeColor: amber,
                    value: simplifiedList,
                    onChanged: (value) {
                      setState(() {
                        simplifiedList = value!;
                      });
                    },
                  ),
                  const Text("Simplified List",
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
