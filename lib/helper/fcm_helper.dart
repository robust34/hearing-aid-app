import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:doceo_new/helper/awesome_notifications_helper.dart';
import 'package:doceo_new/helper/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart' as Logger;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FcmHelper {
  // prevent making instance
  FcmHelper._();

  // FCM Messaging
  static late FirebaseMessaging messaging;

  /// this function will initialize firebase and fcm instance
  static Future<void> initFcm(updateToken) async {
    try {
      // initialize fcm and firebase core
      await Firebase.initializeApp(
          // TODO: uncomment this line if you connected to firebase via cli
          options: DefaultFirebaseOptions.currentPlatform,
          name: "DOCEO");

      // initialize firebase
      messaging = FirebaseMessaging.instance;

      // notification settings handler
      await setupFcmNotificationSettings(updateToken);

      // background and foreground handlers
      FirebaseMessaging.onMessage.listen(_fcmForegroundHandler);
      // FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
    } catch (error) {
      // if you are connected to firebase and still get error
      // check the todo up in the function else ignore the error
      // or stop fcm service from main.dart class
      Logger.Logger().e(error);
    }
  }

  ///handle fcm notification settings (sound,badge..etc)
  static Future<void> setupFcmNotificationSettings(updateToken) async {
    //show notification with sound and badge
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );

    //NotificationSettings settings
    final res = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );

    if (res.authorizationStatus != AuthorizationStatus.authorized) {
      throw ArgumentError(
          'You must allow notification permissions in order to receive push notifications');
    }

    messaging.getToken().then(updateToken);
    messaging.onTokenRefresh.listen(updateToken);
  }

  /// generate and save fcm token if its not already generated (generate only for 1 time)
  // static Future<void> generateFcmToken() async {
  //   try {
  //     var token = await messaging.getToken();
  //     L).i(token);
  //     // await Future.delayed(const Duration(seconds: 5));
  //     // generateFcmToken();
  //   } catch (error) {
  //     Logger().e(error);
  //   }
  // }

  /// this method will be triggered when the app generate fcm
  /// token successfully
  // static _sendFcmTokenToServer() {
  //   var token = MySharedPref.getFcmToken();
  //   // TODO SEND FCM TOKEN TO SERVER
  //   try {
  //     final auth = AuthController.authUser.value;
  //     if (auth == null) return;
  //     Map<String, dynamic> metadata = auth.metadata!;
  //     metadata['fcm_token'] = token;

  //     FirebaseFirestore.instance
  //         .collection(DatabaseConfig.USER_COLLECTION)
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .update({"metadata": metadata});
  //   } catch (e) {
  //     Logger().e(e.toString());
  //   }
  // }

  /// *************************************
  /// @Desc: Send Push Notification to user
  static sendPushNotification(
    String fcmToken,
    String title,
    String message,
  ) async {
    try {
      try {
        var response = await http.post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "key=AAAAqlhYaXk:APA91bFilyk1VVtHM3GeVfXMM2xRZeJAc1Q10A8bnHWUrggbGi8uq97rKYlJIcLgHPdZ4tNnZzcgnsYDUxjcqGghBDuY6gDQtbVqbzwVTdXMdlTdgc8zJCOmLZvKpezwPA9l9je84e6w",
            },
            body: jsonEncode(
              <String, dynamic>{
                'notification': <String, dynamic>{
                  'body': message,
                  'title': title,
                },
                'priority': 'high',
                'data': <String, dynamic>{
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'id': '1',
                  'status': 'done',
                },
                "to": fcmToken,
              },
            )
            // body: {
            //   "to": fcmToken,
            //   "mutable_content": true,
            //   "priority": "high",
            //   "notification": {
            //     // "badge": 50,
            //     "title": "Huston! The eagle has landed!",
            //     "body":
            //         "A small step for a man, but a giant leap to Flutter's community!"
            //   },
            //   "data": {
            //     "content": {
            //       "id": 1,
            //       "badge": 50,
            //       "channelKey": "alerts",
            //       "displayOnForeground": true,
            //       "notificationLayout": "BigPicture",
            //       "largeIcon":
            //           "https://br.web.img3.acsta.net/pictures/19/06/18/17/09/0834720.jpg",
            //       "bigPicture": "https://www.dw.com/image/49519617_303.jpg",
            //       "showWhen": true,
            //       "autoDismissible": true,
            //       "privacy": "Private",
            //       "payload": {"secret": "Awesome Notifications Rocks!"}
            //     },
            //     "actionButtons": [
            //       {
            //         "key": "REDIRECT",
            //         "label": "Redirect",
            //         "autoDismissible": true
            //       },
            //       {
            //         "key": "DISMISS",
            //         "label": "Dismiss",
            //         "actionType": "DismissAction",
            //         "isDangerousOption": true,
            //         "autoDismissible": true
            //       }
            //     ]
            //   }
            // },
            );
        // var decodedResponse =
        //     jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        // var uri = Uri.parse(decodedResponse['uri'] as String);
        // print(await client.get(uri));
        // Logger().i("SUCCESS SENT", response.body);
      } catch (e) {
        print(e.toString());
      }
      // await BaseClient.safeApiCall(
      //   "https://fcm.googleapis.com/fcm/send", // url

      //   RequestType.post, // request type (get,post,delete,put)
      //   headers: {
      //     "Content-Type": "application/json",
      //     "Authorization":
      //         "key=AAAAfQrhkjM:APA91bHmKBqzIalxKtRd2reeJM3HS8Nw7RMgoi4_vYzAbaS6mxN_DvZMQXKatObAtcSZqnl7p-Kg40BbI4MtAlZ-OQEQFtRD2yRkzR5HVdfYOALxQxYIKaeUvf3RbTktyaPyz9nXj-dN",
      //   },
      //   queryParameters: {
      //     "to":
      //         "fMX9QRyFQ-el41U_RLAgOr:APA91bEqaZ-IpyAxuMKWtuZRq3kUXVRl6UcxIPnqUd_C38cJIR2H_rSkWTz7aR1s32whavepEzrj9wgm5DkxSZbGau4-QqPFzcQ5hJVsWCAV-wOUFNP-fFGwSbUtlj4sseHjSnyuxfRQ",
      //     "mutable_content": true,
      //     "priority": "high",
      //     "notification": {
      //       "badge": 50,
      //       "title": "Huston! The eagle has landed!",
      //       "body":
      //           "A small step for a man, but a giant leap to Flutter's community!"
      //     },
      //     "data": {
      //       "content": {
      //         "id": 1,
      //         "badge": 50,
      //         "channelKey": "alerts",
      //         "displayOnForeground": true,
      //         "notificationLayout": "BigPicture",
      //         "largeIcon":
      //             "https://br.web.img3.acsta.net/pictures/19/06/18/17/09/0834720.jpg",
      //         "bigPicture": "https://www.dw.com/image/49519617_303.jpg",
      //         "showWhen": true,
      //         "autoDismissible": true,
      //         "privacy": "Private",
      //         "payload": {"secret": "Awesome Notifications Rocks!"}
      //       },
      //       "actionButtons": [
      //         {"key": "REDIRECT", "label": "Redirect", "autoDismissible": true},
      //         {
      //           "key": "DISMISS",
      //           "label": "Dismiss",
      //           "actionType": "DismissAction",
      //           "isDangerousOption": true,
      //           "autoDismissible": true
      //         }
      //       ]
      //     }
      //   },
      //   onLoading: () {
      //     // popularEventApiCallStatus = ApiCallStatus.loading;
      //     // update();
      //     Logger().i("Loading...");
      //   },
      //   onSuccess: (response) {
      //     Logger().i("Success Sent FCM Notification");
      //   },
      //   // if you don't pass this method base client
      //   // will automaticly handle error and show message to user
      //   onError: (error) {
      //     // Logger().e(error.toString());
      //     Logger().e("Some Error!!!", error.message);
      //   },
      // );
    } catch (e) {
      print(e.toString());
      // Logger().e(e.toString());
    }
  }

  static String constructFCMPayload(String? token) {
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': 10.toString(),
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (10) was created via FCM!',
      },
    });
  }

  static String? getIconLink(String link) {
    String defaultLogoLink =
        "https://doctor-thumbnail.s3.ap-northeast-1.amazonaws.com/assets/images/logo-simple.png";
    if (link.isEmpty) {
      return defaultLogoLink;
    }
    if (link.startsWith("http")) {
      return link;
    }
    if (link.startsWith("assets")) {
      return "https://doctor-thumbnail.s3.ap-northeast-1.amazonaws.com/$link";
    }
    return defaultLogoLink;
  }

  /*********************************************
   * @Desc: Send Push Notification to Multi User
   */

  static String getAvatarLink(String link) {
    const defaultLink =
        "https://doctor-thumbnail.s3.ap-northeast-1.amazonaws.com/assets/images/logo-simple.png";
    if (link.isEmpty) {
      return defaultLink;
    }
    if (link.contains('http')) {
      return link;
    }
    if (link.contains("asset")) {
      return "https://doctor-thumbnail.s3.ap-northeast-1.amazonaws.com/$link";
    }
    return defaultLink;
  }

  ///handle fcm notification when app is closed/terminated
  /// if you are wondering about this annotation read the following
  /// https://stackoverflow.com/a/67083337
  @pragma('vm:entry-point')
  static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    if (Platform.isAndroid) {
      AwesomeNotificationsHelper.showNotification(
        id: 1,
        title: message.notification?.title ?? 'Title',
        body: message.notification?.body ?? 'Body',
        payload: message.data
            .cast(), // pass payload to the notification card so you can use it (when user click on notification)
        largeIcon: getIconLink(message.notification?.android?.smallIcon ?? ""),
        notificationLayout: NotificationLayout.BigPicture,
      );
    }
    if (Platform.isIOS) {
      AwesomeNotificationsHelper.showNotification(
        id: 1,
        title: message.notification?.title ?? 'Title',
        body: message.notification?.body ?? 'Body',
        payload: message.data
            .cast(), // pass payload to the notification card so you can use it (when user click on notification)
        largeIcon: getIconLink(message.notification?.apple?.subtitle ?? ""),
        notificationLayout: NotificationLayout.Default,
      );
    }
  }

  //handle fcm notification when app is open
  static Future<void> _fcmForegroundHandler(RemoteMessage message) async {
    if (Platform.isAndroid) {
      AwesomeNotificationsHelper.showNotification(
        id: 1,
        title: message.notification?.title ?? 'Title',
        body: message.notification?.body ?? 'Body',
        payload: message.data
            .cast(), // pass payload to the notification card so you can use it (when user click on notification)
        largeIcon: getIconLink(message.notification?.android?.smallIcon ?? ""),
        notificationLayout: NotificationLayout.BigPicture,
      );
    }
    if (Platform.isIOS) {
      AwesomeNotificationsHelper.showNotification(
        id: 1,
        title: message.notification?.title ?? 'Title',
        body: message.notification?.body ?? 'Body',
        payload: message.data
            .cast(), // pass payload to the notification card so you can use it (when user click on notification)
        largeIcon: getIconLink(message.notification?.apple?.subtitle ?? ""),
        notificationLayout: NotificationLayout.Default,
      );
    }
  }
}
