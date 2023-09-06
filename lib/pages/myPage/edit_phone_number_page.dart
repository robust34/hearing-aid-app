// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/myPage/confirm_mail_address_page.dart';
import 'package:doceo_new/pages/myPage/input_text.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';

class EditPhoneNumberPage extends StatefulWidget {
  const EditPhoneNumberPage({super.key});

  @override
  _EditPhoneNumberPage createState() => _EditPhoneNumberPage();
}

class _EditPhoneNumberPage extends State<EditPhoneNumberPage> {
  final TextEditingController _textEditingController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    setState(() {
      _textEditingController.text =
          AuthenticateProviderPage.of(context, listen: false).phoneNumber;
    });
  }

  void _onPress() async {
    try {
      String phoneNumber = _textEditingController.text;
      AuthenticateProviderPage.of(context, listen: false).user['phoneNumber'] =
          phoneNumber;
      String validPhoneNumber = '+81' + phoneNumber.substring(1);
      bool isValidPhoneNumber =
          RegExp(r'^\+81[0-9]{10}$').hasMatch(validPhoneNumber);
      if (isValidPhoneNumber) {
        final updatedUser = await Amplify.Auth.updateUserAttribute(
          userAttributeKey: CognitoUserAttributeKey.phoneNumber,
          value: validPhoneNumber,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ConfirmMailAddressPage(phoneNumber: phoneNumber)));
      } else {
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToast(message: "無効な電話番号です。再度入力してください。");
      }
    } catch (err) {
      print(err);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToast(message: "エラーが発生しました。\n少し時間をおいてお試しください。");
    }
  }

  @override
  Widget build(BuildContext context) {
    var phoneNumber =
        AuthenticateProviderPage.of(context, listen: true).phoneNumber;
    setState(() {
      if (phoneNumber.isNotEmpty) {
        _textEditingController.text = phoneNumber;
      }
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
            title: const Text('電話番号編集',
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
                  title: '電話番号', textEditingController: _textEditingController),
              const SizedBox(height: 45),
              FractionallySizedBox(
                widthFactor: 1.0,
                child: OutlinedButton(
                    onPressed: () {
                      if (_textEditingController.text.isNotEmpty) _onPress();
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
