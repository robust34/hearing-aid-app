// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/myPage/confirm_mail_address_page.dart';
import 'package:doceo_new/pages/myPage/input_text.dart';
import 'package:doceo_new/pages/myPage/my_page_screen.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class EditMailAddressPage extends StatefulWidget {
  const EditMailAddressPage({super.key});

  @override
  _EditMailAddressPage createState() => _EditMailAddressPage();
}

class _EditMailAddressPage extends State<EditMailAddressPage> {
  final TextEditingController _textEditingController =
      TextEditingController(text: '');
  @override
  void initState() {
    super.initState();
    setState(() {
      _textEditingController.text =
          AuthenticateProviderPage.of(context, listen: false).user['email'] ??
              '';
    });
  }

  void onPress() async {
    try {
      String newEmail = _textEditingController.text;
      await Amplify.Auth.updateUserAttribute(
        userAttributeKey: CognitoUserAttributeKey.email,
        value: newEmail,
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConfirmMailAddressPage(email: newEmail)));
    } catch (err) {
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToast(message: "エラーが発生しました。\n少し時間をおいてお試しください。");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var email = AuthenticateProviderPage.of(context, listen: false).email;
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
            title: const Text('メールアドレス編集',
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
                  title: 'メールアドレス',
                  textEditingController: _textEditingController),
              const SizedBox(height: 45),
              FractionallySizedBox(
                widthFactor: 1.0,
                child: OutlinedButton(
                    onPressed: () {
                      if (_textEditingController.text.isNotEmpty) onPress();
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
