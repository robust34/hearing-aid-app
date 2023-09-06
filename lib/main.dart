import 'package:doceo_new/helper/awesome_notifications_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

import './app.dart';
import 'helper/fcm_helper.dart';
import 'helper/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  // print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // inti fcm services
  // await FcmHelper.initFcm();

  // initialize local notifications service
  await AwesomeNotificationsHelper.init();

  // final chatPersistentClient = StreamChatPersistenceClient(
  //     logLevel: Level.INFO, connectionMode: ConnectionMode.background);

  final client = StreamChatClient(
    'a6rmt92za3p7',
    logLevel: Level.INFO,
  );
  runApp(MyApp(client: client));
}
