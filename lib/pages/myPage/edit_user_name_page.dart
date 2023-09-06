// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/myPage/accout_page.dart';
import 'package:doceo_new/pages/myPage/input_text.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class EditUserNamePage extends StatefulWidget {
  const EditUserNamePage({super.key});

  @override
  _EditUserNamePage createState() => _EditUserNamePage();
}

class _EditUserNamePage extends State<EditUserNamePage> {
  final TextEditingController _textEditingController =
      TextEditingController(text: 'initial');

  @override
  void initState() {
    super.initState();
  }

  void _onPress(context) async {
    try {
      String newUserName = _textEditingController.text;
      final client = StreamChat.of(context).client;
      final currentUser = StreamChat.of(context).currentUser;
      currentUser!.extraData['name'] = newUserName;
      AuthenticateProviderPage.of(context, listen: false).user['name'] =
          newUserName;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AccountPage()));
      await client.updateUser(currentUser);
      await Amplify.Auth.updateUserAttribute(
        userAttributeKey: CognitoUserAttributeKey.name,
        value: newUserName,
      );
    } catch (err) {
      print(err);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToast(message: "エラーが発生しました。\n少し時間をおいてお試しください。");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = StreamChat.of(context).currentUser;
    var userName = currentUser!.name ?? 'UserName';
    setState(() {
      _textEditingController.text = userName;
    });
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
            title: const Text('ユーザー名編集',
                style: TextStyle(
                    fontFamily: 'M_PLUS',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              InputText(
                  title: 'ユーザー名',
                  textEditingController: _textEditingController),
              const SizedBox(height: 45),
              FractionallySizedBox(
                widthFactor: 1.0,
                child: OutlinedButton(
                    onPressed: () {
                      _onPress(context);
                    },
                    style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xff7369E4)),
                    child: const Text('変更する',
                        style: TextStyle(
                            fontFamily: 'M_PLUS',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
              )
            ],
          ),
        ));
  }
}
