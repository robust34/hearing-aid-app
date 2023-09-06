// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/auth/birthday_page.dart';
import 'package:doceo_new/pages/splash/sel_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../services/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPage createState() => new _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  int segmentedControlGroupValue = 1;
  int selInput = 1;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text(
      "電話",
      style: TextStyle(fontFamily: 'M_PLUS', fontSize: 15),
    ),
    1: Text(
      "メールアドレス",
      style: TextStyle(fontFamily: 'M_PLUS', fontSize: 15),
    )
  };
  TextEditingController email = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      // segmentedControlGroupValue =
      //     AuthenticateProviderPage.of(context, listen: false).signVal;
      // selInput = AuthenticateProviderPage.of(context, listen: false).signVal;
      // (segmentedControlGroupValue == 1)
      //     ? email.text = AuthenticateProviderPage.of(context, listen: false)
      //         .verificationTool
      //     : phone.text = AuthenticateProviderPage.of(context, listen: false)
      //         .verificationTool;
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
            leading: Container(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
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
                      Expanded(
                        child: new Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: new Text(
                            "メールアドレスを入力してください",
                            style: new TextStyle(
                                fontFamily: 'M_PLUS',
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       width: MediaQuery.of(context).size.width * 0.9,
                  //       padding: EdgeInsets.only(top: 30),
                  //       child: CupertinoSlidingSegmentedControl(
                  //         groupValue: segmentedControlGroupValue,
                  //         children: myTabs,
                  //         onValueChanged: (val) {
                  //           print(val);
                  //           setState(() {
                  //             segmentedControlGroupValue =
                  //                 int.parse(val.toString());
                  //             selInput = int.parse(val.toString());

                  //             // AuthenticateProviderPage.of(context, listen: false).signVal = val;
                  //           });
                  //         },
                  //       ),
                  //     )
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                                top: 40,
                                left: MediaQuery.of(context).size.width * 0.05),
                            child: (selInput == 0)
                                ? Text(
                                    '電話番号',
                                    style: TextStyle(
                                        fontFamily: 'M_PLUS', fontSize: 13),
                                  )
                                : Text(
                                    'メールアドレス',
                                    style: TextStyle(
                                        fontFamily: 'M_PLUS', fontSize: 13),
                                  ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                                top: 10,
                                left: MediaQuery.of(context).size.width * 0.05,
                                right:
                                    MediaQuery.of(context).size.width * 0.05),
                            child: (selInput == 0)
                                ? new TextFormField(
                                    decoration: new InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xffEBECEE),
                                      suffixIcon:
                                          Icon(Icons.phone, color: Colors.grey),
                                      focusedBorder: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.black),
                                      ),
                                      enabledBorder: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      hintText: '',
                                    ),
                                    controller: phone,
                                  )
                                : new TextFormField(
                                    decoration: new InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xffEBECEE),
                                      suffixIcon:
                                          Icon(Icons.email, color: Colors.grey),
                                      focusedBorder: new OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Colors.black),
                                      ),
                                      enabledBorder: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      hintText: '',
                                    ),
                                    controller: email,
                                  ),
                          )
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
                            // context.go('/');
                            getVeificationCode();
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
                              child: const Text(
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

  void getVeificationCode() {
    if (segmentedControlGroupValue == 0) {
      print(phone.text.length);
      if (phone.text.length > 0) {
        setState(() {
          AuthenticateProviderPage.of(context, listen: false).signVal =
              segmentedControlGroupValue;
          AuthenticateProviderPage.of(context, listen: false)
              .verificationTitle = "SMSを" + phone.text + "に送信しました";
          AuthenticateProviderPage.of(context, listen: false).verificationTool =
              phone.text;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BirthdayPage()));
      } else {
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToast(message: "エラーです。値を入力してください。");
      }
    } else {
      if (email.text.length > 0) {
        setState(() {
          AuthenticateProviderPage.of(context, listen: false).signVal =
              segmentedControlGroupValue;
          AuthenticateProviderPage.of(context, listen: false)
              .verificationTitle = email.text + "に送信しました";
          AuthenticateProviderPage.of(context, listen: false).verificationTool =
              email.text;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BirthdayPage()));
      } else {
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToast(message: "エラーです。値を入力してください。");
      }
    }
  }
}
