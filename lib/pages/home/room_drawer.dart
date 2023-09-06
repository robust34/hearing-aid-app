import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/home/home_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:intl/intl.dart';

class RoomDrawer extends StatefulWidget {
  const RoomDrawer({super.key});

  @override
  State<RoomDrawer> createState() => _RoomDrawerState();
}

class _RoomDrawerState extends State<RoomDrawer> {
  // final Map<String, dynamic> room;
  List<Map<String, dynamic>> rooms = [];
  String selectedRoomId = '';
  Map unreadRooms = {};
  late StreamSubscription getUnreadChannels;

  @override
  void initState() {
    // TODO: implement initState
    print('**************checkingssssss***********');
    setDrawer();
    getUnreadChannels = StreamChat.of(context).client.queryChannels(
        channelStateSort: [const SortOption('has_unread')],
        watch: false,
        paginationParams: PaginationParams(
            limit: StreamChat.of(context).client.state.unreadChannels)).listen(
        (data) {
      final temp = {};
      for (final channel in data) {
        if (StreamChat.of(context)
                .client
                .state
                .channels[channel.cid]!
                .state!
                .unreadCount >
            0) {
          temp[channel.extraData['room']] = true;
        }
      }
      setState(() {
        unreadRooms = temp;
      });
    });

    super.initState();
  }

  // ignore: non_constant_identifier_names
  void setDrawer() async {
    final List totalRooms = AppProviderPage.of(context).rooms;
    final List roomSigned = AppProviderPage.of(context).roomSigned;
    List<Map<String, dynamic>> _rooms = [];

    for (int i = 0; i < totalRooms.length; i++) {
      if (roomSigned[i]['status']) {
        final room = totalRooms[i];

        _rooms.add({
          "id": room['channel']['id'],
          "name": room['channel']['name'],
          "iconColor": 0xff70A4F2,
          "users": (room['members'] != null)
              ? room['members']
                  .where(
                      (e) => (e['user'] != null && e['user']['role'] == "user"))
                  .length
              : 0,
          "doctors": (room['members'] != null)
              ? room['members']
                  .where((e) =>
                      (e['user'] != null && e['user']['role'] == "doctor"))
                  .length
              : 0,
        });
      }
    }

    setState(() {
      final selectedRoom = _rooms.indexWhere((element) =>
          element['id'] ==
          AppProviderPage.of(context, listen: false).selectedRoom);
      rooms.add(_rooms[selectedRoom]);
      rooms.addAll(_rooms.where((element) =>
          element['id'] !=
          AppProviderPage.of(context, listen: false).selectedRoom));
      selectedRoomId = AppProviderPage.of(context, listen: false).selectedRoom;
    });
  }

  final formatter = NumberFormat.compact();

  @override
  void dispose() {
    getUnreadChannels.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SingleChildScrollView(
          child: Container(
        alignment: Alignment.center,
        child: Stack(children: [
          Opacity(
            opacity: 0.4,
            child: Image.asset(
              height: MediaQuery.of(context).size.height,
              'assets/images/room-f_2.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                    alignment: Alignment.bottomLeft,
                    padding:
                        const EdgeInsets.only(left: 15, bottom: 10, top: 5),
                    child: const Text(
                      'D-ROOM',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'M_PLUS',
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    )),
                ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: rooms.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return _roomItem(rooms, index, unreadRooms);
                    }),
              ],
            ),
          ),
        ]),
      )),
      onWillPop: () => Future.value(false),
    );
  }

  Widget _roomItem(
      List<Map<String, dynamic>> rooms, int index, Map unreadRooms) {
    final width = MediaQuery.of(context).size.width;
    bool unread = false;
    final String roomId = rooms[index]['id'];
    final unreadMessages =
        AppProviderPage.of(context, listen: true).unreadMessages;

    if (unreadMessages[roomId] != null && unreadMessages[roomId].isNotEmpty ||
        unreadRooms.containsKey(roomId)) {
      unread = true;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
          onPressed: () {
            goHomePage(index);
          },
          style: ElevatedButton.styleFrom(
              elevation: selectedRoomId != rooms[index]['id'] ? 0 : 5,
              padding: const EdgeInsets.symmetric(vertical: 11),
              primary: Colors.white),
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.025, right: width * 0.01),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Stack(clipBehavior: Clip.none, children: [
                        Container(
                            margin: const EdgeInsets.all(3),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color(rooms[index]['iconColor']),
                                borderRadius: BorderRadius.circular(13)),
                            child: TextButton(
                                onPressed: () {
                                  goHomePage(index);
                                },
                                child: Text(
                                  rooms[index]['name'][0],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.white),
                                ))),
                        if (unread)
                          Positioned(
                              right: 0,
                              child: Container(
                                width: 17,
                                height: 17,
                                decoration: BoxDecoration(
                                    color: const Color(0xffFE3D2F),
                                    borderRadius: BorderRadius.circular(17)),
                              ))
                      ]),
                    ),
                  )),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rooms[index]['name'],
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
                            padding: const EdgeInsets.only(left: 8, right: 20),
                            child: Text(
                              '${formatter.format(rooms[index]['doctors'])}人',
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
                              '${formatter.format(rooms[index]['users'])}人',
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
              selectedRoomId != rooms[index]['id']
                  ? Visibility(
                      child: Expanded(
                          flex: 2,
                          child: TextButton(
                            onPressed: () {
                              showCupertinoModalPopup<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoActionSheet(
                                      actions: <Widget>[
                                        CupertinoActionSheetAction(
                                          isDestructiveAction: true,
                                          onPressed: () {
                                            leftRoom(rooms[index]['id']);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('ROOMを退出する',
                                              style: TextStyle(
                                                  color: Color(0xffFF0000),
                                                  fontFamily: 'M_PLUS',
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        )
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        child: const Text("キャンセル",
                                            style: TextStyle(
                                                color: Color(0xff225FFC),
                                                fontFamily: 'M_PLUS',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  });
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.white),
                            child: const Center(
                                child: Text('…',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'M_PLUS',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20))),
                          )),
                      visible: selectedRoomId != rooms[index]['id'],
                    )
                  : Expanded(child: Container(), flex: 2)
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
        rooms = rooms.where((e) => e['id'] != roomId).toList();
      });
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }

  void goHomePage(int index) async {
    String roomNumber = rooms[index]["id"].toString();
    AppProviderPage.of(context, listen: false).selectedRoom = roomNumber;
    final state = StreamChat.of(context).client.state;
    final currentState = {...state.channels};

    try {
      for (final cid in currentState.keys) {
        if (currentState[cid]!.extraData['room'].toString() != roomNumber) {
          state.removeChannel(cid);
        }
      }
    } catch (e) {
      print('Error${e}');
    }

    // Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
