// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/home/home_page.dart';
import 'package:doceo_new/pages/initialUserSetting/select_icon_page.dart';
import 'package:doceo_new/pages/myPage/accout_page.dart';
import 'package:doceo_new/pages/myPage/font_size_setting_page.dart';
import 'package:doceo_new/pages/myPage/join_room_page.dart';
import 'package:doceo_new/pages/myPage/notification_setting_page.dart';
import 'package:doceo_new/pages/myPage/point_charge_modal.dart';
import 'package:doceo_new/pages/myPage/point_history_page.dart';
import 'package:doceo_new/pages/myPage/profile_page.dart';
import 'package:doceo_new/pages/splash/sel_page.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreen createState() => _MyPageScreen();
}

class _MyPageScreen extends State<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final formatter = NumberFormat.compact();

    return Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        body: BetterStreamBuilder(
            stream: StreamChat.of(context).client.state.currentUserStream,
            builder: (context, data) {
              var avatarUrl =
                  data!.image ?? 'assets/images/avatars/default.png';
              var userName = data.name;
              return Column(
                children: [
                  SizedBox(
                      height: height * 0.2,
                      child: Stack(children: [
                        FractionallySizedBox(
                            heightFactor: 3 / 4,
                            widthFactor: 1.0,
                            child: Image.asset(
                              'assets/images/my-page-header.png',
                              fit: BoxFit.cover,
                            )),
                        Column(children: [
                          Expanded(flex: 1, child: Container()),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: width * 0.04, top: 0, bottom: 0),
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.zero)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SelectIconPage(fromPage: 'myPage'),
                                      ),
                                    );
                                  },
                                  child: AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Stack(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: avatarUrl.isNotEmpty
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                avatarUrl),
                                                            fit:
                                                                BoxFit.contain),
                                                        color: Colors.white,
                                                        shape: BoxShape.circle))
                                                : Container(
                                                    alignment: Alignment.center,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.blueAccent,
                                                    ),
                                                    child: Text(
                                                      userName.length >= 2
                                                          ? userName
                                                              .substring(0, 2)
                                                              .toUpperCase()
                                                          : userName
                                                              .substring(0, 1)
                                                              .toUpperCase(),
                                                      style: const TextStyle(
                                                          fontFamily: 'M_PLUS',
                                                          fontSize: 40,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                        Container(
                                          height: 23,
                                          alignment: Alignment.topRight,
                                          padding:
                                              EdgeInsets.only(top: 2, right: 2),
                                          child: AspectRatio(
                                              aspectRatio: 1.0,
                                              child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle),
                                                  child: SvgPicture.asset(
                                                      'assets/images/pencil.svg',
                                                      fit: BoxFit.cover))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ])
                      ])),
                  Padding(
                    padding: EdgeInsets.only(
                        right: width * 0.04, left: width * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: 'M_PLUS',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: SvgPicture.asset(
                                        'assets/images/coin-icon.svg',
                                        fit: BoxFit.cover)),
                                const SizedBox(width: 10),
                                Text(
                                  data.extraData['point'] != null
                                      ? formatter
                                          .format(data.extraData['point'])
                                      : '0',
                                  style: TextStyle(
                                      fontFamily: 'M_PLUS',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff777777)),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      useRootNavigator: true,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      builder: (BuildContext context) {
                                        return PointChargeModal();
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: const BoxDecoration(
                                      color: Color(0xff777777),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.arrow_forward,
                                          size: 15, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  myPageItem(
                      'アカウント', 'my-page-account.svg', const AccountPage()),
                  // myPageItem('プロフィール', 'my-page-profile.svg', const ProfilePage()),
                  myPageItem(
                      '参加ROOM', 'my-page-room.svg', const JoinRoomPage()),
                  const SizedBox(height: 20),
                  myPageItem('ポイント利用履歴', 'my-page-point-history.svg',
                      const PointHistoryPage()),
                  const SizedBox(height: 20),
                  myPageItem('通知設定', 'my-page-notification.svg',
                      const NotificationSettingPage()),
                  myPageItem('文字サイズ', 'my-page-font-size.svg',
                      const FontSizeSettingPage()),
                  const SizedBox(height: 20),
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.black12,
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.zero),
                      onPressed: () {
                        goLogOut();
                      },
                      child: Container(
                        width: width,
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.1, color: Color(0xff4F5660)))),
                          child: const Text(
                            'ログアウト',
                            style: TextStyle(
                                fontFamily: 'M_PLUS',
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Color(0xffFF0000)),
                          ),
                        ),
                      )),
                  const SizedBox(height: 20),
                ],
              );
            }));
  }

  Widget myPageItem(String text, String fileName, Widget page) {
    double width = MediaQuery.of(context).size.width;
    return TextButton(
        style: TextButton.styleFrom(
            foregroundColor: Colors.black12,
            backgroundColor: Colors.white,
            padding: EdgeInsets.zero),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.1, color: Color(0xff4F5660)))),
            child: Row(children: [
              SvgPicture.asset('assets/images/$fileName'),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                    fontFamily: 'M_PLUS',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
              const Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.navigate_next,
                    color: Colors.black,
                  ),
                ),
              )
            ]),
          ),
        ));
  }

  // Widget coinCardItem(int price, int dCoinPrice, int index, selectIndex) {
  //   double width = MediaQuery.of(context).size.width;

  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: 10),
  //     child: (ElevatedButton(
  //         onPressed: () {
  //           selectIndex(index);
  //         },
  //         style: ElevatedButton.styleFrom(
  //           padding: EdgeInsets.symmetric(horizontal: width * 0.04),
  //           backgroundColor: Colors.white,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(3),
  //             side: selectedIndex == index
  //                 ? BorderSide(color: Color(0xff4D7CFF), width: 2)
  //                 : BorderSide(color: Colors.black, width: 0.3),
  //           ),
  //         ),
  //         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
  //           Row(
  //             children: [
  //               SizedBox(
  //                   height: 25,
  //                   width: 25,
  //                   child: Image.asset('assets/images/coin-icon.png',
  //                       fit: BoxFit.cover)),
  //               const SizedBox(width: 5),
  //               Text(
  //                 dCoinPrice.toString(),
  //                 style: TextStyle(
  //                     fontFamily: 'M_PLUS',
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                     color: Color(0xff777777)),
  //               ),
  //             ],
  //           ),
  //           Text(
  //             '¥$price',
  //             style: TextStyle(
  //                 fontFamily: 'M_PLUS',
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xffB4BABF)),
  //           ),
  //         ]))),
  //   );
  // }

  Future<void> goLogOut() async {
    try {
      await StreamChat.of(context).client.disconnectUser();
      await Amplify.Auth.signOut();
      AuthenticateProviderPage.of(context, listen: false).isAuthenticated =
          false;
      HomePage.index = TabItem.home;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SelPage()));
    } on AuthException catch (e) {
      print(e.message);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "サインアウト エラーです。もう一度お試しください。");
    }
  }
}
