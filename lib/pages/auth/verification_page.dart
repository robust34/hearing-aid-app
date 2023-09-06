// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/auth/birthday_page.dart';
import 'package:doceo_new/pages/initialUserSetting/select_icon_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:toast/toast.dart';

import '../../services/auth_provider.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPage createState() => new _VerificationPage();
}

class _VerificationPage extends State<VerificationPage> {
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
    return new WillPopScope(
        child: new Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
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
          body: new SafeArea(
              child: new SingleChildScrollView(
            // ignore: unnecessary_new
            child: new SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: new Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (titleVal == 0)
                          ? Column(
                              children: [
                                new Container(
                                  child: new Text(
                                    "確認コードを入力してください",
                                    style: new TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.only(top: 20),
                                  child: new Text(
                                    AuthenticateProviderPage.of(context,
                                            listen: false)
                                        .verificationTitle,
                                    style: new TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontSize: 13,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                new Container(
                                  child: new Text(
                                    "認証番号を入力してください",
                                    style: new TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                new Container(
                                  child: new Text(
                                    AuthenticateProviderPage.of(context,
                                            listen: false)
                                        .verificationTitle,
                                    style: new TextStyle(
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
                        child: new TextFormField(
                          decoration: new InputDecoration(
                            filled: true,
                            fillColor: Color(0xffEBECEE),
                            // suffixIcon: Icon(Icons.phone, color: Colors.grey),
                            focusedBorder: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                            ),
                            enabledBorder: new OutlineInputBorder(
                              borderSide: new BorderSide(
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
                            // context.go('/');
                            // getVeificationCode();
                            goSignIn();
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
                                      '次へ',
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

  void resendCode() async {
    setState(() {
      btnStatus = true;
    });
    String verificationTool =
        AuthenticateProviderPage.of(context, listen: false).verificationTool;
    print(verificationTool);
    try {
      final result =
          await Amplify.Auth.resendSignUpCode(username: verificationTool);
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

  void goSignIn() async {
    setState(() {
      btnStatus = true;
    });
    String verificationTool =
            AuthenticateProviderPage.of(context, listen: false)
                .verificationTool,
        password = AuthenticateProviderPage.of(context, listen: false).password;
    if (verificationCode.text.length > 0) {
      try {
        await Amplify.Auth.confirmSignUp(
            username: verificationTool,
            confirmationCode: verificationCode.text.toString());
      } on AuthException catch (e) {
        if (e is AuthNotAuthorizedException != false) {
          print(e.message);
          setState(() {
            btnStatus = false;
          });
          AuthenticateProviderPage.of(context, listen: false)
              .notifyToastDanger(message: 'エラー、認証コードが正しくありません!');
        }
        return;
      }

      try {
        await Amplify.Auth.signIn(
            username: verificationTool, password: password);
      } on AuthException catch (e) {
        safePrint(e);
        return;
      }

      try {
        final result = await Amplify.Auth.getCurrentUser();
        final userData = await Amplify.Auth.fetchUserAttributes();
        Map userInfo = {};
        for (final element in userData) {
          userInfo.addAll({"${element.userAttributeKey.key}": element.value});
        }
        AuthenticateProviderPage.of(context, listen: false).isAuthenticated =
            true;
        AuthenticateProviderPage.of(context, listen: false).user = userInfo;
        String id = userInfo['sub'];

        try {
          String graphQLDocument = '''query createUserToken {
            CreateUserToken(id: "$id"){
              token
              rooms{
                channel{
                  id
                  name
                  description
                  image
                }
                members{
                  role
                  user_id
                  user{
                    role
                    image
                    firstName
                    lastName
                  }
                }
              }
            }
          }''';

          var operation = Amplify.API.query(
              request: GraphQLRequest<String>(document: graphQLDocument));

          var response = await operation.response;

          var res = json.decode(response.data.toString());
          print(res);
          if (res['CreateUserToken']['token'].toString().isNotEmpty) {
            AuthenticateProviderPage.of(context, listen: false).getStreamToken =
                res['CreateUserToken']['token'].toString();
            AppProviderPage.of(context, listen: false).rooms =
                res['CreateUserToken']['rooms'];

            final client = StreamChat.of(context).client;
            await client.disconnectUser();
            await client.connectUser(
              User(id: id),
              res['CreateUserToken']['token'].toString(),
            );

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const SelectIconPage(fromPage: 'verification')));
          } else {
            print('error**********');
            AuthenticateProviderPage.of(context, listen: false)
                .notifyToastDanger(message: "エラーです。もう一度お試しください。");
          }
        } on ApiException catch (e) {
          print('Query failed: $e');
          AuthenticateProviderPage.of(context, listen: false)
              .notifyToastDanger(message: "エラーです。もう一度お試しください。");
        }
      } on AuthException catch (e) {
        safePrint(e.message);
        setState(() {
          btnStatus = false;
        });
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: 'エラー、認証コードが正しくありません!');
      }
    } else {
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: 'エラーです。入力してください!');
    }
    setState(() {
      btnStatus = false;
    });
  }

  // void signIn() async {
  //   String verificationTool =
  //       AuthenticateProviderPage.of(context, listen: false).verificationTool;
  // }
}
