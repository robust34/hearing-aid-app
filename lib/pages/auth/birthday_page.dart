// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:doceo_new/pages/auth/newpassword_page.dart';
import 'package:doceo_new/pages/auth/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import '../../services/auth_provider.dart';

class BirthdayPage extends StatefulWidget {
  @override
  _BirthdayPage createState() => _BirthdayPage();
}

class _BirthdayPage extends State<BirthdayPage> {
  TextEditingController birthday = TextEditingController();
  int titleVal = 0;
  DateTime selectedDate = DateTime.now();
  String _dobValue = '';
  @override
  void initState() {
    super.initState();
    birthday.text =
        AuthenticateProviderPage.of(context, listen: false).birthday;
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1930),
      lastDate: DateTime(2900),
    );
    if (picked != null && picked != selectedDate) {
      String formattedDate = DateFormat('MM/dd/yyyy').format(picked);
      _dobValue = DateFormat('yyyy-MM-dd').format(picked);
      if (mounted) {
        setState(() {
          selectedDate = picked;
          birthday.text = formattedDate;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
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
            titleSpacing: 0,
            title: Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "戻る",
                style: TextStyle(
                  fontFamily: 'M_PLUS',
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            // ignore: unnecessary_new
            child: new SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // padding: EdgeInsets.only(top: ),
                        child: const Text(
                          '誕生日を入力してください',
                          style: TextStyle(
                              fontFamily: 'M_PLUS',
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextButton(
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(1900, 1, 1),
                                maxTime: DateTime(2023, 12, 31),
                                onConfirm: (date) {
                              String formattedDate =
                                  DateFormat('MM/dd/yyyy').format(date);
                              _dobValue = DateFormat('yyyy-MM-dd').format(date);
                              if (selectedDate != null) {
                                setState(() {
                                  selectedDate = date;
                                  birthday.text = formattedDate;
                                });
                              }
                            },
                                currentTime: selectedDate,
                                locale: LocaleType.jp);
                          },
                          child: TextFormField(
                            enabled: false,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xffEBECEE),
                              suffixIcon: InkWell(
                                child: Icon(Icons.calendar_month,
                                    color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: '',
                            ),
                            controller: birthday,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          onPressed: () {
                            goNewPassword();
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
                              child: const Text(
                                '次へ',
                                style: TextStyle(
                                    fontFamily: 'M_PLUS',
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
          )),
        ),
        onWillPop: () => Future.value(false));
  }

  void goNewPassword() {
    if (birthday.text.isNotEmpty) {
      AuthenticateProviderPage.of(context, listen: false).birthday =
          birthday.text;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NewPasswordPage()));
    } else {
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToast(message: "あなたの誕生日を入力してください。");
    }
  }
}
