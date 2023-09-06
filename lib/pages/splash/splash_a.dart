import 'dart:async';
import 'dart:ui';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/pages/home/main_screen.dart';
import 'package:doceo_new/pages/splash/sel_page.dart';
import 'package:doceo_new/pages/transitionToHome/transition.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class SplashPageA extends StatefulWidget {
  @override
  _SplashPageA createState() => new _SplashPageA();
}

class _SplashPageA extends State<SplashPageA> {
  String error = '';
  bool status = false;

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 4), () async {
      try {
        final userData = await Amplify.Auth.fetchUserAttributes();
        Map userInfo = {};
        for (final element in userData) {
          userInfo.addAll({"${element.userAttributeKey.key}": element.value});
        }
        AuthenticateProviderPage.of(context, listen: false).isAuthenticated =
            true;
        AuthenticateProviderPage.of(context, listen: false).user = userInfo;

        String userId = userInfo['sub'];
        String graphQLDocument = '''query createUserToken {
                CreateUserToken(id: "$userId"){
                  token
                  rooms{
                    channel{
                      id
                      name
                      description
                      image
                    }
                    members{
                      role
                      user_id
                      user{
                        role
                        image
                        firstName
                        lastName
                      }
                    }
                  }
                }
              }''';

        var operation = Amplify.API
            .query(request: GraphQLRequest<String>(document: graphQLDocument));

        var response = await operation.response;

        var res = json.decode(response.data.toString());
        if (res['CreateUserToken']['token'].toString().isNotEmpty) {
          AuthenticateProviderPage.of(context, listen: false).getStreamToken =
              res['CreateUserToken']['token'].toString();
          AppProviderPage.of(context, listen: false).rooms =
              res['CreateUserToken']['rooms'];
          int userNum = 0;
          List roomSigned = [];
          // String roomNumber = '';

          for (var item in res['CreateUserToken']['rooms']) {
            userNum =
                item['members'].where((e) => e['user_id'] == userId).length;
            if (userNum > 0) {
              // roomNumber =
              //     (roomNumber == '' ? item['channel']['id'] : roomNumber);
              roomSigned.add({'status': true});
            } else {
              roomSigned.add({'status': false});
            }
            userNum = 0;
          }
          AppProviderPage.of(context, listen: false).roomSigned = roomSigned;

          final client = StreamChat.of(context).client;
          await client.disconnectUser();
          final userRes = await client.connectUser(
            User(id: userId),
            AuthenticateProviderPage.of(context, listen: false).getStreamToken,
          );
          if (MainScreen.targetChannel.isNotEmpty) {
            final channel = await client.queryChannel(
                MainScreen.targetChannelType,
                channelId: MainScreen.targetChannel);

            AppProviderPage.of(context).selectedRoom =
                channel.channel!.extraData['room'].toString();
          }
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TransitionPage()));
        }
      } catch (e) {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => SelPage(),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => SelPage()));
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: Scaffold(
          body: Center(
              child: Image(
            image: AssetImage('assets/images/splash.gif'),
            fit: BoxFit.cover,
          )),
        ),
        onWillPop: () => Future.value(false));
  }
}
