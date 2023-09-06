// ignore_for_file: avoid_print

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/myPage/input_text.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  _EditPasswordPage createState() => _EditPasswordPage();
}

class _EditPasswordPage extends State<EditPasswordPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController(text: '');
  final TextEditingController _newPasswordController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
  }

  void changePassword() async {
    try {
      if (_newPasswordController.text.length >= 8 &&
          containsUpperCaseLowerCaseAndNumber(_newPasswordController.text)) {
        await Amplify.Auth.updatePassword(
            newPassword: _newPasswordController.text,
            oldPassword: _currentPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check, color: Color(0xff1997F6)),
                SizedBox(width: 10),
                Text('パスワードが変更されました。',
                    style: TextStyle(
                        fontFamily: 'M_PLUS',
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black)),
              ],
            ),
            backgroundColor: const Color(0xffEAF6FD),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
              side: const BorderSide(
                color: Color(0xFF1997F6),
                width: 1,
              ),
            ),
            margin: EdgeInsets.only(top: 80),
          ),
        );
        Navigator.pop(context);
      } else {
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToast(message: "パスワードは8文字以上、大文字、小文字、数字である必要があります。");
      }
    } catch (err) {
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToast(message: "エラーです。パスワードを再度入力してください。");
    }
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
            title: const Text('パスワード編集',
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
                title: '現在のパスワード',
                textEditingController: _currentPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              InputText(
                title: '新しいパスワード',
                textEditingController: _newPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 45),
              FractionallySizedBox(
                widthFactor: 1.0,
                child: OutlinedButton(
                    onPressed: () {
                      String currentPassword = _currentPasswordController.text;
                      String newPassword = _newPasswordController.text;
                      if (newPassword.isNotEmpty) {
                        updatePassword(context, currentPassword, newPassword);
                      }
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

Future<void> updatePassword(
    BuildContext context, String currentPassword, String newPassword) async {
  try {
    if (newPassword.length >= 8 &&
        containsUpperCaseLowerCaseAndNumber(newPassword)) {
      await Amplify.Auth.updatePassword(
          oldPassword: currentPassword, newPassword: newPassword);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              // title: const Text('エラーが発生しました。'),
              content: const Text('パスワードは8文字以上、大文字、小文字、数字を含む必要があります。',
                  style: TextStyle(
                      fontFamily: 'M_PLUS',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.black)),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        },
      );
    }
  } on AmplifyException catch (err) {
    print('password update was failed $err');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            title: const Text('エラーが発生しました。'),
            content: const Text('パスワードに間違いがあります。\n再度入力してください'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]);
      },
    );
  }
}

bool containsUpperCaseLowerCaseAndNumber(String str) {
  bool hasUpperCase = false;
  bool hasLowerCase = false;
  bool hasNumber = false;

  for (int i = 0; i < str.length; i++) {
    if (str[i].toUpperCase() == str[i] && str[i].toLowerCase() != str[i]) {
      hasUpperCase = true;
    } else if (str[i].toLowerCase() == str[i] &&
        str[i].toUpperCase() != str[i]) {
      hasLowerCase = true;
    } else if (int.tryParse(str[i]) != null) {
      hasNumber = true;
    }

    if (hasUpperCase && hasLowerCase && hasNumber) {
      return true;
    }
  }

  return false;
}
