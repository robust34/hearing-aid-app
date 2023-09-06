// ignore_for_file: avoid_print

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/models/ModelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as GetStream;

class PointHistoryPage extends StatefulWidget {
  const PointHistoryPage({super.key});

  @override
  _PointHistoryPage createState() => _PointHistoryPage();
}

class _PointHistoryPage extends State<PointHistoryPage> {
  late List<PointHistory?> list = [];
  bool loading = true;
  final formatter = NumberFormat.compact();
  final dateFormatter = DateFormat('yyyy/MM/dd');
  List doctorImages = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void getData() async {
    try {
      final currentUser = GetStream.StreamChat.of(context).currentUser;
      final queryParams = PointHistory.USERID.eq(currentUser!.id);
      final request =
          ModelQueries.list(PointHistory.classType, where: queryParams);
      final response = await Amplify.API.query(request: request).response;
      var _doctorImages = [];
      final items = response.data?.items;
      print(items);
      if (items == null) {
        print('errors: ${response.errors}');
        setState(() {
          list = [];
        });
      } else {
        List<PointHistory?> sortedList = List.from(items)
          ..sort((a, b) {
            DateTime? dateA = a!.createdAt != null
                ? DateTime.parse(a.createdAt.toString())
                : null;
            DateTime? dateB = b!.createdAt != null
                ? DateTime.parse(b.createdAt.toString())
                : null;
            return dateB!.compareTo(dateA!);
          })
          ..forEach((element) async {
            if (element?.doctorId != null) {
              final client = GetStream.StreamChat.of(context).client;
              final result = await client.queryUsers(
                  filter: GetStream.Filter.equal(
                      'id', element!.doctorId.toString()));
              print(result.users[0].extraData['image']);
              _doctorImages.add({
                'id': element.doctorId,
                'image': result.users[0].extraData['image']
              });
            }
          });
        print(_doctorImages);
        setState(() {
          list = sortedList;
          doctorImages = _doctorImages;
        });
      }
    } on ApiException catch (e) {
      print('Query failed: $e');
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
            title: const Text('ポイント',
                style: TextStyle(
                    fontFamily: 'M_PLUS',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : list.isNotEmpty
                ? ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = list[index]!;
                      var image =
                          'https://doctor-thumbnail.s3.ap-northeast-1.amazonaws.com/%E5%8C%BB%E5%B8%AB%E7%94%BB%E5%83%8F%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%EF%BC%88%E3%82%B5%E3%82%A4%E3%82%B9%E3%82%99%E8%AA%BF%E6%95%B4%E6%B8%88%E3%81%BF%EF%BC%89/%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88/Defalt_Doctor_Icon_Gray.png';
                      if (item.doctorId != null &&
                          doctorImages.firstWhere(
                                (element) => element['id'] == item.doctorId,
                                orElse: () => {'image': null},
                              )?[image] !=
                              null) {
                        image = doctorImages.firstWhere(
                          (element) => element['id'] == item.doctorId,
                          orElse: () => {'image': null},
                        )?['image'];
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                        ),
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.1, color: Color(0xff4F5660))),
                            ),
                            child: Row(children: [
                              Expanded(
                                flex: 1,
                                child: item.type == 'purchase' ||
                                        item.type == 'refund'
                                    ? SvgPicture.asset(
                                        'assets/images/coin-icon.svg',
                                        height: 50,
                                        width: 50)
                                    : (item.type == 'post'
                                        ? SvgPicture.asset(
                                            'assets/images/message-icon.svg',
                                            height: 31,
                                            width: 31)
                                        : Center(
                                            child: Image.network(
                                                image ??
                                                    'https://doctor-thumbnail.s3.ap-northeast-1.amazonaws.com/%E5%8C%BB%E5%B8%AB%E7%94%BB%E5%83%8F%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%EF%BC%88%E3%82%B5%E3%82%A4%E3%82%B9%E3%82%99%E8%AA%BF%E6%95%B4%E6%B8%88%E3%81%BF%EF%BC%89/%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88/Defalt_Doctor_Icon_Gray.png',
                                                height: 50,
                                                width: 50))),
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.text,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'M_PLUS',
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal)),
                                      Text(
                                          dateFormatter.format(item.createdAt!
                                              .getDateTimeInUtc()),
                                          style: TextStyle(
                                              color: Color(0xffB4BABF),
                                              fontFamily: 'M_PLUS',
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal))
                                    ]),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(formatter.format(item.point),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'M_PLUS',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ])),
                      );
                    })
                : Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        SvgPicture.asset(
                          'assets/images/empty-point.svg',
                          fit: BoxFit.contain,
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 30),
                            padding: const EdgeInsets.only(left: 65, right: 65),
                            child: const Text('ここではポイントの購入履歴や使用履歴を確認できます',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xffcbcbcb),
                                    fontFamily: 'M_PLUS',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)))
                      ])));
  }
}
