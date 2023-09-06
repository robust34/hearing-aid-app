import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_push_notifications_pinpoint/amplify_push_notifications_pinpoint.dart';
import 'package:doceo_new/amplifyconfiguration.dart';
import 'package:doceo_new/models/ModelProvider.dart';
import 'package:doceo_new/pages/auth/signin_page.dart';
import 'package:doceo_new/pages/home/main_screen.dart';
import 'package:doceo_new/pages/myPage/my_page_screen.dart';
import 'package:doceo_new/pages/splash/splash_a.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:flutter/material.dart' as Material;
import 'package:stream_chat_localizations/stream_chat_localizations.dart';

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  MyApp({
    Key? key,
    required this.client,
  }) : super(key: key);
  final StreamChatClient client;

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  final StreamChatConfigurationData streamChatConfigData =
      StreamChatConfigurationData(reactionIcons: [
    StreamReactionIcon(
      type: 'okay',
      builder: (context, highlighted, size) {
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/images/emo_1.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        );
      },
    ),
    StreamReactionIcon(
      type: 'sad',
      builder: (context, highlighted, size) {
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/images/emo_2.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        );
      },
    ),
    StreamReactionIcon(
      type: 'think',
      builder: (context, highlighted, size) {
        return SizedBox(
          width: size,
          child: SvgPicture.asset(
            'assets/images/emo_3.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        );
      },
    ),
    StreamReactionIcon(
      type: 'good',
      builder: (context, highlighted, size) {
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/images/emo_4.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        );
      },
    ),
    StreamReactionIcon(
      type: 'thanks',
      builder: (context, highlighted, size) {
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/images/emo_5.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        );
      },
    ),
  ]);

  @override
  void initState() {
    super.initState();
    configureAmplify();
    AppStyles.loadSelectedIndex();
  }

  @override
  void dispose() {
    // _authProvider.dispose();
    super.dispose();
  }

  Future<void> configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      final api = AmplifyAPI(modelProvider: ModelProvider.instance);
      final push = AmplifyPushNotificationsPinpoint();
      // await Amplify.addPlugin(auth);
      // await Amplify.addPlugin(analyticsPlugin);

      await Amplify.addPlugins([auth, api, push]);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
      // Amplify.Notifications.Push.onTokenReceived.listen((event) {
      //   print('Amplify token: ${event}');
      // });
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider<AppService>(create: (_) => appService),
        ChangeNotifierProvider(
          create: (_) => AuthenticateProviderPage(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppProviderPage(),
        ),
        // Provider<AuthService>(create: (_) => authService),
      ],
      child: Builder(
        builder: (context) {
          // final _authProvider = AuthenticateProviderPage();
          // final _router = routerGenerator(_authProvider);

          return MaterialApp(
              supportedLocales: const [
                Locale('en'),
                Locale('hi'),
                Locale('fr'),
                Locale('it'),
                Locale('es'),
                Locale('ca'),
                Locale('ja'),
                Locale('ko'),
                Locale('pt'),
                Locale('de'),
                Locale('no')
              ],
              localizationsDelegates: GlobalStreamChatLocalizations.delegates,
              navigatorKey: MyApp.navigatorKey,
              builder: (context, child) {
                return StreamChat(
                  client: widget.client,
                  child: child,
                  // streamChatThemeData: widget.streamChatThemeData,
                  streamChatConfigData: streamChatConfigData,
                );
              },
              home: SplashPageA());
          // SignInPage());
          // MyPageScreen());
        },
      ),
    );
  }
}
