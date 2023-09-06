import 'package:doceo_new/pages/home/home_page.dart';
import 'package:doceo_new/pages/home/room_option_modal.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class RoomInfoModal extends StatefulWidget {
  final Map<String, dynamic> room;
  final bool? hasJoinButton;
  final int? index;
  const RoomInfoModal(
      {super.key, required this.room, this.hasJoinButton, this.index});
  @override
  State<RoomInfoModal> createState() => _RoomInfoModal();
}

class _RoomInfoModal extends State<RoomInfoModal> {
  bool _isFullModal = false;
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 1);
  bool roomSigned = false;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset <=
          _scrollController.position.minScrollExtent) {
        Navigator.pop(context);
      }
    });
    if (widget.index != null)
      roomSigned = AppProviderPage.of(context, listen: false)
          .roomSigned[widget.index]['status'];
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (!_isFullModal && details.delta.dy < 5) {
          setState(() {
            _isFullModal = true;
          });
        } else if (!_isFullModal &&
            details.delta.dy > 0 &&
            _scrollController.position.pixels <= 0) {
          setState(() {
            _isFullModal = false;
          });
          Navigator.pop(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Stack(
          children: [
            AnimatedContainer(
              height: _isFullModal ? height * 0.8 : height * 0.512,
              duration: const Duration(milliseconds: 300),
              child: SingleChildScrollView(
                controller: _isFullModal ? _scrollController : null,
                physics: _isFullModal
                    ? const ClampingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                child: Stack(children: [
                  Column(children: [
                    ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        child: widget.room['channel']['image'] != null
                            ? Image.network(widget.room['channel']['image'],
                                width: width,
                                height: height * 0.145,
                                fit: BoxFit.cover)
                            : Image.asset(
                                'assets/images/main-header.png',
                                width: width,
                                height: height * 0.145,
                                fit: BoxFit.cover,
                              )),
                    Container(
                        height: _isFullModal ? height : height * 0.362,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: width * 0.08, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.05),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.room['channel']['name'],
                                style: const TextStyle(
                                    fontFamily: 'M_PLUS',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                    top: 5,
                                    right: width * 0.05,
                                    left: width * 0.05),
                                child: Text(
                                    widget.room['channel']['description'],
                                    maxLines: _isFullModal ? 100 : 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15)),
                              ),
                            ),
                          ],
                        )),
                  ]),
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.145 - height * 0.08 / 2,
                        left: width * 0.04),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13)),
                    height: height * 0.08,
                    width: height * 0.08,
                    padding: EdgeInsets.all(width * 0.01),
                    child: Container(
                        height: height * 0.07,
                        width: height * 0.07,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(13)),
                        child: Text(
                          widget.room['channel']['name'][0],
                          style: const TextStyle(
                              fontSize: 24,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(bottom: height * 0.03),
                  ),
                ]),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: width,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      width: width,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 0),
                      padding: EdgeInsets.only(
                          right: width * 0.05, left: width * 0.05, bottom: 15),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/doctor-icon.svg',
                            fit: BoxFit.contain,
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              left: 8,
                              right: 20,
                            ),
                            child: Text(
                              (widget.room['members'] != null)
                                  ? "${widget.room['members'].where((e) => (e['user'] != null) ? e['user']['role'] == "doctor" : "null" == "doctor").length}人"
                                  : "0人",
                              style: const TextStyle(
                                  color: Color(0xffB4BABF),
                                  fontFamily: 'M_PLUS',
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/images/user-icon.svg',
                            fit: BoxFit.contain,
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: Text(
                                (widget.room['members'] != null)
                                    ? "${widget.room['members'].where((e) => (e['user'] != null && e['user']['role'] == 'user')).length}人"
                                    : "0人",
                                style: const TextStyle(
                                    color: Color(0xffB4BABF),
                                    fontFamily: 'M_PLUS',
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal),
                              )),
                        ],
                      ),
                    ),
                    if (widget.hasJoinButton == null ||
                        widget.hasJoinButton == false)
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff4F5660),
                            width: 0.1,
                          ),
                        ),
                      ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: widget.hasJoinButton != null &&
                              widget.hasJoinButton == true
                          ? Container(
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height *
                                      0.03),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (!AppProviderPage.of(context,
                                            listen: false)
                                        .roomSigned[widget.index]['status']) {
                                      joinRoom(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  // child: room['isJoined']
                                  child: roomSigned
                                      ? Ink(
                                          decoration: BoxDecoration(
                                              color: const Color(0xffD1DAE2),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
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
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: 40,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'ROOMに参加する',
                                              style: TextStyle(
                                                  fontFamily: 'M_PLUS',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                            )
                          : Container(
                              alignment: Alignment.center,
                              height: height * 0.1,
                              width: width,
                              child: Row(children: [
                                Expanded(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        showModalBottomSheet(
                                            context: context,
                                            useSafeArea: true,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            builder: ((context) {
                                              return RoomOptionsModal(
                                                  room: widget.room,
                                                  isRequest: true);
                                            }));
                                      },
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/images/room-request.svg',
                                              fit: BoxFit.cover),
                                          const Text('リクエスト',
                                              style: TextStyle(
                                                  color: Color(0xff999999),
                                                  fontFamily: 'M_PLUS',
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                            builder: ((context) {
                                              return RoomOptionsModal(
                                                  room: widget.room,
                                                  isRequest: false);
                                            }));
                                      },
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/images/room-invitation.svg',
                                              fit: BoxFit.cover),
                                          const Text('招待',
                                              style: TextStyle(
                                                  color: Color(0xffebebeb),
                                                  fontFamily: 'M_PLUS',
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
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
                                                      leftRoom();
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                        'ROOMを退出する',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFF0000),
                                                            fontFamily:
                                                                'M_PLUS',
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal)),
                                                  )
                                                ],
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: const Text("キャンセル",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff225FFC),
                                                          fontFamily: 'M_PLUS',
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              );
                                            });
                                      },
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/images/room-exit.svg',
                                              fit: BoxFit.cover),
                                          const Text('退出',
                                              style: TextStyle(
                                                  color: Color(0xff999999),
                                                  fontFamily: 'M_PLUS',
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ],
                                      ),
                                    ))
                              ]),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> joinRoom(context) async {
    final client = StreamChat.of(context).client;
    final currentUser = StreamChat.of(context).currentUser!;
    String userId = currentUser.id;

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

      AppProviderPage.of(context).roomSigned[widget.index]['status'] = true;
      setState(() {
        roomSigned = true;
      });
    } catch (e) {
      print(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }

  void leftRoom() async {
    final client = StreamChat.of(context).client;
    final userId = StreamChat.of(context).currentUser!.id;
    final channel = client.channel('room', id: widget.room['channel']['id']);
    try {
      await channel.watch();
      await channel.removeMembers([userId]);

      // Left from subchannels
      final subChannels = await client
          .queryChannels(
              filter: Filter.equal('room', widget.room['channel']['id']))
          .first;
      for (int i = 0; i < subChannels.length; i++) {
        await subChannels[i].removeMembers([userId]);
      }

      List rooms = AppProviderPage.of(context, listen: false).rooms;
      int index = rooms.indexWhere(
          (e) => e['channel']['id'] == widget.room['channel']['id']);
      List roomSigned = AppProviderPage.of(context, listen: false).roomSigned;
      roomSigned[index]['status'] = false;
      int otherRoom = roomSigned.indexWhere((e) => e['status']);
      AppProviderPage.of(context, listen: false).selectedRoom =
          otherRoom > -1 ? rooms[otherRoom]['channel']['id'] : '';
      AppProviderPage.of(context, listen: false).roomSigned = roomSigned;

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。もう一度お試しください。");
    }
  }
}
