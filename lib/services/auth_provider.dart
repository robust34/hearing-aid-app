import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:toast/toast.dart';
import 'package:doceo_new/services/app_provider.dart';

class AuthenticateProviderPage extends ChangeNotifier {
  static AuthenticateProviderPage of(BuildContext context,
          {bool listen = false}) =>
      Provider.of<AuthenticateProviderPage>(context, listen: listen);
  Map _user = {};
  int _signVal = 1;
  bool _isAuthenticated = false;
  String _verificationTitle = "";
  String _verificationTool = "";
  String _birthday = "";
  String _password = "";
  String _userName = "User Name";
  String _email = "";
  String _phoneNumber = "";
  String _getStreamToken = "";
  String _avatarUrl = "assets/images/avatars/default.png";
  String _introduction = '自己紹介を入力してください。';
  late StreamChatClient _client;

  get client => _client;
  get getStreamToken => _getStreamToken;
  get password => _password;
  get userName => _userName;
  get email => _email;
  get phoneNumber => _phoneNumber;
  get isAuthenticated => _isAuthenticated;
  get signVal => _signVal;
  get verificationTitle => _verificationTitle;
  get verificationTool => _verificationTool;
  get birthday => _birthday;
  get avatarUrl => _avatarUrl;
  get user => _user;
  get introduction => _introduction;

  set user(val) {
    _user = val;
    print({_user});
    notifyListeners();
  }

  set avatarUrl(val) {
    _avatarUrl = val;
    notifyListeners();
  }

  set client(val) {
    _client = val;
    notifyListeners();
  }

  set getStreamToken(val) {
    _getStreamToken = val;
    notifyListeners();
  }

  set password(val) {
    _password = val;
    notifyListeners();
  }

  set userName(val) {
    _userName = val;
    notifyListeners();
  }

  set isAuthenticated(val) {
    _isAuthenticated = val;
    setLoginStatus(val);
    notifyListeners();
  }

  set birthday(val) {
    _birthday = val;
    notifyListeners();
  }

  set email(val) {
    _email = val;
    notifyListeners();
  }

  set phoneNumber(val) {
    _phoneNumber = val;
    notifyListeners();
  }

  set introduction(val) {
    _introduction = val;
    notifyListeners();
  }

  set verificationTitle(val) {
    _verificationTitle = val;
    notifyListeners();
  }

  set signVal(val) {
    _signVal = val;
    notifyListeners();
  }

  set verificationTool(val) {
    _verificationTool = val;
    notifyListeners();
  }

  // Future<void> setUserModel(UserModel userModel,
  //     {bool isNotifiable = true}) async {
  //   _userModel = userModel;
  //   if (isNotifiable) notifyListeners();
  // }
  void notifyToast({message}) {
    Toast.show(message, duration: Toast.center, gravity: Toast.bottom);
  }

  void notifyToastDanger({message}) {
    Toast.show(message,
        duration: Toast.center,
        gravity: Toast.bottom,
        backgroundColor: Colors.red,
        webTexColor: Colors.white);
  }

  void notifyToastSuccess(message, context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.85,
        ),
        content: Row(
          children: [
            Icon(Icons.check, color: Color(0xff1997F6)),
            SizedBox(width: 10),
            Text(message,
                style: TextStyle(
                    fontFamily: 'M_PLUS',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black)),
          ],
        ),
        backgroundColor: const Color(0xffEAF6FD),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
          side: const BorderSide(
            color: Color(0xFF1997F6),
            width: 1,
          ),
        ),
      ),
    );
  }

  Future<bool> isUserSignedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    return result.isSignedIn;
  }

  Future<AuthUser> getCurrentUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    return user;
  }

  Future<void> setLoginStatus(val) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setBool("loginStatus", val);
  }

  Future<bool> getLoginStatus() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    var value = sharedPreference.getBool("loginStatus") ?? false;
    return Future<bool>.value(value);
  }
}
