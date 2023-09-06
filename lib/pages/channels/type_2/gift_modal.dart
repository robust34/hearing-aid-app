import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/models/ModelProvider.dart' as Model;
import 'package:doceo_new/pages/home/loading_animation.dart';
import 'package:doceo_new/pages/myPage/point_charge_modal.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:doceo_new/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class GiftModal extends StatefulWidget {
  final Message msg;
  const GiftModal({super.key, required this.msg});

  @override
  _GiftModal createState() => _GiftModal();
}

class _GiftModal extends State<GiftModal> {
  bool _isFullModal = false;
  int selectedGift = -1;
  bool loadingState = false;
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 1);
  final List gifts = [
    {'img': 'assets/images/mask.png', 'point': 2},
    {'img': 'assets/images/shoes.png', 'point': 2},
    {'img': 'assets/images/syringe.png', 'point': 2},
    {'img': 'assets/images/thermometer.png', 'point': 2},
    {'img': 'assets/images/searchTool.png', 'point': 2},
    {'img': 'assets/images/bag.png', 'point': 2},
    {'img': 'assets/images/book.png', 'point': 2},
    {'img': 'assets/images/coat.png', 'point': 2},
    {'img': 'assets/images/machine.png', 'point': 2},
    {'img': 'assets/images/bed.png', 'point': 2},
    {'img': 'assets/images/car.png', 'point': 2},
    {'img': 'assets/images/hospital.png', 'point': 2},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset <=
          _scrollController.position.minScrollExtent) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.compact();
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
      child: AnimatedContainer(
        height: _isFullModal
            ? MediaQuery.of(context).size.height * 0.75
            : MediaQuery.of(context).size.height * 0.52,
        duration: const Duration(milliseconds: 300),
        child: SingleChildScrollView(
          controller: _isFullModal ? _scrollController : null,
          physics: _isFullModal
              ? const ClampingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 0.1, color: AppColors.mainText2))),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Container(
                                child: InkWell(
                                  onTap: () {
                                    showCoinCharge(context);
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: AssetImage(
                                            StreamChat.of(context)
                                                .currentUser!
                                                .image
                                                .toString()),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 30),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                              alignment: Alignment.center,
                                              color: Color(0xff57565680),
                                              width: 65,
                                              height: 11,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      child: SvgPicture.asset(
                                                          'assets/images/coin-icon.svg',
                                                          fit: BoxFit.contain,
                                                          height: 10),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 2,
                                                      child:
                                                          BetterStreamBuilder(
                                                              stream: StreamChat
                                                                      .of(
                                                                          context)
                                                                  .currentUserStream,
                                                              builder: (context,
                                                                  data) {
                                                                return Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    StreamChat.of(context).currentUser!.extraData['point'] !=
                                                                            null
                                                                        ? formatter.format(StreamChat.of(context)
                                                                            .currentUser!
                                                                            .extraData['point'])
                                                                        : '0',
                                                                    style: TextStyle(
                                                                        height:
                                                                            1.1,
                                                                        fontFamily:
                                                                            'M_PLUS',
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                );
                                                              })),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                        child: Container(
                                                      height: 20,
                                                      width: 20,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Center(
                                                        child: Icon(
                                                            Icons.arrow_forward,
                                                            size: 9,
                                                            color: Color(
                                                                0xff777777)),
                                                      ),
                                                    )),
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          Expanded(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(''),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 40,
                                  color: Colors.white,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: Text('Gift',
                                            style: TextStyle(
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                color: AppColors.subText3)),
                                      ),
                                      Container(
                                          child: SvgPicture.asset(
                                        'assets/images/coin-icon.svg',
                                        height: 24,
                                        fit: BoxFit.contain,
                                      )),
                                      Container(
                                        child: Text(
                                            selectedGift == -1
                                                ? 'ー'
                                                : '${gifts[selectedGift]['point']}',
                                            style: TextStyle(
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                color: AppColors.subText3,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 0),
                          physics: const NeverScrollableScrollPhysics(),
                          // childAspectRatio: 1,
                          children: List.generate(
                              gifts.length,
                              (index) => InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedGift =
                                            selectedGift == index ? -1 : index;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.25),
                                              offset: Offset(2, 3),
                                              blurRadius: 4,
                                            ),
                                          ],
                                          color: Colors.grey[300],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Stack(
                                        children: [
                                          Image.asset(
                                              'assets/images/gift-background.png',
                                              fit: BoxFit.cover),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 50,
                                                      child: Image.asset(
                                                        gifts[index]['img'],
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Image.asset(
                                                    'assets/images/gift-shadow.png',
                                                    height: 15,
                                                    fit: BoxFit.cover),
                                                selectedGift == index
                                                    ? Container(
                                                        height: 23,
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: InkWell(
                                                          onTap: () {
                                                            int currentPoint = StreamChat.of(context)
                                                                            .currentUser!
                                                                            .extraData[
                                                                        'point'] !=
                                                                    null
                                                                ? int.parse(StreamChat.of(
                                                                        context)
                                                                    .currentUser!
                                                                    .extraData[
                                                                        'point']
                                                                    .toString())
                                                                : 0;
                                                            StreamChat.of(context).currentUser!.extraData[
                                                                            'point'] !=
                                                                        null &&
                                                                    currentPoint >
                                                                        2
                                                                ? sendGift()
                                                                : showCoinCharge(
                                                                    context);
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                gradient:
                                                                    const LinearGradient(
                                                                        colors: [
                                                                      Color(
                                                                          0xffB44DD9),
                                                                      Color(
                                                                          0xff70A4F2)
                                                                    ]),
                                                                borderRadius: BorderRadius.only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10))),
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Text(
                                                              '贈る',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'M_PLUS',
                                                                  fontSize: 15,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ))
                                                    : Container(
                                                        height: 23,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(),
                                                                ],
                                                                borderRadius: const BorderRadius
                                                                        .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10))),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: SvgPicture.asset(
                                                                  'assets/images/coin-icon.svg',
                                                                  height: 18,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 3),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  gifts[index][
                                                                          'point']
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'M_PLUS',
                                                                    fontSize:
                                                                        12,
                                                                    color: AppColors
                                                                        .subText3,
                                                                  )),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                              ]),
                                        ],
                                      ),
                                    ),
                                  )),
                        ),
                        if (loadingState)
                          Container(
                            margin: EdgeInsets.only(
                                top: _isFullModal
                                    ? MediaQuery.of(context).size.height * 0.25
                                    : MediaQuery.of(context).size.height *
                                        0.15),
                            child: LoadingAnimation(),
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Future<void> sendGift() async {
    setState(() {
      loadingState = true;
    });
    try {
      final client = StreamChat.of(context).client;
      final currentUser = StreamChat.of(context).currentUser;
      final doctor = widget.msg.user;
      int point = (currentUser!.extraData['point'] != null
              ? currentUser.extraData['point'] as int
              : 0) -
          gifts[selectedGift]['point'] as int;
      int doctorPoint = (doctor!.extraData['point'] != null
              ? doctor.extraData['point'] as int
              : 0) +
          gifts[selectedGift]['point'] as int;
      int msgGifts = widget.msg.extraData['gifts'] != null
          ? widget.msg.extraData['gifts'] as int
          : 0;
      doctor.extraData['point'] = doctorPoint;
      currentUser.extraData['point'] = point;
      widget.msg.extraData['gifts'] = msgGifts + 1;

      await client.updateUser(currentUser);
      await client.updateUser(doctor);
      await client.updateMessage(widget.msg);

      Navigator.pop(context);

      final pointHistory = Model.PointHistory(
        type: 'gift',
        text: '${doctor.extraData['lastName'] ?? ''}医師にギフトを贈りました',
        userId: currentUser.id,
        messageId: widget.msg.id,
        doctorId: widget.msg.user!.id,
        point: -gifts[selectedGift]['point'] as int,
      );
      final request = ModelMutations.create(pointHistory);
      final response = await Amplify.API.mutate(request: request).response;
      if (response.errors.isNotEmpty) {
        print(response.errors);
      }
      print("success");
    } catch (e) {
      safePrint(e);
    }
    setState(() {
      loadingState = false;
    });
  }

  void showCoinCharge(BuildContext context) {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        isScrollControlled: true,
        builder: ((context) {
          return const PointChargeModal();
        }));
  }
}
