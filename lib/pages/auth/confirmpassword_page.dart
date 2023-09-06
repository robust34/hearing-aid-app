// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/auth/birthday_page.dart';
import 'package:doceo_new/pages/auth/forgotpassword_page.dart';
import 'package:doceo_new/pages/auth/resetpassword_page.dart';
import 'package:doceo_new/pages/auth/signin_page.dart';
import 'package:doceo_new/pages/initialUserSetting/select_icon_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../services/auth_provider.dart';

class ConfirmPasswordPage extends StatefulWidget {
  @override
  _ConfirmPasswordPage createState() => new _ConfirmPasswordPage();
}

class _ConfirmPasswordPage extends State<ConfirmPasswordPage> {
  TextEditingController verificationCode = new TextEditingController();
  int titleVal = 0;
  bool btnStatus = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      titleVal = AuthenticateProviderPage.of(context, listen: false).signVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
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
        actions: [
          TextButton(
            onPressed: () {
              resendCode();
            },
            child: const Text('再送する',
                style: TextStyle(
                    color: Color(0xFF1997F6),
                    fontFamily: 'M_PLUS',
                    fontSize: 17,
                    fontWeight: FontWeight.w500)),
          )
        ],
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
                        margin: EdgeInsets.only(bottom: 17),
                        child: const Text(
                          "認証番号を入力してください",
                          style: TextStyle(
                              fontFamily: 'M_PLUS',
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: Text(
                          AuthenticateProviderPage.of(context, listen: false)
                                  .verificationTitle +
                              'に送信しました',
                          style: const TextStyle(
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
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xffEBECEE),
                        // suffixIcon: Icon(Icons.phone, color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        hintText: '',
                      ),
                      controller: verificationCode,
                    ),
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
                        goResetPassword();
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xffB44DD9), Color(0xff70A4F2)]),
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
                                  '次へ',
                                  style: TextStyle(
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
    );
    ;
  }

  void resendCode() async {
    setState(() {
      btnStatus = true;
    });
    String verificationTitle =
        AuthenticateProviderPage.of(context, listen: false).verificationTitle;
    try {
      final result =
          await Amplify.Auth.resetPassword(username: verificationTitle);
      safePrint(result);
      setState(() {
        btnStatus = false;
      });
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastSuccess('認証番号を再送しました', context);
    } on AuthException catch (e) {
      safePrint(e.message);
      setState(() {
        btnStatus = false;
      });
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: 'エラーです。入力してください!');
    }
  }

  void goResetPassword() async {
    setState(() {
      btnStatus = true;
    });
    AuthenticateProviderPage.of(context, listen: false).verificationTool =
        verificationCode.text;

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ResetPasswordPage()));
  }
}
