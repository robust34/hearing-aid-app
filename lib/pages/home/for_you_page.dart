// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class ForYouPage2 extends StatefulWidget {
  const ForYouPage2({super.key});

  @override
  State<ForYouPage2> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final formatter = NumberFormat.compact();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ToastContext().init(context);
    List<Map<String, dynamic>> archives = [
      {'id': 0},
      {}
    ];

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: const Text(
            "For you",
            style: TextStyle(
                fontFamily: 'M_PLUS',
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: width * 0.04),
                alignment: Alignment.centerLeft,
                child: const Text(
                  '新着なし',
                  style: TextStyle(
                      fontFamily: 'M_PLUS',
                      color: Color(0xffB4BABF),
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                )),
            channelItem(),
            channelItem()
          ],
        )),
      ),
    );
  }

  Widget channelItem() {
    double width = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: width * 0.04, top: 10, bottom: 10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.1, color: Color(0xff4F5660)),
                      top: BorderSide(width: 0.1, color: Color(0xff4F5660)))),
              child: const Text(
                "♯    channel title",
                style: TextStyle(
                    fontFamily: 'M_PLUS',
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              )),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.02, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const CircleAvatar(),
                    Container(
                      color: Colors.purple,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: LShapePainter(itemCount: 3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 7,
                child: Column(children: [
                  Container(
                      height: 200,
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: width * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text('めめ',
                                  style: TextStyle(
                                      fontFamily: 'M_PLUS',
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 10),
                              Text('5分前',
                                  style: TextStyle(
                                      fontFamily: 'M_PLUS',
                                      color: Color(0xffB4BABF),
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                          const Text(
                              '糖尿病など多くの生活習慣病は肥満が原因であるものが多く、自助努力だけではダイエットが困難である方や生まれつき太りやすい方、健康面から今すぐに減量を検討すべき方を対象としたROOMです。',
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal)),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  primary: const Color(0xffD9D9D9)),
                              onPressed: () {},
                              child: const Text('action',
                                  style: TextStyle(
                                      fontFamily: 'M_PLUS',
                                      color: Color(0xffB4BABF),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal))),
                        ],
                      )),
                  replyItem(),
                  replyItem(),
                  replyItem()
                ]))
          ])
        ]));
  }

  Widget replyItem() {
    double width = MediaQuery.of(context).size.width;

    return Container(
        height: 90,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: width * 0.02),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: width * 0.02),
        alignment: Alignment.topLeft,
        decoration: const BoxDecoration(
            color: Color(0xffEBEBEB),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Image.network(
                      'https://doctor-thumbnail.s3.ap-northeast-1.amazonaws.com/%E5%8C%BB%E5%B8%AB%E7%94%BB%E5%83%8F/%E5%B2%A1%E7%94%B0%E5%85%88%E7%94%9F/5DA_8388.png',
                      fit: BoxFit.cover,
                      height: 20,
                      width: 20,
                    ),
                    const Text('宇野医師',
                        style: TextStyle(
                            fontFamily: 'M_PLUS',
                            color: Color(0xff7A96DE),
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const Flexible(
                      child: Text('が回答しました',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'M_PLUS',
                              color: Color(0xffB4BABF),
                              fontSize: 15,
                              fontWeight: FontWeight.normal)),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      'assets/images/comment-for-archive.svg',
                      fit: BoxFit.cover,
                    ),
                    Text(formatter.format(120000),
                        style: const TextStyle(
                            fontFamily: 'M_PLUS',
                            color: Color(0xffB4BABF),
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const Text(
              '（字幕）糖尿病など多くの生活習慣病は肥満が原因であるものが多く、自助努力だけではダイエットが困難である方や生まれつき太りやすい方、健康面から今すぐに減量を検討すべき方を対象としたROOMです。',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: 'M_PLUS',
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal))
        ]));
  }
}

class LShapePainter extends CustomPainter {
  final int itemCount;
  LShapePainter({required this.itemCount});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xffD9D9D9)
      ..strokeWidth = 2.0;

    double x = size.width / 2;
    double height = 110;
    double y = 180;

    canvas.drawLine(
        Offset(x, 5), Offset(x, y + height * (itemCount - 1)), paint);
    canvas.drawLine(Offset(x, y), Offset(x * 2, y), paint);
    for (int i = 1; i < itemCount; i++) {
      canvas.drawLine(
          Offset(x, y + height * i), Offset(x * 2, y + height * i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
