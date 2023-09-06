import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/models/Hospital.dart';
import 'package:doceo_new/pages/home/loading_animation.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorInfoModal extends StatefulWidget {
  final Map<String, dynamic> doctor;
  const DoctorInfoModal({super.key, required this.doctor});

  @override
  State<DoctorInfoModal> createState() => _DoctorInfoModalState();
}

class _DoctorInfoModalState extends State<DoctorInfoModal> {
  bool _isFullModal = false;
  late User doctorInfo = User(id: widget.doctor['user_id']);
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 1);
  var hospitalName = '登録していません。';
  var address = '登録していません。';
  num archiveCount = 0;
  num referralCount = 0;

  @override
  void initState() {
    super.initState();
    getData(widget.doctor['user_id']);
    _scrollController.addListener(() {
      if (_scrollController.offset <=
          _scrollController.position.minScrollExtent) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void getData(doctorId) async {
    final client = StreamChat.of(context).client;
    try {
      final result =
          await client.queryUsers(filter: Filter.equal('id', doctorId));
      final doctors =
          await client.queryUsers(filter: Filter.equal('role', 'doctor'));
      final messages = await client.search(
          Filter.and([
            Filter.equal('room',
                AppProviderPage.of(context, listen: false).selectedRoom),
            Filter.equal('type', 'channel-2')
          ]),
          messageFilters: Filter.equal('user', result.users[0].id),
          paginationParams: const PaginationParams(limit: 1000));
      archiveCount += messages.results.length;
      referralCount += doctors.users
          .where((e) =>
              e.extraData['referralDoctor'] != null &&
              (e.extraData['referralDoctor'] as Map)['id'] == doctorId)
          .toList()
          .length;
      final hospitalId = HospitalModelIdentifier(
          id: result.users[0].extraData['hospitalId'].toString());
      final request = ModelQueries.get(Hospital.classType, hospitalId);
      final response = await Amplify.API.query(request: request).response;
      final hospital = response.data;
      setState(() {
        doctorInfo = result.users[0];
        if (hospital?.name != null) hospitalName = hospital!.name.toString();
        if (hospital?.address != null) address = hospital!.address.toString();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                ? MediaQuery.of(context).size.height * 0.9
                : MediaQuery.of(context).size.height * 0.5,
            duration: const Duration(milliseconds: 300),
            child: SingleChildScrollView(
                controller: _isFullModal ? _scrollController : null,
                physics: _isFullModal
                    ? const ClampingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                child: Stack(children: [
                  Container(
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                      child: doctorInfo.extraData['banner'] != null
                          ? Image.network(
                              doctorInfo.extraData['banner'].toString(),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            )
                          : Image.asset(
                              'assets/images/doctor-info-header.png',
                              fit: BoxFit.cover,
                            )),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    child: Column(children: [
                      shortModalContainer(),
                      if (_isFullModal) fullModalContainer()
                    ]),
                  ),
                ]))));
  }

  Widget shortModalContainer() {
    ColorTween colorTween = ColorTween(
      begin: Color(0xFFDB00FF),
      end: Color(0xFF5200FF),
    );

    Animation<Color?> animation = colorTween.animate(
      AlwaysStoppedAnimation<double>(0.0),
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(children: [
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: MediaQuery.of(context).size.width * 0.2,
              width: MediaQuery.of(context).size.width * 0.2,
              margin: const EdgeInsets.only(bottom: 7),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(1, 3),
                    )
                  ]),
              child: CircleAvatar(
                  backgroundColor: Colors.black12,
                  backgroundImage: NetworkImage(widget.doctor['user']
                          ['image'] ??
                      'https://doctor-thumbnail.s3.ap-northeast-1.amazonaws.com/%E5%8C%BB%E5%B8%AB%E7%94%BB%E5%83%8F%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%EF%BC%88%E3%82%B5%E3%82%A4%E3%82%B9%E3%82%99%E8%AA%BF%E6%95%B4%E6%B8%88%E3%81%BF%EF%BC%89/%E3%83%87%E3%83%95%E3%82%A9%E3%83%AB%E3%83%88/Defalt_Doctor_Icon_Gray.png')),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: doctorInfo.extraData['firstName'] == null
              ? Center(child: LoadingAnimation())
              : Container(
                  alignment: Alignment.topCenter,
                  color: const Color(0xffF8F8F8),
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.02),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(width: 0.1))),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${doctorInfo.extraData['occupation'] ?? ''}/${doctorInfo.extraData['specialtyName'] ?? ''} ${doctorInfo.extraData['lastName'] ?? ''}${doctorInfo.extraData['firstName'] ?? ''}',
                              maxLines: 2,
                              style: const TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/hospital-icon.svg',
                                fit: BoxFit.cover,
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(hospitalName,
                                      maxLines: _isFullModal ? 3 : 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontFamily: 'M_PLUS',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/map-icon.svg',
                                fit: BoxFit.cover,
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(address,
                                      maxLines: _isFullModal ? 3 : 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontFamily: 'M_PLUS',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(width: 0.3)),
                            child: Text(
                                '${doctorInfo.extraData['trouble'] ?? '${doctorInfo.extraData['specialtyName'] ?? ''} 全般'}',
                                maxLines: _isFullModal ? 5 : 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontFamily: 'M_PLUS',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15)),
                          ),
                        ),
                      ],
                    ),
                  )),
        ),
      ]),
    );
  }

  String convertTimeStamp(timeStamp) {
    final dateTime = DateTime.parse(timeStamp);
    final formattedDate = DateFormat('yyyy.MM.dd').format(dateTime).toString();
    return formattedDate;
  }

  void _openURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget fullModalContainer() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('DOCEOへの参加',
                  style: TextStyle(
                      fontFamily: 'M_PLUS',
                      fontWeight: FontWeight.normal,
                      fontSize: 15)),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.zero,
                child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset('assets/images/doceo-logo.png',
                        fit: BoxFit.contain, height: 25, width: 25),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                        convertTimeStamp(doctorInfo.createdAt.toString()),
                        style: TextStyle(
                            fontFamily: 'M_PLUS',
                            fontWeight: FontWeight.normal,
                            fontSize: 15)),
                  ),
                  Expanded(
                    flex: 2,
                    child: (doctorInfo.extraData as Map)?['referralDoctor']
                                ?['image'] !=
                            null
                        ? CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.black12,
                            backgroundImage: NetworkImage((doctorInfo.extraData
                                as Map)['referralDoctor']['image']))
                        : CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.black12,
                            backgroundImage:
                                AssetImage('assets/images/DrKida.png')),
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                        (doctorInfo.extraData as Map)?['referralDoctor']
                                    ?['name'] !=
                                null
                            ? '${(doctorInfo.extraData as Map)['referralDoctor']['name']}医師の推薦'
                            : '木田医師の推薦',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'M_PLUS',
                            fontWeight: FontWeight.normal,
                            fontSize: 15)),
                  ),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.3),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(archiveCount.toString(),
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24)),
                          Text('回答',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(referralCount.toString(),
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24)),
                          Text('紹介状',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15)),
                        ],
                      ),
                      Column(
                        children: const [
                          Text('0',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24)),
                          Text('個別相談',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15)),
                        ],
                      )
                    ]),
              )
            ],
          )),
      if ((doctorInfo.extraData['medicalSpecialties'] != null &&
              doctorInfo.extraData['medicalSpecialties'] != '') ||
          (doctorInfo.extraData['biography'] != null &&
              doctorInfo.extraData['biography'] != '') ||
          (doctorInfo.extraData['links'] != null &&
              doctorInfo.extraData['links'] != '') ||
          (doctorInfo.extraData['papers'] != null &&
              doctorInfo.extraData['papers'] != ''))
        Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (doctorInfo.extraData['medicalSpecialties'] != null &&
                      doctorInfo.extraData['medicalSpecialties'] != '')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('専門医資格',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          Text(
                              '${doctorInfo.extraData['medicalSpecialties'] ?? '未登録です。'}',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15)),
                        ],
                      ),
                    ),
                  if (doctorInfo.extraData['biography'] != null &&
                      doctorInfo.extraData['biography'] != '')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('略歴',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          Text(
                              '${doctorInfo.extraData['biography'] ?? '未登録です。'}',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15)),
                        ],
                      ),
                    ),
                  if (doctorInfo.extraData['papers'] != null &&
                      doctorInfo.extraData['papers'] != '')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('研究テーマ / 論文',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          Text('${doctorInfo.extraData['papers'] ?? '未登録です。'}',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15)),
                        ],
                      ),
                    ),
                ])),
      if (doctorInfo.extraData['links'] != null &&
          (doctorInfo.extraData['links'] as List<dynamic>).isNotEmpty)
        Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text('関連リンク',
                        style: TextStyle(
                            fontFamily: 'M_PLUS',
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        (doctorInfo.extraData['links'] as List<dynamic>).length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          margin: const EdgeInsets.only(bottom: 7),
                          padding: const EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.3),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextButton(
                            onPressed: () {
                              _openURL((doctorInfo.extraData['links']
                                  as List<dynamic>)[index]['url']);
                            },
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      (doctorInfo.extraData['links']
                                          as List<dynamic>)[index]['title'],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'M_PLUS',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                  )
                                ]),
                          ));
                    },
                  ),
                ]))
    ]);
  }
}
