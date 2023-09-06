import 'dart:async';
import 'dart:ui';
import 'package:doceo_new/pages/auth/signin_page.dart';
import 'package:doceo_new/pages/auth/signup_page.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';

class SelPage extends StatefulWidget {
  @override
  _SelPage createState() => new _SelPage();
}

class _SelPage extends State<SelPage> {
  void initState() {
    super.initState();
    loginCheckStatus();
  }

  void loginCheckStatus() async {
    bool checkVal = await AuthenticateProviderPage.of(context, listen: false)
        .getLoginStatus();
    print(checkVal);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
          backgroundColor: Colors.white,
          body: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Image.asset(
                        'assets/images/sel-background.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.695),
                          alignment: Alignment.center,
                          child: Text(
                            'DOCEOへようこそ',
                            style: TextStyle(
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.bold,
                                fontSize: 26),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.005),
                          child: Text(
                            'あなたの悩みと医師のスペシャリティを繋ぐ\n新しい医療相談コミュニティ',
                            style: TextStyle(
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.normal,
                                fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.03),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage()));
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
                                  '新規登録',
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
                        Container(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInPage()));
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [
                                    Color(0xff63CEF0),
                                    Color(0xff63CEF0)
                                  ]),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 40,
                                alignment: Alignment.center,
                                child: const Text(
                                  'ログイン',
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
                    ),
                  ],
                )
                // new Container(
                //   height: MediaQuery.of(context).size.height * 0.75,
                //   child: Container(
                //     padding: EdgeInsets.only(
                //       top: MediaQuery.of(context).size.height * 0.5,
                //     ),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             Container(
                //               child: Text(
                //                 'DOCEOへようこそ',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.bold,
                //                     fontSize: 26),
                //               ),
                //             )
                //           ],
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             Container(
                //               child: Text(
                //                 'あなたの悩みと医師のスペシャリティを繋ぐ\n新しい医療相談コミュニティ',
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.normal,
                //                     fontSize: 15),
                //                 textAlign: TextAlign.center,
                //               ),
                //             )
                //           ],
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             new Container(
                //               width: MediaQuery.of(context).size.width * 0.9,
                //               padding: EdgeInsets.only(top: 30),
                //               margin: EdgeInsets.only(),
                //               child: new MaterialButton(
                //                   onPressed: () {},
                //                   padding: EdgeInsets.only(
                //                     top: 10,
                //                     bottom: 10,
                //                   ),
                //                   color: Colors.grey,
                //                   shape: RoundedRectangleBorder(
                //                       borderRadius:
                //                           BorderRadius.circular(10.0)),
                //                   child: new Row(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                     mainAxisSize: MainAxisSize.min,
                //                     children: [
                //                       new Text('SAVE',
                //                           style: new TextStyle(
                //                               color: Colors.white,
                //                               fontSize: 25.0,
                //                               fontWeight: FontWeight.w500)),
                //                     ],
                //                   )),
                //             )
                //           ],
                //         )
                //       ],
                //     ),
                //   ),
                //   decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage(
                //           'assets/images/room-f_2.png',
                //         ),
                //         fit: BoxFit.fill),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        onWillPop: () => Future.value(false));
  }
}
