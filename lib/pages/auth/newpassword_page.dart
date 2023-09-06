// ignore_for_file: avoid_print

import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/auth/birthday_page.dart';
import 'package:doceo_new/pages/auth/signin_page.dart';
import 'package:doceo_new/pages/auth/verification_page.dart';
import 'package:doceo_new/pages/initialUserSetting/select_icon_page.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class NewPasswordPage extends StatefulWidget {
  @override
  _NewPasswordPage createState() => _NewPasswordPage();
}

class _NewPasswordPage extends State<NewPasswordPage> {
  bool _passwordVisible = true;
  bool btnStatus = false;
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  int titleVal = 0;
  final Uri _terms = Uri.parse('https://doceo.jp/terms/');
  final Uri _privacy = Uri.parse('https://doceo.jp/privacy/');
  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = _openTerms;
    _privacyRecognizer = TapGestureRecognizer()..onTap = _openPrivacy;
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
            child: new SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text(
                          '登録',
                          style: TextStyle(
                              fontFamily: 'M_PLUS',
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      )
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
                              'ユーザー名を入力',
                              style:
                                  TextStyle(fontFamily: 'M_PLUS', fontSize: 13),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffEBECEE),
                                // suffixIcon: Icon(Icons.phone, color: Colors.grey),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                hintText: '',
                              ),
                              controller: username,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 2),
                            child: const Text(
                              '後からいつでも変更できます！',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontSize: 13,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                      )
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
                              'パスワードを入力',
                              style:
                                  TextStyle(fontFamily: 'M_PLUS', fontSize: 13),
                            ),
                          ),
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
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                hintText: '',
                              ),
                              controller: password,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 2),
                            child: const Text(
                              'パスワードは、英数字小文字大文字含む8文字以上で！',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontSize: 13,
                                  color: Colors.grey),
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
                            // context.go('/');
                            // getVeificationCode();
                            getVerification();
                            // context.go('/selectIcon');
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: RichText(
                              text: TextSpan(
                                text: '登録を行うことで、DOCEOの ',
                                style: TextStyle(
                                    fontFamily: 'M_PLUS',
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xffB4BABF)),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'サービス利用規約',
                                    recognizer: _termsRecognizer,
                                    style: const TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xff1997F6)),
                                  ),
                                  const TextSpan(
                                    text: ' 及び ',
                                    style: TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xffB4BABF)),
                                  ),
                                  TextSpan(
                                    text: '\nプライバシーポリシー',
                                    recognizer: _privacyRecognizer,
                                    style: const TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xff1997F6)),
                                  ),
                                  const TextSpan(
                                    text: ' に同意したものとみなされます。',
                                    style: TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xffB4BABF)),
                                  ),
                                ],
                              ),
                            ),
                            //  const Text(
                            //   '登録を行うことで、DOCEOの サービス利用規約 及び プライ\nバシーポリシー に同意したものとみなされます。',
                            //   style: TextStyle(
                            //       fontFamily: 'M_PLUS',
                            //       fontSize: 13,
                            //       color: Colors.grey),
                            // ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
        ),
        onWillPop: () => Future.value(false));
  }

  void getVerification() async {
    setState(() {
      btnStatus = true;
    });
    AuthenticateProviderPage.of(context, listen: false).userName =
        username.text.toString();
    AuthenticateProviderPage.of(context, listen: false).password =
        password.text.toString();
    int selVal = AuthenticateProviderPage.of(context, listen: false).signVal;
    String verificationTool =
        AuthenticateProviderPage.of(context, listen: false).verificationTool;
    String birthday =
        AuthenticateProviderPage.of(context, listen: false).birthday;
    String userName = username.text;
    if (username.text.isNotEmpty && password.text.isNotEmpty) {
      if (password.text.length >= 8) {
        if (selVal == 0) {
          try {
            print(verificationTool);
            final userAttributes = <CognitoUserAttributeKey, String>{
              CognitoUserAttributeKey.phoneNumber: '+$verificationTool',
              CognitoUserAttributeKey.name: username.text.toString(),
              CognitoUserAttributeKey.birthdate: birthday.toString(),
              CognitoUserAttributeKey.gender: 'male',
              const CognitoUserAttributeKey.custom('groupname'): 'Users'
              // additional attributes as needed
            };
            await Amplify.Auth.signUp(
              username: '+$verificationTool',
              password: password.text.toString(),
              options: CognitoSignUpOptions(userAttributes: userAttributes),
            );
            setState(() {
              btnStatus = false;
            });
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => VerificationPage()));
          } on UserNotConfirmedException catch (e) {
            safePrint(e.message);
            await Amplify.Auth.resendSignUpCode(
                username: username.text.toString());
            setState(() {
              btnStatus = false;
            });
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => VerificationPage()));
          } on AuthException catch (e) {
            safePrint(e.message);
            setState(() {
              btnStatus = false;
            });
            AuthenticateProviderPage.of(context, listen: false)
                .notifyToastDanger(message: "エラー サインアップ!, もう一度お試しください!");
          }
        } else {
          try {
            final userAttributes = <CognitoUserAttributeKey, String>{
              CognitoUserAttributeKey.email: verificationTool,
              CognitoUserAttributeKey.name: username.text.toString(),
              CognitoUserAttributeKey.birthdate: birthday.toString(),
              const CognitoUserAttributeKey.custom('groupname'): 'Users'
              // additional attributes as needed
            };
            final result = await Amplify.Auth.signUp(
              username: verificationTool,
              password: password.text.toString(),
              options: CognitoSignUpOptions(userAttributes: userAttributes),
            );
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => VerificationPage()));
            setState(() {
              btnStatus = false;
            });
          } on UsernameExistsException catch (_) {
            setState(() {
              btnStatus = false;
            });
            AuthenticateProviderPage.of(context, listen: false)
                .notifyToastDanger(message: "登録済みのアドレスです。\nログインからお進みください。");
            sleep(const Duration(seconds: 1));
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignInPage()));
          } on AuthException catch (e) {
            print(e);
            safePrint(e.message);
            setState(() {
              btnStatus = false;
            });
            AuthenticateProviderPage.of(context, listen: false)
                .notifyToastDanger(message: "エラー サインアップ!, もう一度お試しください!");
          }
        }
      } else {
        setState(() {
          btnStatus = false;
        });
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: "エラーです。パスワードは 8 文字以上にする必要があります。");
      }
    } else {
      setState(() {
        btnStatus = false;
      });
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラー、すべての入力を埋めてください!");
    }
  }

  void _openTerms() async {
    if (!await launchUrl(_terms, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $_terms');
    }
  }

  void _openPrivacy() async {
    if (!await launchUrl(
      _privacy,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $_privacy');
    }
  }
}
