import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/home/loading_animation.dart';
import 'package:doceo_new/pages/home/room_info_modal.dart';
import 'package:doceo_new/pages/initialUserSetting/select_icon_page.dart';
import 'package:doceo_new/pages/transitionToHome/transition.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SelectRoomPage extends StatefulWidget {
  const SelectRoomPage({
    super.key,
  });

  @override
  State<SelectRoomPage> createState() => _SelectRoomPageState();
}

class _SelectRoomPageState extends State<SelectRoomPage> {
  List rooms = [];
  int doctorNum = 0;
  List roomSigned = [];
  int selectdRoom = 0;
  List<dynamic> joinStatus = [];

  @override
  void initState() {
    // TODO: implement initState
    // print(StreamChat.of(context).currentUser!.id);
    // checkingFun();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        rooms = AppProviderPage.of(context, listen: false).rooms;
        checkSigned(rooms);
      });
    });

    // doctorNum = rooms
    //     .where((e) => e['members'].where((v) => v['user']['role'] == "doctor"))
    //     .length;
    super.initState();
  }

  void checkSigned(List Value) {
    if (Value.isNotEmpty) {
      joinStatus = List.filled(Value.length, false);
    } else {
      joinStatus = [];
    }
    int userNum = 0;
    String userId = StreamChat.of(context).currentUser!.id;
    for (var item in Value) {
      userNum = item['members'].where((e) => e['user_id'] == userId).length;
      if (userNum > 0) {
        roomSigned.add({'status': true});
      } else {
        roomSigned.add({'status': false});
      }
      userNum = 0;
    }
    AppProviderPage.of(context, listen: false).roomSigned = roomSigned;
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  Widget _roomItem(context, index) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
        // height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(13)),
        child: InkWell(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
                height: MediaQuery.of(context).size.width * 0.14,
                width: MediaQuery.of(context).size.width * 0.14,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(13)),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useRootNavigator: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        builder: ((context) {
                          return RoomInfoModal(
                              room: rooms[index],
                              hasJoinButton: true,
                              index: index);
                        }));
                  },
                  child: Text(
                    (rooms[index]['channel'] != null)
                        ? rooms[index]['channel']['name'][0]
                        : '',
                    style: const TextStyle(
                        fontFamily: 'M_PLUS',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontStyle: FontStyle.normal,
                        color: Colors.white),
                  ),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.bottomLeft,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      (rooms[index]['channel'] != null)
                          ? rooms[index]['channel']['name']
                          : '',
                      style: const TextStyle(
                          fontFamily: 'M_PLUS',
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          fontStyle: FontStyle.normal),
                    )),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/doctor-icon.svg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 8, right: 20),
                        child: Text(
                          // '${rooms[index]['doctors']}人',
                          (rooms[index]['members'] != null)
                              ? "${rooms[index]['members'].where((e) => (e['user'] != null) ? e['user']['role'] == "doctor" : "null" == "doctor").length}人"
                              : "0人",
                          style: const TextStyle(
                              color: Color(0xffB4BABF),
                              fontFamily: 'M_PLUS',
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                              fontStyle: FontStyle.normal),
                        )),
                    SvgPicture.asset(
                      'assets/images/user-icon.svg',
                      fit: BoxFit.cover,
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          // '${rooms[index]['users']}人',
                          (rooms[index]['members'] != null)
                              ? "${rooms[index]['members'].where((e) => (e['user'] != null && e['user']['role'] == 'user')).length}人"
                              : "0人",
                          style: const TextStyle(
                              color: Color(0xffB4BABF),
                              fontFamily: 'M_PLUS',
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                              fontStyle: FontStyle.normal),
                        )),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 90,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  // setState(() {
                  //   selectdRoom = index;
                  // });
                  // if (!joinStatus[index]) {
                  joinOrLeave(index);
                  // }
                  // goSelectedRoom();
                },
                style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.transparent,
                    // foregroundColor: Colors.white,

                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                // child: rooms[index]['isJoined']
                child: joinStatus[index]
                    ? Ink(
                        decoration: BoxDecoration(
                            color: const Color(0xff69E4BF),
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.23,
                          height: 40,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 1),
                        ),
                      )
                    : (roomSigned[index]['status']
                        ? Ink(
                            decoration: BoxDecoration(
                                color: const Color(0xffD1DAE2),
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: 40,
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                  'assets/images/cloud-icon.svg',
                                  fit: BoxFit.cover),
                            ),
                          )
                        : Ink(
                            decoration: BoxDecoration(
                                color: const Color(0xff69E4BF),
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.23,
                              height: 40,
                              alignment: Alignment.center,
                              child: const Text(
                                '参加する',
                                style: TextStyle(
                                    fontFamily: 'M_PLUS',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white),
                              ),
                            ),
                          )),
              ),
            )
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () async {
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
          // body: RefreshIndicator(
          //   onRefresh: _controller.refresh,
          //   child: StreamChannelListView(
          //     controller: _controller,
          //     onChannelTap: (channel) => Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => SelectIconPage(),
          //       ),
          //     ),
          //   ),
          // ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: const Text(
                          '参加するROOMを選択',
                          style: TextStyle(
                              fontFamily: 'M_PLUS',
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: const Text(
                          'あなたの悩みに合わせて複数選択することが可能です',
                          style: TextStyle(
                              fontFamily: 'M_PLUS',
                              fontWeight: FontWeight.normal,
                              color: Color(0xffB4BABF),
                              fontSize: 13),
                        ),
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.61,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02),
                          alignment: Alignment.center,
                          child: rooms.isEmpty
                              ? LoadingAnimation()
                              : ListView.builder(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: rooms.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _roomItem(context, index);
                                  },
                                )),
                    ],
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.77),
                    child: ElevatedButton(
                      onPressed: () {
                        goSelectedRoom();
                        // context.go('/transitionToHome');
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => SelectIconPage()));
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
                          child: const Text(
                            'HOMEへ',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () => Future.value(false));
  }

  Future<void> joinOrLeave(index) async {
    final client = StreamChat.of(context).client;
    final currentUser = StreamChat.of(context).currentUser!;
    String userId = currentUser.id;

    setState(() {
      // roomSigned[index]['status'] = true;
      joinStatus[index] = true;
    });

    try {
      final channel = client.channel('room', id: rooms[index]['channel']['id']);
      if (roomSigned[index]['status']) {
        await channel.watch();
        await channel.removeMembers([userId]);

        // Left from subchannels
        final subChannels = await client
            .queryChannels(
                filter: Filter.equal('room', rooms[index]['channel']['id']))
            .first;
        for (int i = 0; i < subChannels.length; i++) {
          await subChannels[i].removeMembers([userId]);
        }
      } else {
        await channel.watch();
        await channel.addMembers([userId]);

        // Join to subchannels
        final subChannels = await client
            .queryChannels(
                filter: Filter.equal('room', rooms[index]['channel']['id']))
            .first;
        for (int i = 0; i < subChannels.length; i++) {
          await subChannels[i].addMembers([userId]);
          if (((subChannels[i].type == 'channel-2' ||
                      subChannels[i].type == 'channel-3') &&
                  currentUser.extraData['disable_other_notification']
                          .toString() ==
                      'yes') ||
              (subChannels[i].type == 'channel-1' &&
                  currentUser.extraData['disable_room_notification']
                          .toString() ==
                      'yes')) {
            await subChannels[i].mute();
          }
        }
      }

      setState(() {
        joinStatus[index] = false;
        roomSigned[index]['status'] = !roomSigned[index]['status'];
      });
    } catch (e) {
      safePrint(e);
      setState(() {
        joinStatus[index] = false;
      });
    }
  }

  void goSelectedRoom() async {
    if (roomSigned.where((e) => e['status']).length == 0) {
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastSuccess("1つ以上のROOMに参加してください", context);
      return;
    }
    int index = roomSigned.indexWhere((e) => e['status']);
    String roomNumber = rooms[index]["channel"]["id"].toString();
    AppProviderPage.of(context, listen: false).selectedRoom = roomNumber;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const TransitionPage()));
  }
}
