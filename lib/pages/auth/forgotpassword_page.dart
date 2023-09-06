// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/auth/confirmpassword_page.dart';
import 'package:doceo_new/pages/auth/signin_page.dart';
import 'package:doceo_new/pages/initialUserSetting/select_icon_page.dart';
import 'package:doceo_new/pages/splash/sel_page.dart';
import 'package:doceo_new/pages/transitionToHome/transition.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:toast/toast.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPage createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  bool _passwordVisible = true;
  bool btnStatus = false;
  TextEditingController email = TextEditingController();
  int titleVal = 0;
  @override
  void initState() {
    super.initState();
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // ignore: unnecessary_new
          child: new SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 32),
                        child: const Text(
                          'パスワードリセット',
                          style: TextStyle(
                              fontFamily: 'M_PLUS',
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        child: const Text(
                          'ご登録のメールアドレスに認証コードをお送ります \n認証が完了したのち、新しいパスワードを入力ください',
                          style: TextStyle(
                              fontFamily: 'M_PLUS',
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ])
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: const Text(
                            'ご登録のメールアドレス',
                            style:
                                TextStyle(fontFamily: 'M_PLUS', fontSize: 13),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 5),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Color(0xffEBECEE),
                                suffixIcon:
                                    Icon(Icons.email, color: Colors.grey),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                    fontFamily: 'M_PLUS',
                                    fontSize: 15,
                                    color: Colors.grey)),
                            controller: email,
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
                      padding: const EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          goConfirm();
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
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 1)
                                : const Text(
                                    'パスワードをリセットする',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goConfirm() async {
    setState(() {
      btnStatus = true;
    });
    if (email.text.isNotEmpty) {
      try {
        final result = await Amplify.Auth.resetPassword(
          username: email.text.toString(),
        );
        setState(() {
          btnStatus = false;
        });
        AuthenticateProviderPage.of(context, listen: false).verificationTitle =
            email.text;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ConfirmPasswordPage()));
      } on AuthException catch (e) {
        print(e.toString());
        safePrint(e.message);
        setState(() {
          btnStatus = false;
        });
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: "サインイン エラーです。もう一度お試しください。");
      }
    } else {
      setState(() {
        btnStatus = false;
      });
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラー、すべての入力を埋めてください!");
    }
  }
}
