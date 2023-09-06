// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/home/room_info_modal.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({super.key});

  @override
  _JoinRoomPage createState() => _JoinRoomPage();
}

class _JoinRoomPage extends State<JoinRoomPage> {
  List rooms = [];

  @override
  void initState() {
    final roomSigned = AppProviderPage.of(context).roomSigned;
    final List totalRooms = AppProviderPage.of(context).rooms;

    setState(() {
      List temp = [];
      for (int i = 0; i < totalRooms.length; i++) {
        if (roomSigned[i]['status']) {
          temp.add(totalRooms[i]);
        }
      }

      rooms = temp;
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        appBar: AppBar(
            elevation: 0,
            leading: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            title: const Text('参加ROOM',
                style: TextStyle(
                    fontFamily: 'M_PLUS',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        body: rooms.isNotEmpty
            ? ListView.builder(
                itemCount: rooms.length,
                itemBuilder: ((BuildContext context, int index) {
                  return _roomItem(rooms, index);
                }))
            : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    SvgPicture.asset(
                      'assets/images/empty-room.svg',
                      fit: BoxFit.contain,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.only(left: 65, right: 65),
                        child: const Text(
                            '現在参加中のROOMがありません。ROOM検索画面より参加するROOMをお選びください',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xffcbcbcb),
                                fontFamily: 'M_PLUS',
                                fontSize: 15,
                                fontWeight: FontWeight.w500)))
                  ])));
  }

  Widget _roomItem(List rooms, int index) {
    final formatter = NumberFormat.compact();
    final roomName = rooms[index]['channel']['name'] ?? '';
    final int doctorCount = rooms[index]['members'] != null
        ? rooms[index]['members']
            .where((e) => (e['user'] != null)
                ? e['user']['role'] == "doctor"
                : "null" == "doctor")
            .length
        : 0;
    final int userCount = rooms[index]['members'] != null
        ? rooms[index]['members']
            .where((e) => (e['user'] != null && e['user']['role'] == "user"))
            .length
        : 0;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                builder: ((context) {
                  return RoomInfoModal(
                      room: rooms[index], hasJoinButton: true, index: index);
                }));
          },
          style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              primary: Colors.white,
              backgroundColor: Colors.white),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: width * 0.03),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                          margin: const EdgeInsets.all(3),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(13)),
                          child: Text(
                            roomName[0],
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                                color: Colors.white),
                          )),
                    ),
                  )),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        roomName,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'M_PLUS',
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/doctor-icon.svg',
                            fit: BoxFit.cover,
                          ),
                          Container(
                              padding:
                                  const EdgeInsets.only(left: 8, right: 20),
                              child: Text(
                                '${formatter.format(doctorCount)}人',
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
                                '${formatter.format(userCount)}人',
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
                ),
              ),
              Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () {
                      showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoActionSheet(
                              message: const Text(
                                'このROOMを本当に退会しますか？',
                                style: TextStyle(fontSize: 15),
                              ),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    leftRoom(rooms[index]['channel']['id']);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('退会する'),
                                )
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text("キャンセル"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          });
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    child: const Center(
                        child: Text('…',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'M_PLUS',
                                fontSize: 20))),
                  ))
            ],
          )),
    );
  }

  void leftRoom(String roomId) async {
    final client = StreamChat.of(context).client;
    final userId = StreamChat.of(context).currentUser!.id;
    final channel = client.channel('room', id: roomId);
    try {
      await channel.watch();
      await channel.removeMembers([userId]);

      // Left from subchannels
      final subChannels = await client
          .queryChannels(filter: Filter.equal('room', roomId))
          .first;
      for (int i = 0; i < subChannels.length; i++) {
        await subChannels[i].removeMembers([userId]);
      }

      List totalRooms = AppProviderPage.of(context, listen: false).rooms;
      int roomIndex =
          totalRooms.indexWhere((e) => e['channel']['id'] == roomId);
      AppProviderPage.of(context).roomSigned[roomIndex]['status'] = false;

      setState(() {
        rooms = rooms.where((e) => e['channel']['id'] != roomId).toList();
      });
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }
}
