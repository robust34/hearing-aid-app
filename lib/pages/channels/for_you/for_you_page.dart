import 'dart:math';

import 'package:doceo_new/getstream/custom_search_message.dart';
import 'package:doceo_new/getstream/reply_message.dart';
import 'package:doceo_new/pages/channels/type_1/channel_1_1_page.dart';
import 'package:doceo_new/pages/channels/type_2/channel_2_1_page.dart';
import 'package:doceo_new/pages/channels/type_3/channel_3_1_page.dart';
import 'package:doceo_new/pages/home/home_page.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ForYouPage extends StatefulWidget {
  @override
  _ForYouPage createState() => _ForYouPage();
}

class _ForYouPage extends State<ForYouPage> {
  @override
  void initState() {
    super.initState();
    markReadUnreadChannels();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: const Text(
            'For you',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
            textAlign: TextAlign.center,
          ),
          // actions: [],
          centerTitle: true,
        ),
        body: Container(
          color: const Color(0xfff8f8f8),
          child: StreamMessageSearchListView(
            controller: StreamMessageSearchListController(
                client: StreamChat.of(context).client,
                filter: Filter.and([
                  Filter.in_(
                    'type',
                    const ['channel-2', 'channel-3'],
                  ),
                  Filter.equal('room', AppProviderPage.of(context).selectedRoom)
                ]),
                messageFilter: Filter.and([
                  Filter.equal(
                      'user.id', StreamChat.of(context).currentUser!.id),
                  // Filter.greater('reply_count', 0)
                ]),
                sort: const [
                  SortOption('created_at', direction: SortOption.DESC)
                ]),
            emptyBuilder: _emptyBuilder,
            separatorBuilder: (context, responses, index) {
              return SizedBox(
                  height: responses[index].message.replyCount! > 0 ? 21 : 0);
            },
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (context, response, index, titleWidget) {
              return response[index].message.replyCount! > 0
                  ? CustomSearchMessage(
                      message: response[index].message,
                      channel: response[index].channel!)
                  : const SizedBox();
            },
          ),
        ));
  }

  Widget _emptyBuilder(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          SvgPicture.asset(
            'assets/images/empty-channel.svg',
            fit: BoxFit.contain,
          ),
          Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.only(left: 65, right: 65),
              child: const Text('ここにはあなたが投稿した質問やコメントへの返信が表示されます',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xffcbcbcb),
                      fontFamily: 'M_PLUS',
                      fontSize: 15,
                      fontWeight: FontWeight.w500)))
        ]));
  }

  void markReadUnreadChannels() {
    final room = AppProviderPage.of(context).selectedRoom;
    final unreadMessages = AppProviderPage.of(context).unreadMessages;
    unreadMessages[room] = [];
  }
}
