// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/auth/forgotpassword_page.dart';
import 'package:doceo_new/pages/auth/verification_page.dart';
import 'package:doceo_new/pages/home/main_screen.dart';
import 'package:doceo_new/pages/initialUserSetting/select_icon_page.dart';
import 'package:doceo_new/pages/splash/sel_page.dart';
import 'package:doceo_new/pages/transitionToHome/transition.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:toast/toast.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPage createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  bool _passwordVisible = true;
  bool btnStatus = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  int titleVal = 0;
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
                            'おかえりなさい！',
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
                                'アカウント情報',
                                style: TextStyle(
                                    fontFamily: 'M_PLUS', fontSize: 13),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 5),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                // obscureText: _passwordVisible,

                                decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xffEBECEE),
                                    suffixIcon:
                                        Icon(Icons.email, color: Colors.grey),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    hintText: 'メールアドレス',
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
                                      borderSide:
                                          BorderSide(color: Colors.black),
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
                            Container(
                              padding: const EdgeInsets.only(top: 2),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPasswordPage()));
                                  },
                                  child: Text(
                                    'パスワードをお忘れですか？',
                                    style: TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontSize: 13,
                                        color: Color(0xff1997F6)),
                                  )),
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
                              // context.go('/transitionToHome');
                              goHome();
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
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
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () => Future.value(false));
  }

  void goHome() async {
    setState(() {
      btnStatus = true;
    });
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      try {
        await Amplify.Auth.signOut();
        var res = await Amplify.Auth.signIn(
          username: email.text.toString(),
          password: password.text.toString(),
        );
        print(res);
        if (res.nextStep.signInStep == AuthSignInStep.confirmSignUp) {
          await Amplify.Auth.resendSignUpCode(username: email.text);
          setState(() {
            btnStatus = false;
          });
          AuthenticateProviderPage.of(context).signVal = 1;
          AuthenticateProviderPage.of(context).verificationTool = email.text;
          AuthenticateProviderPage.of(context).password = password.text;
          AuthenticateProviderPage.of(context, listen: false)
              .verificationTitle = email.text + "に送信しました";
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => VerificationPage()));
          return;
        }
        final userData = await Amplify.Auth.fetchUserAttributes();
        Map userInfo = {};
        for (final element in userData) {
          userInfo.addAll(
              {"${element.userAttributeKey.key.toString()}": element.value});
        }
        print(userInfo);
        AuthenticateProviderPage.of(context, listen: false).isAuthenticated =
            true;
        AuthenticateProviderPage.of(context, listen: false).user = userInfo;
        try {
          String userId = userInfo['sub'];
          String graphQLDocument = '''query createUserToken {
            CreateUserToken(id: "$userId"){
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
          print(response.errors.toString());
          if (res['CreateUserToken']['token'].toString().isNotEmpty) {
            AuthenticateProviderPage.of(context, listen: false).getStreamToken =
                res['CreateUserToken']['token'].toString();
            AppProviderPage.of(context, listen: false).rooms =
                res['CreateUserToken']['rooms'];
            int userNum = 0;
            List roomSigned = [];
            // String roomNumber = '';

            for (var item in res['CreateUserToken']['rooms']) {
              userNum =
                  item['members'].where((e) => e['user_id'] == userId).length;
              if (userNum > 0) {
                // roomNumber =
                //     (roomNumber == '' ? item['channel']['id'] : roomNumber);
                roomSigned.add({'status': true});
              } else {
                roomSigned.add({'status': false});
              }
              userNum = 0;
            }
            AppProviderPage.of(context, listen: false).roomSigned = roomSigned;
            // print(roomNumber);
            // return;

            try {
              final client = StreamChat.of(context).client;
              await client.disconnectUser();
              await client.connectUser(
                User(id: userId),
                AuthenticateProviderPage.of(context, listen: false)
                    .getStreamToken,
              );
              if (MainScreen.targetChannel.isNotEmpty) {
                final channel = await client.queryChannel(
                    MainScreen.targetChannelType,
                    channelId: MainScreen.targetChannel);

                AppProviderPage.of(context).selectedRoom =
                    channel.channel!.extraData['room'].toString();
              }
              setState(() {
                btnStatus = false;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TransitionPage()));
            } on ApiException catch (e) {
              print('Query failed: $e');
              AuthenticateProviderPage.of(context, listen: false)
                  .notifyToastDanger(message: "エラーです。もう一度お試しください。");
            }
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
        print('Error: ${e}');
        // print(e is UserNotConfirmedException);
        // if (e is UserNotConfirmedException) {}
        setState(() {
          btnStatus = false;
        });
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: "サインイン エラーです。もう一度お試しください。");
      }
    } else {
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラー、すべての入力を埋めてください!");
    }
    setState(() {
      btnStatus = false;
    });
  }
}
