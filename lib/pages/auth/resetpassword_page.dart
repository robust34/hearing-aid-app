// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/auth/birthday_page.dart';
import 'package:doceo_new/pages/auth/confirmpassword_page.dart';
import 'package:doceo_new/pages/auth/forgotpassword_page.dart';
import 'package:doceo_new/pages/auth/signin_page.dart';
import 'package:doceo_new/pages/initialUserSetting/select_icon_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../services/auth_provider.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPage createState() => new _ResetPasswordPage();
}

class _ResetPasswordPage extends State<ResetPasswordPage> {
  bool _passwordVisible = true;
  TextEditingController password = TextEditingController();
  bool btnStatus = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            titleSpacing: 0,
            title: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "戻る",
                style: TextStyle(
                  fontFamily: 'M_PLUS',
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            // ignore: unnecessary_new
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 13),
                            child: Text(
                              "新しいパスワードを設定する",
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'パスワードは、英数字小文字大文字含む8文字以上で！',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              obscureText: _passwordVisible,
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xffEBECEE),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: 'パスワード',
                                  hintStyle: const TextStyle(
                                      fontFamily: 'M_PLUS',
                                      color: Colors.grey,
                                      fontSize: 15)),
                              controller: password,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            resetPassword();
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  Color(0xffB44DD9),
                                  Color(0xff70A4F2)
                                ]),
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 40,
                              alignment: Alignment.center,
                              child: btnStatus
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 1)
                                  : const Text(
                                      '完了',
                                      style: const TextStyle(
                                          fontFamily: 'M_PLUS',
                                          fontSize: 15,
                                          fontStyle: FontStyle.normal,
                                          color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
        ),
        onWillPop: () => Future.value(false));
  }

  void resetPassword() async {
    setState(() {
      btnStatus = true;
    });

    try {
      await Amplify.Auth.confirmResetPassword(
          username: AuthenticateProviderPage.of(context).verificationTitle,
          newPassword: password.text,
          confirmationCode:
              AuthenticateProviderPage.of(context).verificationTool);
      setState(() {
        btnStatus = false;
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInPage()));
    } on AuthException catch (e) {
      setState(() {
        btnStatus = false;
      });
      safePrint(e.message);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }

  // void signIn() async {
  //   String verificationTool =
  //       AuthenticateProviderPage.of(context, listen: false).verificationTool;
  // }
}
