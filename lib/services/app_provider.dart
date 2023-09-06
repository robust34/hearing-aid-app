import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProviderPage extends ChangeNotifier {
  static AppProviderPage of(BuildContext context, {bool listen = false}) =>
      Provider.of<AppProviderPage>(context, listen: listen);

  List _rooms = [];
  List _roomSigned = [];
  String _selectedRoom = '';
  List _doctors = [];
  String _firebaseToken = '';
  Map<String, List> _unreadMessages = {};

  get firebaseToken => _firebaseToken;
  get rooms => _rooms;
  get doctors => _doctors;
  get roomSigned => _roomSigned;
  get selectedRoom => _selectedRoom;
  get unreadMessages => _unreadMessages;

  AppProviderPage() {
    _getSelectedRoom();
    _getUnreadMessages();
  }

  set firebaseToken(val) {
    _firebaseToken = val;
    notifyListeners();
  }

  set doctors(val) {
    _doctors = val;
    notifyListeners();
  }

  set selectedRoom(val) {
    _selectedRoom = val;
    _setSelectedRoom(val);
    notifyListeners();
  }

  set roomSigned(val) {
    _roomSigned = val;
    notifyListeners();
  }

  set rooms(val) {
    _rooms = val;
    notifyListeners();
  }

  set unreadMessages(val) {
    _unreadMessages = val;
    _setUnreadMessages(val);
    notifyListeners();
  }

  void _getSelectedRoom() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedRoom = prefs.getString('doceo_selected_room') ?? '';
  }

  void _setSelectedRoom(String val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('doceo_selected_room', val);
  }

  void _getUnreadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    _unreadMessages =
        jsonDecode(prefs.getString('doceo_unread_messages') ?? '{}')
            as Map<String, List<dynamic>>;
  }

  void _setUnreadMessages(Map val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('doceo_unread_messages', jsonEncode(val));
  }
}
