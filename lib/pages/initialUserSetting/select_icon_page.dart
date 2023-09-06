import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/auth/verification_page.dart';
import 'package:doceo_new/pages/home/home_page.dart';
import 'package:doceo_new/pages/initialUserSetting/select_room_page.dart';
import 'package:doceo_new/pages/myPage/my_page_screen.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SelectIconPage extends StatefulWidget {
  final String? fromPage;
  const SelectIconPage({Key? key, this.fromPage}) : super(key: key);

  @override
  State<SelectIconPage> createState() => _SelectIconPage();
}

class _SelectIconPage extends State<SelectIconPage> {
  // late final client = StreamChat.of(context).client;

  get child => null;
  String avatarUrl = "";
  String sex = '男性';

  @override
  void initState() {
    // TODO: implement initState
    if (widget.fromPage == 'verification') {
      avatarUrl = AuthenticateProviderPage.of(context, listen: false).avatarUrl;
    } else {
      final currentUser = StreamChat.of(context).currentUser;
      avatarUrl = currentUser!.image ?? '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? fromPage = widget.fromPage;
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: fromPage == 'myPage'
                ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  )
                : null,
            actions: fromPage == 'verification'
                ? [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SelectRoomPage()));
                      },
                      child: const Text('Skip',
                          style: TextStyle(
                              fontFamily: 'M_PLUS',
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                              color: Colors.black)),
                    )
                  ]
                : null,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('プロフィール画像を選択',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: DottedBorder(
                              borderType: BorderType.Circle,
                              dashPattern: const [4, 6],
                              radius: const Radius.circular(200),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                height:
                                    MediaQuery.of(context).size.width * 0.35,
                                // padding: const EdgeInsets.all(35),
                                decoration: BoxDecoration(
                                    // shape: BoxShape.circle,
                                    // border: Border.all(
                                    //   width: 1.0,
                                    // ),
                                    image: DecorationImage(
                                      image: AssetImage(avatarUrl),
                                      scale: 1,
                                    ),
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                              ),
                            ),
                          ),
                          const Text('お好きなものを選んでください',
                              style: TextStyle(
                                  fontFamily: 'M_PLUS',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xffB4BABF))),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.03),
                            child: GridView.count(
                              crossAxisCount: 4,
                              children: List.generate(
                                8,
                                (index) => InkWell(
                                  onTap: () {
                                    selAvatar(index);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/avatars/avatar_$index.png"),
                                            fit: BoxFit.contain),
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.77),
                        child: ElevatedButton(
                          onPressed: () {
                            // context.go('/selectRoom');
                            goSelectRoom();
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  Color(0xffB44DD9),
                                  Color(0xff70A4F2)
                                ]),
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                fromPage == 'verification' ? '次へ' : '完了',
                                style: TextStyle(
                                    fontFamily: 'M_PLUS',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: () => Future.value(false));
  }

  void selAvatar(int num) {
    setState(() {
      avatarUrl = "assets/images/avatars/avatar_$num.png";
      sex = num > 3 ? '女性' : '男性';
      AuthenticateProviderPage.of(context, listen: false).avatarUrl =
          "assets/images/avatars/avatar_$num.png";
    });
  }

  void goSelectRoom() async {
    String? fromPage = widget.fromPage;
    try {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => VerificationPage()));
      // return;
      // Navigator.push(reRoute(builder: (context) => const SelectRoomPage()));
      final client = StreamChat.of(context).client;
      final currentUser = StreamChat.of(context).currentUser;

      currentUser!.extraData['image'] = avatarUrl;
      currentUser!.extraData['sex'] = sex;

      await client.updateUser(currentUser);

      fromPage == 'verification'
          ? Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SelectRoomPage()))
          : Navigator.pop(context);
    } catch (e) {
      print(e.toString());
    }
  }
}
