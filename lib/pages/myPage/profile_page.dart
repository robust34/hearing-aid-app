// ignore_for_file: avoid_print

import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final TextEditingController _introductionController =
      TextEditingController(text: '');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userName = AuthenticateProviderPage.of(context, listen: true).userName;
    var introduction =
        AuthenticateProviderPage.of(context, listen: true).introduction;
    var avatarUrl =
        AuthenticateProviderPage.of(context, listen: true).avatarUrl;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    setState(() {
      _introductionController.text = introduction;
    });
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
            actions: [
              Padding(
                padding: EdgeInsets.only(right: width * 0.04),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      AuthenticateProviderPage.of(context, listen: false)
                          .introduction = _introductionController.text;
                    });
                    Navigator.pop(context);
                  },
                  child: const Center(
                    child: Text('保存',
                        style: TextStyle(
                            fontFamily: 'M_PLUS',
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                  ),
                ),
              )
            ],
            backgroundColor: Colors.white,
            title: const Text('プロフィール',
                style: TextStyle(
                    fontFamily: 'M_PLUS',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(children: [
                FractionallySizedBox(
                    heightFactor: 14 / 19,
                    widthFactor: 1.0,
                    child: Image.asset(
                      'assets/images/room-header-1.png',
                      fit: BoxFit.cover,
                    )),
                Column(children: [
                  Expanded(flex: 9, child: Container()),
                  Expanded(
                    flex: 10,
                    child: Container(
                      padding: EdgeInsets.only(left: width * 0.02),
                      alignment: Alignment.centerLeft,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            child: avatarUrl.isNotEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.black),
                                        image: DecorationImage(
                                            image: AssetImage(avatarUrl),
                                            fit: BoxFit.contain),
                                        color: Colors.white,
                                        shape: BoxShape.circle))
                                : Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blueAccent,
                                    ),
                                    child: Text(
                                      userName.length >= 2
                                          ? userName
                                              .substring(0, 2)
                                              .toUpperCase()
                                          : userName
                                              .substring(0, 1)
                                              .toUpperCase(),
                                      style: const TextStyle(
                                          fontFamily: 'M_PLUS',
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  )),
                      ),
                    ),
                  )
                ])
              ]),
            ),
            Expanded(
                flex: 8,
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: FractionallySizedBox(
                    heightFactor: 0.8,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: FractionallySizedBox(
                          widthFactor: 0.92,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: width * 0.04),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 0.1,
                                            color: Color(0xff4F5660)))),
                                child: Text(userName,
                                    style: const TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: width * 0.04),
                                child: const Text('自己紹介',
                                    style: TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black)),
                              ),
                              Expanded(
                                child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: width * 0.02),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.3,
                                            color: const Color(0xff4F5660)),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: TextField(
                                      controller: _introductionController,
                                      maxLines: null,
                                      style: const TextStyle(
                                          fontFamily: 'M_PLUS',
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: width * 0.02),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          )),
                                    )),
                              )
                            ],
                          ),
                        )),
                  ),
                ))
          ],
        ));
  }
}
