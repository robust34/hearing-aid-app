// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  _NotificationSettingPage createState() => _NotificationSettingPage();
}

class _NotificationSettingPage extends State<NotificationSettingPage> {
  late int myRooms;

  void _loadData() async {
    var roomSigned = AppProviderPage.of(context, listen: false).roomSigned;
    int count = 0;

    for (int i = 0; i < roomSigned.length; i++) {
      if (roomSigned[i]['status'] == true) {
        count++;
      }
    }

    myRooms = count;
  }
  // }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final client = StreamChat.of(context).client;

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
            title: const Text('通知設定',
                style: TextStyle(
                    fontFamily: 'M_PLUS',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        body: BetterStreamBuilder(
            stream: client.state.usersStream,
            builder: (context, data) {
              return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.04, top: 30, bottom: 10),
                      child: const Text('通知管理',
                          style: TextStyle(
                              color: Color(0xffB4BABF),
                              fontFamily: 'M_PLUS',
                              fontSize: 13,
                              fontWeight: FontWeight.normal)),
                    ),
                    Container(
                      width: width,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: width * 0.04),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text('アプリ全体のお知らせ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'M_PLUS',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal)),
                          ),
                          CupertinoSwitch(
                              activeColor: const Color(0xff7369E4),
                              value: StreamChat.of(context)
                                      .currentUser!
                                      .extraData['disable_notifciation']
                                      .toString() !=
                                  'yes',
                              onChanged: (newValue) async {
                                var currentUser =
                                    StreamChat.of(context).currentUser;
                                currentUser!.extraData['disable_notifciation'] =
                                    newValue ? 'no' : 'yes';
                                StreamChat.of(context)
                                        .currentUser!
                                        .extraData['disable_notifciation'] =
                                    newValue ? 'no' : 'yes';
                                await client.updateUser(currentUser);
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.04, top: 30, bottom: 10),
                      child: const Text('ROOM設定',
                          style: TextStyle(
                              color: Color.fromARGB(255, 139, 155, 169),
                              fontFamily: 'M_PLUS',
                              fontSize: 13,
                              fontWeight: FontWeight.normal)),
                    ),
                    Container(
                      width: width,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: width * 0.04),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text('ROOM内アナウンス',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'M_PLUS',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal)),
                          ),
                          CupertinoSwitch(
                              activeColor: const Color(0xff7369E4),
                              value: StreamChat.of(context)
                                      .currentUser!
                                      .extraData['disable_room_notification']
                                      .toString() !=
                                  'yes',
                              onChanged: (newValue) {
                                toggleRoomNotification(newValue);
                              }),
                        ],
                      ),
                    ),
                    Container(
                      width: width,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: width * 0.04),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text('他の人が投稿した質問・コメント',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'M_PLUS',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal)),
                          ),
                          CupertinoSwitch(
                              activeColor: const Color(0xff7369E4),
                              value: StreamChat.of(context)
                                      .currentUser!
                                      .extraData['disable_other_notification']
                                      .toString() !=
                                  'yes',
                              onChanged: (newValue) {
                                StreamChat.of(context).currentUser!.extraData[
                                        'disable_other_notification'] =
                                    newValue ? 'no' : 'yes';
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.04, top: 30, bottom: 10),
                      child: const Text('デフォルト（変更不可）',
                          style: TextStyle(
                              color: Color.fromARGB(255, 139, 155, 169),
                              fontFamily: 'M_PLUS',
                              fontSize: 13,
                              fontWeight: FontWeight.normal)),
                    ),
                    Container(
                      width: width,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 15, horizontal: width * 0.04),
                      child: const Text('自分が投稿した質問・コメントへの返信',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'M_PLUS',
                              fontSize: 15,
                              fontWeight: FontWeight.normal)),
                    ),
                  ]));
            }));
  }

  Future<void> toggleRoomNotification(bool value) async {
    try {
      final client = StreamChat.of(context).client;
      var currentUser = StreamChat.of(context).currentUser;
      currentUser!.extraData['disable_room_notification'] =
          value ? 'no' : 'yes';
      StreamChat.of(context)
          .currentUser!
          .extraData['disable_room_notification'] = value ? 'no' : 'yes';
      await client.updateUser(currentUser);
      final channels = await client
          .queryChannels(
              filter: Filter.and([
            Filter.in_('members', [currentUser.id]),
            Filter.equal('type', 'channel-1')
          ]))
          .first;
      for (final channel in channels) {
        if (value) {
          await channel.mute();
        } else {
          await channel.unmute();
        }
      }
    } catch (e) {}
  }

  Future<void> toggleOthersNotification(bool value) async {
    try {
      final client = StreamChat.of(context).client;
      var currentUser = StreamChat.of(context).currentUser;
      currentUser!.extraData['disable_other_notification'] =
          value ? 'no' : 'yes';
      StreamChat.of(context)
          .currentUser!
          .extraData['disable_other_notification'] = value ? 'no' : 'yes';
      await client.updateUser(currentUser);
      final channels = await client
          .queryChannels(
              filter: Filter.and([
            Filter.in_('members', [currentUser.id]),
            Filter.in_('type', const ['channel-2', 'channel-3'])
          ]))
          .first;
      for (final channel in channels) {
        if (value) {
          await channel.mute();
        } else {
          await channel.unmute();
        }
      }
      // client.muteUser(userId)
    } catch (e) {}
  }
}
