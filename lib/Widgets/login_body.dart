import 'package:Cryptousd/Widgets/tField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../Utils/color/color.dart';
import '../Utils/dimens.dart';
import '../providers/general_provider.dart';
import '../services/auth_services.dart';
import 'login_botton.dart';

class LoginSignUpBody extends StatefulWidget {
  const LoginSignUpBody({super.key});

  @override
  State<LoginSignUpBody> createState() => _LoginSignUpBodyState();
}

class _LoginSignUpBodyState extends State<LoginSignUpBody> {
  bool obscure = false;
  bool isLoading = false;
  bool userAgreement = false;
  bool signup = false;
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  // final phoneController = TextEditingController();
  String phoneNumber = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15),
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        // height: MediaQuery.of(context).size.height / 2,
        // margin: EdgeInsets.symmetric(vertical: 20),

        decoration: BoxDecoration(
          // color: Colors.black26,
          borderRadius: BorderRadius.circular(14),
        ),

        child: content(),
      ),
    );
  }

  Widget content() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.network('images/${signup ? "sbg" : 'rin'}.png'),
            SizedBox(height: 25),

            ///email to login
            Tfield(
              contr: emailController,
              preIcon: Icon(Icons.email, color: Colors.grey),
              title: 'Email',
              hint: 'jaykong@gmail.com',
              suffixIcon: SizedBox(),
            ),
            signup == false ? SizedBox.shrink() : SizedBox(height: 20),

            ///fullName to login
            signup == false
                ? SizedBox.shrink()
                : Tfield(
                    contr: fullNameController,
                    preIcon: Icon(Icons.person, color: Colors.grey),
                    title: 'Full Name',
                    hint: 'Jay Kong',
                    suffixIcon: SizedBox(),
                  ),
            SizedBox(height: 20),

            ///phone
            signup == false
                ? SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: IntlPhoneField(
                      pickerDialogStyle: PickerDialogStyle(
                        searchFieldInputDecoration: InputDecoration(
                          counterStyle: TextStyle(color: white),
                          helperStyle: TextStyle(color: white),
                          floatingLabelStyle: TextStyle(color: white),
                          labelStyle: TextStyle(color: white),
                          prefixStyle: TextStyle(color: white),
                          errorStyle: TextStyle(color: white),
                          suffixStyle: TextStyle(color: white),
                          hintText: 'Search country',
                          hintStyle:
                              TextStyle(color: Colors.grey), // Hint text color
                          filled: true,
                          fillColor:
                              Colors.black, // Search field background color
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white), // Border color
                          ),
                        ),
                        searchFieldCursorColor: amber,

                        backgroundColor:
                            Colors.black, // Set popup background color
                        countryCodeStyle: TextStyle(
                            color: Colors.white), // Country code text color
                        countryNameStyle: TextStyle(
                            color: Colors.white), // Country name text color
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                      style: TextStyle(color: white),
                      dropdownTextStyle: TextStyle(color: white),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        filled: true,
                        fillColor: Color(0xFF23262F),
                        hintStyle: TextStyle(color: white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: amber),
                        ),
                      ),
                      // pickerDialogStyle: PickerDialogStyle,
                      initialCountryCode: 'US',
                      onChanged: (phone) {
                        setState(() {
                          phoneNumber = phone.completeNumber;
                        });
                        print(phone.completeNumber);
                        print(phone.number);
                      },
                    ),
                  ),

            ///password
            Tfield(
              contr: passwordController,
              preIcon: Icon(Icons.lock_open_sharp, color: Colors.grey),
              title: 'Password',
              hint: '* * * * * *',
              obscure: obscure,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                child: Icon(
                  obscure ? Icons.visibility_off_sharp : Icons.visibility_sharp,
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  signup = !signup;
                });
              },
              child: Image.network(
                'images/or${(signup ? "r" : 's')}.png',
                scale: 2,
              ),
            ),
            SizedBox(height: 15),

            ///user agreement
            signup ? userAgreementCont() : SizedBox(),
            SizedBox(height: 15),

            ///login button
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: amber,
                      strokeWidth: 1.2,
                    ),
                  )
                : ContinueButton(
                    onTap: () {
                      signup
                          ?

                          ///signup function
                          signUpFunction()
                          :

                          ///login function
                          signInFunction();
                    },
                    title: signup ? "Sign Up" : "Log in",
                  ),
          ],
        ),
      ),
    );
  }

  Widget userAgreementCont() {
    return Row(
      children: [
        Checkbox(
            value: userAgreement,
            activeColor: amber,
            onChanged: (v) {
              setState(() {
                userAgreement = v!;
              });
            }),

        ///user agremment
        Text(
          'I have read and agreed to the',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: fWLargeFont,
            fontSize: kTextTinyHigh,
          ),
        ),
        SizedBox(width: 5),
        Text(
          'User and Agreement',
          style: TextStyle(
            color: amber,
            fontWeight: fWLargeFont,
            fontSize: kTextTinyHigh,
          ),
        ),
        SizedBox(width: 5),
        Text(
          '&',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: fWLargeFont,
            fontSize: kTextTinyHigh,
          ),
        ),
        SizedBox(width: 5),
        Text(
          'Privacy Policy',
          style: TextStyle(
            color: amber,
            fontWeight: fWLargeFont,
            fontSize: kTextTinyHigh,
          ),
        ),
      ],
    );
  }

  ///signup function
  signUpFunction() {
    if (emailController.text.isEmpty) {
      generalProvider.badToast(
          context: context, title: 'email must not be empty');
    } else if (!emailController.text.contains('@')) {
      generalProvider.badToast(
          context: context, title: 'email is badly formatted');
    } else if (fullNameController.text.isEmpty) {
      generalProvider.badToast(
        context: context,
        title: 'password must not be empty',
      );
    } else if (passwordController.text.isEmpty) {
      generalProvider.badToast(
        context: context,
        title: 'password must not be empty',
      );
    } else if (passwordController.text.characters.length < 6) {
      generalProvider.badToast(
        context: context,
        title: 'password must be more than 6 characters',
      );
    } else if (phoneNumber.isEmpty) {
      generalProvider.badToast(
        context: context,
        title: 'phone number must not be empty',
      );
    } else if (userAgreement == false) {
      generalProvider.badToast(
        context: context,
        title: 'accept user agreement',
      );
    } else {
      setState(() {
        isLoading = true;
      });
      return AuthService()
          .signUpWithEmail(
              fullName: fullNameController.text,
              context: context,
              email: emailController.text,
              phone: phoneNumber,
              password: passwordController.text)
          .then(
        (v) {
          setState(() {
            isLoading = false;
          });
        },
      );
    }
  }

  signInFunction() {
    if (emailController.text.isEmpty) {
      generalProvider.badToast(
          context: context, title: 'email must not be empty');
    } else if (!emailController.text.contains('@')) {
      generalProvider.badToast(
          context: context, title: 'email is badly formatted');
    } else if (passwordController.text.isEmpty) {
      generalProvider.badToast(
        context: context,
        title: 'password must not be empty',
      );
    } else {
      setState(() {
        isLoading = true;
      });
      return AuthService()
          .loginWithEmail(
              context: context,
              email: emailController.text,
              password: passwordController.text)
          .then(
        (v) {
          setState(() {
            isLoading = false;
          });
        },
      );
    }
  }
}
