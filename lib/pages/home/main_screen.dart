// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';

import 'package:doceo_new/helper/awesome_notifications_helper.dart';
import 'package:doceo_new/helper/fcm_helper.dart';
import 'package:doceo_new/pages/channels/for_you/for_you_page.dart';
import 'package:doceo_new/pages/channels/type_1/channel_1_1_page.dart';
import 'package:doceo_new/pages/channels/type_2/channel_2_1_page.dart';
import 'package:doceo_new/pages/channels/type_3/channel_3_1_page.dart';
import 'package:doceo_new/pages/home/room_info_modal.dart';
import 'package:doceo_new/pages/initialUserSetting/select_room_page.dart';
import 'package:doceo_new/pages/home/doctor_info_modal.dart';
import 'package:doceo_new/pages/home/for_you_page.dart';
import 'package:doceo_new/pages/home/room_info_modal.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:doceo_new/styles/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:toast/toast.dart';

class MainScreen extends StatefulWidget {
  static String targetChannelType = '';
  static String targetChannel = '';
  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> with WidgetsBindingObserver {
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';
  int selectRoomNumber = 0;
  List totalRooms = [];
  String roomName = "";
  String selectedRoomId = '';
  List doctors = [];
  late final StreamSubscription subscription;
  late List<StreamChannelListController> _controllers = [];

  @override
  void initState() {
    final client = StreamChat.of(context).client;
    super.initState();
    FcmHelper.initFcm(updateToken);
    getData(AppProviderPage.of(context).selectedRoom,
        AppProviderPage.of(context).rooms);
    WidgetsBinding.instance.addObserver(this);

    // Add For you listener
    subscription = client.on().listen((Event event) async {
      if (event.type == EventType.messageNew &&
          event.message!.parentId != null) {
        final currentUser = StreamChat.of(context).currentUser;
        final parent = await client.getMessage(event.message!.parentId!);

        if (currentUser!.id == parent.message.user!.id) {
          final room = parent.channel!.extraData['room'].toString();
          final unreadMessages = AppProviderPage.of(context).unreadMessages;
          final List roomMessages = unreadMessages[room] ?? [];
          roomMessages.add(parent.message.id);
          unreadMessages[room] = roomMessages;
          AppProviderPage.of(context).unreadMessages = unreadMessages;
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      final roomNumber = AppProviderPage.of(context).selectedRoom;
      final clientState = StreamChat.of(context).client.state;
      final currentState = {...clientState.channels};

      try {
        for (final cid in currentState.keys) {
          if (currentState[cid]!.extraData['room'].toString() != roomNumber) {
            clientState.removeChannel(cid);
          }
        }
      } catch (e) {
        print('Error${e}');
      }
    }
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    subscription.cancel();
    for (final _controller in _controllers) {
      _controller.dispose();
    }
    super.dispose();
  }

  void getData(String selectedRoom, List rooms) async {
    print('*******main page*********');
    List roomSigned = AppProviderPage.of(context, listen: false).roomSigned;

    // Check if you left the selected room
    if (selectedRoom != '') {
      int selectedIndex = rooms
          .indexWhere((element) => element['channel']['id'] == selectedRoom);

      selectedRoom = roomSigned[selectedIndex]['status']
          ? rooms[selectedIndex]['channel']['id']
          : '';
    }

    if (selectedRoom == '') {
      int signedIndex = roomSigned.indexWhere((e) => e['status']);
      if (signedIndex > -1) {
        selectedRoom = rooms[signedIndex]['channel']['id'];
      }
    }

    int selectNum =
        rooms.indexWhere((element) => element['channel']['id'] == selectedRoom);
    // setState(() {
    selectedRoomId = selectedRoom;
    totalRooms = rooms;
    selectRoomNumber = selectNum;
    if (rooms.isNotEmpty) {
      roomName = (rooms[selectNum]['channel'] != null)
          ? rooms[selectNum]['channel']['name'][0]
          : "";
    }
    // });

    if (selectedRoom != '') {
      _controllers.addAll([
        StreamChannelListController(
            client: StreamChat.of(context).client,
            presence: false,
            // messageLimit: 300,
            filter: Filter.and([
              Filter.equal(
                'room',
                selectedRoom,
              ),
              Filter.equal('type', 'channel-1')
            ]),
            channelStateSort: const [
              SortOption('created_at', direction: SortOption.ASC)
            ]),
        StreamChannelListController(
            client: StreamChat.of(context).client,
            presence: false,
            // messageLimit: 300,
            filter: Filter.and([
              Filter.equal(
                'room',
                selectedRoom,
              ),
              Filter.equal('type', 'channel-2')
            ]),
            channelStateSort: const [
              SortOption('created_at', direction: SortOption.ASC)
            ]),
        StreamChannelListController(
            client: StreamChat.of(context).client,
            presence: false,
            // messageLimit: 300,
            filter: Filter.and([
              Filter.equal(
                'room',
                selectedRoom,
              ),
              Filter.equal('type', 'channel-3')
            ]),
            channelStateSort: const [
              SortOption('created_at', direction: SortOption.ASC)
            ])
      ]);
    }

    // setState(() {
    if (selectNum > -1) {
      final List members = rooms[selectNum]['members'];
      doctors = members
          .where((e) => e['user'] != Null && e['user']['role'] == 'doctor')
          .toList();
      for (var item in doctors) {
        if (item['user'] != null) {
          item['user']['image'] = item['user']['image'] ??
              'https://doctor-thumbnail.s3.ap-northeast-1.amazonaws.com/%E5%8C%BB%E5%B8%AB%E7%94%BB%E5%83%8F%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%EF%BC%88%E3%82%B5%E3%82%A4%E3%82%B9%E3%82%99%E8%AA%BF%E6%95%B4%E6%B8%88%E3%81%BF%EF%BC%89/%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88/Defalt_Doctor_Icon_Gray.png';
        }
      }
    }
    // });
    Future.delayed(const Duration(seconds: 1), () {
      AppProviderPage.of(context, listen: false).selectedRoom = selectedRoom;

      if (MainScreen.targetChannel.isNotEmpty) {
        final client = StreamChat.of(context).client;
        goChannelDetail(client.channel(MainScreen.targetChannelType,
            id: MainScreen.targetChannel));
      }
    });

    // Search unread replies
    // final client = StreamChat.of(context).client;
    // await client.search(Filter.and([
    //   Filter.in_('type', ['channel-2','channel-3']),
    //   Filter.equal('room', selectedRoom)
    // ]), messageFilters: )
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    final unreadMessages = AppProviderPage.of(context, listen: true)
            .unreadMessages[selectedRoomId] ??
        [];

    if (selectedRoomId == '') {
      return Center(
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
                child: const Text('現在参加中のROOMがありません。ROOM検索画面より参加するROOMをお選びください',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xffcbcbcb),
                        fontFamily: 'M_PLUS',
                        fontSize: 15,
                        fontWeight: FontWeight.w500)))
          ]));
    }
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 160,
              child: Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 106,
                  child:
                      totalRooms[selectRoomNumber]['channel']['image'] != null
                          ? Image.network(
                              totalRooms[selectRoomNumber]['channel']['image'],
                              fit: BoxFit.cover)
                          : Image.asset(
                              'assets/images/main-header.png',
                              fit: BoxFit.cover,
                            ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.06),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
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
                                    room: totalRooms[selectRoomNumber],
                                  );
                                }));
                          },
                          child: SvgPicture.asset(
                            'assets/images/main-info.svg',
                          ),
                        )
                      ]),
                ),
                Container(
                  height: 70,
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(
                      top: 75,
                      left: MediaQuery.of(context).size.height * 0.015,
                      right: MediaQuery.of(context).size.height * 0.015),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13)),
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.only(right: 10),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero, side: BorderSide.none),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(13)),
                              child: Text(
                                roomName,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                      Expanded(
                          child: ListView.builder(
                              padding: const EdgeInsets.all(0),
                              itemCount: doctors.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return doctorIcon(doctors[index]);
                              })),
                    ],
                  ),
                ),
              ])),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      side: const BorderSide(color: Colors.transparent)),
                  onPressed: () {
                    goForYouPage();
                  },
                  child: BetterStreamBuilder(
                      stream:
                          StreamChat.of(context).client.state.currentUserStream,
                      builder: (context, data) {
                        return Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.03),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: SvgPicture.asset(
                                    'assets/images/main-for-you.svg',
                                    color: (unreadMessages.isNotEmpty
                                        ? AppColors.mainText
                                        : AppColors.mainText2),
                                  )),
                              Expanded(
                                flex: 8,
                                child: Text(
                                  'For You',
                                  style: TextStyle(
                                      color: (unreadMessages.isNotEmpty
                                          ? AppColors.mainText
                                          : AppColors.mainText2),
                                      fontFamily: 'M_PLUS',
                                      fontSize: 15,
                                      fontWeight: unreadMessages.isNotEmpty
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      side: const BorderSide(color: Colors.transparent)),
                  onPressed: () {},
                  child: Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: SvgPicture.asset(
                              'assets/images/main-calender.svg',
                            )),
                        Expanded(
                          flex: 8,
                          child: Text(
                            '0件のイベント',
                            style: const TextStyle(
                                color: Color(0xff4F5660),
                                fontFamily: 'M_PLUS',
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      side: const BorderSide(color: Colors.transparent)),
                  onPressed: () {},
                  child: Container(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.03),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: SvgPicture.asset(
                              'assets/images/main-consultation.svg',
                            )),
                        Expanded(
                            flex: 6,
                            child: Text(
                              '個別相談予約',
                              style: const TextStyle(
                                  color: Color(0xff4F5660),
                                  fontFamily: 'M_PLUS',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            )),
                        Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              alignment: Alignment.topCenter,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.5),
                                  border: Border.all(
                                      color: Color(0xffb4babf), width: 1)),
                              child: Text(
                                '準備中',
                                style: const TextStyle(
                                    color: Color(0xffb4babf),
                                    fontFamily: 'M_PLUS',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          side: const BorderSide(color: Colors.transparent)),
                      onPressed: () {},
                      child: Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.03),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: SvgPicture.asset(
                                  'assets/images/main-introduction.svg',
                                )),
                            Expanded(
                                flex: 6,
                                child: Text(
                                  '紹介状発行',
                                  style: const TextStyle(
                                      color: Color(0xff4F5660),
                                      fontFamily: 'M_PLUS',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  alignment: Alignment.topCenter,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.5),
                                      border: Border.all(
                                          color: Color(0xffb4babf), width: 1)),
                                  child: Text(
                                    '準備中',
                                    style: const TextStyle(
                                        color: Color(0xffb4babf),
                                        fontFamily: 'M_PLUS',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    )),
                channelSegment(
                    'assets/images/main-exclamation.svg', 'アナウンス', 1),
                channelList(_controllers[0]),
                channelSegment('assets/images/main-qa.svg', 'Q & Aチャネル', 2),
                channelList(_controllers[1]),
                channelSegment(
                    'assets/images/main-user-comunity.svg', 'ユーザーコミュニティ', 3),
                channelList(_controllers[2])
              ])))
        ],
      ),
    ));
  }

  Widget channelList(StreamChannelListController controller) {
    return StreamChannelListView(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        emptyBuilder: (context) => Container(),
        separatorBuilder: (context, values, index) => Container(),
        itemBuilder: (
          context,
          channels,
          index,
          defaultWidget,
        ) {
          final client = StreamChat.of(context).client;
          String title = channels[index].name!;
          String? cid = channels[index].cid;

          return BetterStreamBuilder<int>(
              stream: client.state.channels[cid]?.state?.unreadCountStream,
              initialData: client.state.channels[cid]?.state?.unreadCount,
              builder: (context, data) {
                int threadCount = channels[index].state!.messages.length;
                //  =
                //     channels[index].state!.channelState.messages!.length;

                return InkWell(
                    onTap: () {
                      goChannelDetail(channels[index]);
                    },
                    child: Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.03),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: SvgPicture.asset(
                                'assets/images/main-channel-title.svg',
                                color: data > 0
                                    ? AppColors.mainText
                                    : AppColors.mainText2,
                              )),
                          Expanded(
                            flex: 8,
                            child: Text(
                              data > 0
                                  ? title + ' (${data > 99 ? '99+' : data})'
                                  : title,
                              style: data > 0
                                  ? const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'M_PLUS',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)
                                  : const TextStyle(
                                      color: Color(0xff4F5660),
                                      fontFamily: 'M_PLUS',
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                            ),
                          ),
                          threadCount != null
                              ? Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      threadCount.toString(),
                                      style: data > 0
                                          ? const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'M_PLUS',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)
                                          : const TextStyle(
                                              color: Color(0xff4F5660),
                                              fontFamily: 'M_PLUS',
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                    ),
                                  ))
                              : Expanded(flex: 1, child: Container())
                        ],
                      ),
                    ));
              });
        });
  }

  Widget doctorIcon(Map<String, dynamic> doctor) {
    late String imageUrl = doctor['user']['image'] ??
        'https://doctor-thumbnail.s3.ap-northeast-1.amazonaws.com/%E5%8C%BB%E5%B8%AB%E7%94%BB%E5%83%8F%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%EF%BC%88%E3%82%B5%E3%82%A4%E3%82%B9%E3%82%99%E8%AA%BF%E6%95%B4%E6%B8%88%E3%81%BF%EF%BC%89/%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88/Defalt_Doctor_Icon_Gray.png';
    return Container(
      width: 42,
      padding: EdgeInsets.zero,
      alignment: Alignment.bottomLeft,
      child: TextButton(
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useRootNavigator: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              builder: ((context) {
                return DoctorInfoModal(doctor: doctor);
              }));
        },
        child: CircleAvatar(
            backgroundColor: Colors.black12,
            backgroundImage: NetworkImage(imageUrl)),
      ),
    );
  }

  Widget channelSegment(String svgPath, String title, int segmentIndex) {
    return Container(
      decoration: const BoxDecoration(
          border:
              Border(top: BorderSide(width: 0.1, color: Color(0xff4f5660)))),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      child: Row(
        children: [
          Expanded(flex: 1, child: SvgPicture.asset(svgPath)),
          Expanded(
            flex: 8,
            child: Row(
              children: [
                Text('$title  ( ',
                    style: const TextStyle(
                        color: Color(0xff4F5660),
                        fontFamily: 'M_PLUS',
                        fontSize: 15,
                        fontWeight: FontWeight.normal)),
                if (segmentIndex == 1)
                  SvgPicture.asset(
                    'assets/images/management-icon.svg',
                    fit: BoxFit.contain,
                  ),
                if (segmentIndex == 2 || segmentIndex == 3)
                  SvgPicture.asset('assets/images/user-icon.svg'),
                const Text(' → ',
                    style: TextStyle(
                        color: Color(0xff4F5660),
                        fontFamily: 'M_PLUS',
                        fontSize: 15,
                        fontWeight: FontWeight.normal)),
                if (segmentIndex == 1)
                  SvgPicture.asset('assets/images/user-icon.svg'),
                if (segmentIndex == 2)
                  SvgPicture.asset('assets/images/doctor-icon.svg'),
                if (segmentIndex == 3)
                  SvgPicture.asset('assets/images/user-icon.svg'),
                const Text(' )',
                    style: TextStyle(
                        color: Color(0xff4F5660),
                        fontFamily: 'M_PLUS',
                        fontSize: 15,
                        fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          Expanded(flex: 1, child: Container())
        ],
      ),
    );
  }

  void goChannelDetail(Channel channel) {
    if (MainScreen.targetChannel.isNotEmpty) {
      MainScreen.targetChannel = '';
      MainScreen.targetChannelType = '';
    }
    if (channel.type == 'channel-1') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StreamChannel(
            channel: channel,
            child: const Type1Channel1Page(),
          ),
        ),
      );
    } else if (channel.type == 'channel-2') {
      AppProviderPage.of(context, listen: false).doctors = doctors;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StreamChannel(
            channel: channel,
            child: Type2Channel1Page(),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StreamChannel(
            channel: channel,
            child: const Type3Channel1Page(),
          ),
        ),
      );
    }
  }

  void goForYouPage() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForYouPage()));
  }

  Future<void> updateToken(String? token) {
    StreamChat.of(context).client.addDevice(token!, PushProvider.firebase,
        pushProviderName: 'doceo_pushnotification');
    throw '';
  }
}
