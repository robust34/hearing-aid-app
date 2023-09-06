// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/models/ModelProvider.dart' as Model;
import 'package:doceo_new/pages/home/room_info_modal.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  static int defaultIndex = 0;

  const NotificationScreen({super.key});

  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  late List roomNotifications = [];
  late List adminNotifications = [];
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  void getData() async {
    try {
      final request = ModelQueries.list(Model.Notification.classType);
      final response = await Amplify.API.query(request: request).response;

      final items = response.data?.items;
      if (items == null) {
        print('errors: ${response.errors}');
        setState(() {});
      } else {
        setState(() {
          roomNotifications = items.where((e) => e!.type == 'room').toList();
          adminNotifications = items.where((e) => e!.type == 'admin').toList();
        });
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
    setState(() {
      loading = false;
    });
  }

  Widget _emptyPage(BuildContext context, int index) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          SvgPicture.asset(
            'assets/images/empty-notification.svg',
            fit: BoxFit.contain,
          ),
          Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.only(left: 55, right: 55),
              child: Text(
                  index == 0
                      ? '新しいROOMが開設されるとお知らせが届きます'
                      : 'アプリの追加機能や不具合の修正などアップデートをお知らせします',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xffcbcbcb),
                      fontFamily: 'M_PLUS',
                      fontSize: 15,
                      fontWeight: FontWeight.w500)))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      initialIndex: NotificationScreen.defaultIndex,
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            '全体通知',
            style: TextStyle(
                fontFamily: 'M_PLUS',
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(25),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffEBECEE),
                borderRadius: BorderRadius.circular(5),
              ),
              height: 35,
              width: width * 0.94,
              child: TabBar(
                unselectedLabelColor: const Color(0xffB4BABF),
                labelColor: Colors.black,
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'M_PLUS',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                labelStyle: const TextStyle(
                  fontFamily: 'M_PLUS',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(2),
                tabs: const [
                  Tab(
                    text: 'ROOM',
                  ),
                  Tab(text: '運営'),
                ],
              ),
            ),
          ),
        ),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : TabBarView(
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: roomNotifications.isNotEmpty
                          ? ListView.builder(
                              itemCount: roomNotifications.length,
                              itemBuilder: (_, index) {
                                return NotificationItem(
                                  notificationItem: roomNotifications[index],
                                  isAdmin: false,
                                );
                              },
                            )
                          : _emptyPage(context, 0)),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: adminNotifications.isNotEmpty
                          ? ListView.builder(
                              itemCount: adminNotifications.length,
                              itemBuilder: (_, index) {
                                return NotificationItem(
                                  notificationItem: adminNotifications[index],
                                  isAdmin: true,
                                );
                              },
                            )
                          : _emptyPage(context, 1)),
                ],
              ),
      ),
    );
  }
}

class NotificationItem extends StatefulWidget {
  final Model.Notification notificationItem;
  final bool isAdmin;
  const NotificationItem(
      {super.key, required this.notificationItem, required this.isAdmin});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  late Map<String, dynamic> room;
  late int index = -1;

  @override
  void initState() {
    if (!widget.isAdmin) {
      getRoomData();
    }
    super.initState();
  }

  void getRoomData() {
    final List totalRooms = AppProviderPage.of(context).rooms;
    final roomIndex = totalRooms.indexWhere((element) =>
        element['channel']['id'] == widget.notificationItem.channel);
    setState(() {
      room = totalRooms[roomIndex];
      index = roomIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final dateFormatter = DateFormat('yyyy/MM/dd');

    return TextButton(
      onPressed: () {
        widget.isAdmin
            ? print(
                'Admin notification\'s transition has not been decided yet.')
            : showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                builder: ((context) {
                  return RoomInfoModal(
                      room: room, hasJoinButton: true, index: index);
                }));
      },
      child: Container(
        height: 90,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.1, color: Color(0xff4F5660)))),
        child: Row(children: [
          Expanded(
            flex: 1,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: widget.isAdmin
                  ? Image.asset('assets/images/splash_1.png')
                  : Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        room['channel']['name'][0],
                        style: const TextStyle(
                            fontFamily: 'M_PLUS',
                            fontSize: 17,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
            ),
          ),
          Expanded(
              flex: 7,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.notificationItem.text.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontFamily: 'M_PLUS',
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                    Text(
                        dateFormatter.format(
                            widget.notificationItem.createdAt != null
                                ? widget.notificationItem.createdAt!
                                    .getDateTimeInUtc()
                                : DateTime.now()),
                        style: const TextStyle(
                            fontFamily: 'M_PLUS',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Color(0xffB4BABF)))
                  ],
                ),
              ))
        ]),
      ),
    );
  }
}
