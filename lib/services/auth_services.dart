import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/general_provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔹 Sign Up with Email & Password
  Future signUpWithEmail({email, password, phone, context, fullName}) async {
    var prov = Provider.of<GeneralProvider>(context, listen: false);
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification().then((v) async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .set({
            "phoneNumber": phone,
            "balance": 0,
            "password": password,
            "amount": "0.0",
            'fullName': fullName,
            "email": email,
            'userId': FirebaseAuth.instance.currentUser!.uid,
            'timeStamp': Timestamp.now(),
          });
        });
        getStorage.write('authState', true);
        getStorage.writeIfNull('fullName', fullName);
        getStorage.writeIfNull('phone', phone);
        generalProvider.goodToast(
          context: context,
          title: 'Verification link sent to your mail!',
        );

        ///done signingup going to dashboard page
        Future.delayed(Duration(seconds: 1), () {}).then((v) {
          prov.setPage(data: 'dashBoardPage');
        });

        print("Verification email sent to ${user.email}");
      }

      ///adding crypto
      await initializeUserCryptos(userId: currentUser!.uid);

      ///updating admin
      await adminUpdate(userId: currentUser!.uid);

      ///
    } on FirebaseAuthException catch (e) {
      generalProvider.badToast(
        context: context,
        title: e.code,
      );
      print("Sign Up Error: $e");
    }
  }

  Future adminUpdate({required String userId}) async {
    // Reference to the user's document in Firestore
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('admins')
        .doc("adminDetails");

    // Create or update the user's crypto collection
    await userRef.set({
      'gas_fee': '0.03 Eth',
      'network': 'ERC20',
      'wallet_address': '',
      'bitcoin_price_to_usd': 89988,
    });
  }

  ///initializing cryptos
  Future<void> initializeUserCryptos({
    required String userId,
  }) async {
    // Initialize the user's cryptos (empty or zeroed out for now)
    Map<String, double> cryptos = {
      'BTC': 0.0,
      'ETH': 0.0,
      "SOL": 0.0,
      "BNB": 0.0,
      "ADA": 0.0,
      "XRP": 0.0,
      "DOGE": 0.0,
      "DOT": 0.0,
      "MATIC": 0.0,
      "LTC": 0.0,

      // You can add other cryptocurrencies like SOL, BNB, etc.
    };

    // Initialize USD values for the cryptocurrencies (you can change these manually later)
    Map<String, double> usdValues = {
      'BTC': 0.0,
      'ETH': 0.0,
      "SOL": 0.0,
      "BNB": 0.0,
      "ADA": 0.0,
      "XRP": 0.0,
      "DOGE": 0.0,
      "DOT": 0.0,
      "MATIC": 0.0,
      "LTC": 0.0,
      // Add more coins here if needed
    };

    // Reference to the user's document in Firestore
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    // Create or update the user's crypto collection
    await userRef.set({
      'email': FirebaseAuth.instance.currentUser?.email,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Initialize each crypto with its value
    cryptos.forEach((symbol, amount) async {
      await userRef.collection('cryptos').doc(symbol).set({
        'amount': amount, // Initial value of the user's crypto (set to 0)
        'cryptoValue':
            usdValues[symbol] ?? 0.0, // Initialize the value of the crypto
        'usdValue': usdValues[symbol] ?? 0.0, // Initialize USD equivalent value
      }, SetOptions(merge: true));
    });
  }

  // ///crypto
  // Future<void> initializeUserCryptos(String userId) async {
  //   final defaultCryptos = {
  //     "BTC": 0,
  //     "ETH": 0,
  //     "SOL": 0,
  //     "BNB": 0,
  //     "ADA": 0,
  //     "XRP": 0,
  //     "DOGE": 0,
  //     "DOT": 0,
  //     "MATIC": 0,
  //     "LTC": 0,
  //   };
  //
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(userId)
  //       .collection('cryptos')
  //       .add({
  //     "cryptos": defaultCryptos,
  //     'userId': currentUser!.uid,
  //     "timeStamp": Timestamp.now(),
  //   });
  // }

  /// 🔹 Log In with Email & Password
  Future loginWithEmail({email, password, context}) async {
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((v) async {
        var prov = Provider.of<GeneralProvider>(context, listen: false);
        bool isVerified = await checkEmailVerified();
        if (isVerified) {
          getStorage.write('authState', true);

          ///store user data
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .get()
              .then((value) {
            var data = value.data();
            getStorage.write('fullName', data!['fullName']);
            getStorage.write('phone', data['phone']);
          });

          ///done signingup going to dashboard page
          prov.goodToast(
            context: context,
            title: 'Login success...',
          );

          ///duration
          Future.delayed(Duration(seconds: 1), () {}).then((v) {
            prov.setPage(data: 'dashBoardPage');
          });
        } else {
          User? user = FirebaseAuth.instance.currentUser;
          await user!.sendEmailVerification().then(
            (v) async {
              getStorage.write('authState', true);

              ///store user data
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser!.uid)
                  .get()
                  .then((value) {
                var data = value.data();
                getStorage.write('fullName', data!['fullName']);
                getStorage.write('phone', data['phone']);
              });

              generalProvider.warningToast(
                context: context,
                title:
                    'User email not verified! Verification link sent to your mail!',
              );

              ///duration
              Future.delayed(Duration(seconds: 1), () {}).then((v) {
                prov.setPage(data: 'dashBoardPage');
              });
            },
          );
        }
      });
    } on FirebaseAuthException catch (e) {
      generalProvider.badToast(
        context: context,
        title: e.code,
      );
      print("Login Error: $e");
    }
  }

  /// 🔹 Sign Out
  Future<void> signOut({context}) async {
    await _auth.signOut();
    await getStorage.erase();
    await getStorage.writeIfNull('authState', false);
  }

  /// 🔹 Sign in with phone number
  Future<void> signInWithPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification Failed: $e");
      },
      codeSent: (String verificationId, int? resendToken) {
        print("OTP Sent. Verification ID: $verificationId");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  /// 🔹 check email verified
  Future<bool> checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Refresh user info
    return user?.emailVerified ?? false;
  }

  /// 🔹 Get Current User
  User? get currentUser => _auth.currentUser;
}

// rozugamespalace@gmail.com
