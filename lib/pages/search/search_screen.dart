// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/home/home_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  List rooms = [];
  List searchOptions = ['付近', '大腸/胃腸系', '消化器系', '症状が激しい', '都内'];

  @override
  void initState() {
    setState(() {
      rooms = AppProviderPage.of(context, listen: false).rooms;
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: rooms.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: height * 0.11,
                    width: width,
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/images/room-search-header.png',
                              ),
                              fit: BoxFit.cover)),
                      child: SafeArea(
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                              'assets/images/room-search-doceo-logo.png',
                              width: width * 0.3),
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 55,
                  //   padding: const EdgeInsets.symmetric(vertical: 10),
                  //   child: ListView(
                  //       scrollDirection: Axis.horizontal,
                  //       children: List.generate(
                  //         searchOptions.length,
                  //         (index) => optionButton(searchOptions[index], index),
                  //       )),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 25, horizontal: width * 0.04),
                    child: const Text(
                        '各ROOMに所属する医師は高度医療機関でROOMタイトルを専門に臨床・研究を行っている医師のみです',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff4F5660),
                            fontFamily: 'M_PLUS',
                            fontSize: 15,
                            fontWeight: FontWeight.normal)),
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 0),
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 0.6,
                    children: List.generate(
                      rooms.length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                            child: RoomCard(room: rooms[index], index: index)),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.12,
                  width: width,
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/images/room-search-header.png',
                            ),
                            fit: BoxFit.cover)),
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                            'assets/images/room-search-doceo-logo.png',
                            width: width * 0.3),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        searchOptions.length,
                        (index) => optionButton(searchOptions[index], index),
                      )),
                ),
                Expanded(
                    child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                      SvgPicture.asset(
                        'assets/images/empty-search.svg',
                        fit: BoxFit.contain,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.only(left: 65, right: 65),
                          child: const Text('現在公開しているROOMがありません',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xffcbcbcb),
                                  fontFamily: 'M_PLUS',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)))
                    ])))
              ],
            ),
    );
  }

  Widget optionButton(String text, int index) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: index == 0 ? width * 0.04 : width * 0.02),
      child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: Color(0xFFB4BABF),
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19.5),
            ),
          ),
          child: index == 0
              ? SvgPicture.asset('assets/images/room-search-option.svg')
              : Text(text,
                  style: const TextStyle(
                      color: Color(0xffB4BABF),
                      fontFamily: 'M_PLUS',
                      fontSize: 15,
                      fontWeight: FontWeight.normal))),
    );
  }
}

class RoomCard extends StatefulWidget {
  final Map<String, dynamic> room;
  final int index;

  RoomCard({super.key, required this.room, required this.index});

  @override
  State<RoomCard> createState() => _RoomCard();
}

class _RoomCard extends State<RoomCard> {
  final formatter = NumberFormat.compact();
  List roomSigned = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      roomSigned = AppProviderPage.of(context).roomSigned;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final roomName = widget.room['channel']['name'] ?? '';
    final int doctorCount = widget.room['members'] != null
        ? widget.room['members']
            .where((e) => (e['user'] != null)
                ? e['user']['role'] == "doctor"
                : "null" == "doctor")
            .length
        : 0;
    final int userCount = widget.room['members'] != null
        ? widget.room['members']
            .where((e) => (e['user'] != null && e['user']['role'] == "user"))
            .length
        : 0;
    final String description = widget.room['channel']['description'] ?? '';

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(width: 0.3, color: const Color(0xffB4BABF))),
        child: Column(children: [
          Expanded(
              flex: 1,
              child: Stack(children: [
                FractionallySizedBox(
                    heightFactor: 18 / 23,
                    widthFactor: 1.0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                      child: widget.room['channel']['image'] != null
                          ? Image.network(widget.room['channel']['image'],
                              fit: BoxFit.cover)
                          : Image.asset(
                              'assets/images/room-header-1.png',
                              fit: BoxFit.cover,
                            ),
                    )),
                Column(children: [
                  Expanded(flex: 13, child: Container()),
                  Expanded(
                    flex: 10,
                    child: Container(
                      padding: EdgeInsets.only(left: width * 0.02),
                      alignment: Alignment.centerLeft,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6)),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                roomName[0] ?? '',
                                style: const TextStyle(
                                    fontFamily: 'M_PLUS',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )),
                      ),
                    ),
                  )
                ])
              ])),
          Expanded(
              flex: 3,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            roomName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: 'M_PLUS',
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(description,
                              maxLines: 7,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12)),
                        ),
                        Expanded(
                            flex: 1,
                            child: Row(children: [
                              SvgPicture.asset('assets/images/doctor-icon.svg',
                                  fit: BoxFit.contain, height: 13, width: 13),
                              Container(
                                  margin: EdgeInsets.only(
                                    left: width * 0.01,
                                    right: width * 0.03,
                                  ),
                                  child: Text(
                                    '${formatter.format(doctorCount)}人',
                                    style: const TextStyle(
                                        color: Color(0xffB4BABF),
                                        fontFamily: 'M_PLUS',
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal),
                                  )),
                              SvgPicture.asset('assets/images/user-icon.svg',
                                  fit: BoxFit.contain, height: 13, width: 13),
                              Container(
                                  margin: EdgeInsets.only(
                                    left: width * 0.01,
                                  ),
                                  child: Text(
                                    '${formatter.format(userCount)}人',
                                    style: const TextStyle(
                                        color: Color(0xffB4BABF),
                                        fontFamily: 'M_PLUS',
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal),
                                  ))
                            ])),
                        Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (!roomSigned[widget.index]['status']) {
                                      joinRoom(context, widget.index);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: roomSigned[widget.index]
                                              ['status']
                                          ? Color(0xffD1DAE2)
                                          : Color(0xff69E4BF),
                                      elevation: roomSigned[widget.index]
                                              ['status']
                                          ? 0
                                          : 5,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  child: roomSigned[widget.index]['status']
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: 40,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: SvgPicture.asset(
                                              'assets/images/cloud-icon.svg',
                                              fit: BoxFit.contain),
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: 40,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            '参加する',
                                            style: TextStyle(
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                                color: Colors.white),
                                          ),
                                        )),
                            ))
                      ]))),
        ]));
  }

  Future<void> joinRoom(context, index) async {
    final client = StreamChat.of(context).client;
    final currentUser = StreamChat.of(context).currentUser!;
    String userId = currentUser!.id;

    try {
      final channel = client.channel('room', id: widget.room['channel']['id']);
      await channel.watch();
      await channel.addMembers([userId]);

      // Join to subchannels
      final subChannels = await client
          .queryChannels(
              filter: Filter.equal('room', widget.room['channel']['id']))
          .first;
      for (int i = 0; i < subChannels.length; i++) {
        await subChannels[i].addMembers([userId]);
        if (((subChannels[i].type == 'channel-2' ||
                    subChannels[i].type == 'channel-3') &&
                currentUser.extraData['disable_other_notification']
                        .toString() ==
                    'yes') ||
            (subChannels[i].type == 'channel-1' &&
                currentUser.extraData['disable_room_notification'].toString() ==
                    'yes')) {
          await subChannels[i].mute();
        }
      }

      setState(() {
        roomSigned[index]['status'] = true;
      });
      AppProviderPage.of(context).roomSigned = roomSigned;
      AppProviderPage.of(context).selectedRoom = widget.room['channel']['id'];
      HomePage.index = TabItem.home;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }
}
