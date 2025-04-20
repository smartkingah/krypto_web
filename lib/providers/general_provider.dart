import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../Reponsive/dimensions.dart';

var generalProvider = GeneralProvider();
var getStorage = GetStorage();

class GeneralProvider extends ChangeNotifier {
  String page = 'landingPage';
  String adminPage = 'users';
  String adminPageUserId = '';
  bool closeDrawer = false;
  bool isAdmin = false;
  String userBalance = '';

  setUserBalance({data}) {
    userBalance = data;
    notifyListeners();
  }

  setAdminPage({data}) {
    adminPage = data;
    notifyListeners();
  }

  setAdminPageUserId({userId}) {
    adminPageUserId = userId;
    notifyListeners();
  }

  setAdmin({data}) {
    isAdmin = data;
    notifyListeners();
  }

  setPage({data}) {
    page = data;
    notifyListeners();
  }

  setDrawerStatus({data}) {
    closeDrawer = data;
    notifyListeners();
  }

  ///show delighted toast
  goodToast({
    required context,
    required title,
  }) async {
    DelightToastBar(
      autoDismiss: true,
      position: DelightSnackbarPosition.top,
      snackbarDuration: const Duration(seconds: 1),
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width < mobileWidth
              ? MediaQuery.of(context).size.width / 10
              : MediaQuery.of(context).size.width / 2.8,
        ),
        child: ToastCard(
          leading: CircleAvatar(
            backgroundColor: Colors.green.withOpacity(0.25),
            child: const Icon(
              Icons.check,
              color: Colors.green,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ).show(context);
  }

  ///show bad toast
  badToast({
    required context,
    required title,
  }) async {
    DelightToastBar(
      autoDismiss: true,
      position: DelightSnackbarPosition.top,
      snackbarDuration: const Duration(seconds: 3),
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width < mobileWidth
              ? MediaQuery.of(context).size.width / 10
              : MediaQuery.of(context).size.width / 2.8,
        ),
        child: ToastCard(
          leading: CircleAvatar(
            backgroundColor: Colors.red.withOpacity(0.25),
            child: const Icon(
              Icons.clear,
              color: Colors.red,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ).show(context);
  }

  ///show warning toast
  warningToast({
    required context,
    required title,
  }) async {
    DelightToastBar(
      autoDismiss: true,
      position: DelightSnackbarPosition.top,
      snackbarDuration: const Duration(seconds: 1),
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width < mobileWidth
              ? MediaQuery.of(context).size.width / 10
              : MediaQuery.of(context).size.width / 2.8,
        ),
        child: ToastCard(
          leading: CircleAvatar(
            backgroundColor: Colors.amber.withOpacity(0.25),
            child: const Icon(
              Icons.warning_amber,
              color: Colors.amber,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ).show(context);
  }

  clearProviders() {
    // page = '';
    adminPage = '';
    adminPageUserId = '';
    // closeDrawer = false;
    // isAdmin = false;
    notifyListeners();
  }
}
