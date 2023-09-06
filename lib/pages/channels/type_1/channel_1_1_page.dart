// ignore_for_file: avoid_print

import 'package:doceo_new/getstream/custom_date_divider.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/pages/home/home_page.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class Type1Channel1Page extends StatefulWidget {
  const Type1Channel1Page({super.key});

  @override
  _Type1Channel1Page createState() => _Type1Channel1Page();
}

class _Type1Channel1Page extends State<Type1Channel1Page> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemScrollController = ItemScrollController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [Container()],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/main-channel-title.svg',
              ),
              const SizedBox(width: 12),
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenWidth * 0.3),
                  child: Text('${StreamChannel.of(context).channel.name}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'M_PLUS',
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 6),
              const Text(
                '( ',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'M_PLUS',
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              SvgPicture.asset(
                'assets/images/management-icon.svg',
                fit: BoxFit.contain,
              ),
              const Text(' → ',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'M_PLUS',
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
              SvgPicture.asset('assets/images/user-icon.svg'),
              const Text(' )',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'M_PLUS',
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 5)
            ],
          ),
        ),
        centerTitle: true,
        // showTypingIndicator: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: StreamMessageListView(
            scrollController: itemScrollController,
            showFloatingDateDivider: false,
            dateDividerBuilder: (date) {
              return CustomDateDivider(dateTime: date);
            },
            scrollPhysics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            emptyBuilder: _emptyBuilder,
            messageBuilder: _messageBuilder,
          )),
        ],
      ),
    );
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
              child: const Text('ここでは運営からのROOMの参加者の皆さんに大事なことをお知らせします',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xffcbcbcb),
                      fontFamily: 'M_PLUS',
                      fontSize: 15,
                      fontWeight: FontWeight.w500)))
        ]));
  }

  Widget _messageBuilder(
    BuildContext context,
    MessageDetails details,
    List<Message> messages,
    StreamMessageWidget defaultMessageWidget,
  ) {
    return Channel1CustomMessage(
        key: GlobalKey(),
        context: context,
        details: details,
        messages: messages,
        defaultMessageWidget: defaultMessageWidget);
  }
}

class Channel1CustomMessage extends StatefulWidget {
  BuildContext context;
  MessageDetails details;
  List<Message> messages;
  StreamMessageWidget defaultMessageWidget;

  Channel1CustomMessage(
      {super.key,
      required this.context,
      required this.details,
      required this.messages,
      required this.defaultMessageWidget});
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  _Channel1CustomMessage createState() => _Channel1CustomMessage();
}

class _Channel1CustomMessage extends State<Channel1CustomMessage> {
  @override
  Widget build(BuildContext build) {
    final message = widget.details.message;
    var isDoctorMessage = message.user?.role == 'doctor';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: ListTile(
          leading: isDoctorMessage
              ? UtilHelper.userAvatar(message.user!, 21)
              : const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/splash_1.png'),
                  backgroundColor: Colors.transparent,
                  radius: 21,
                ),
          title: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
                color: Color(0xffF8F8F8),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    isDoctorMessage
                        ? UtilHelper.getDisplayName(
                            message.user as User, 'channel-2')
                        : '運営',
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.title,
                  ),
                ),
                const SizedBox(width: 8),
                Text(UtilHelper.formatDate(message.createdAt),
                    style: AppStyles.date),
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                margin: const EdgeInsets.only(bottom: 7),
                decoration: const BoxDecoration(
                    color: Color(0xffF8F8F8),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Text(message.text!,
                    textAlign: TextAlign.left, style: AppStyles.content),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      decoration: const BoxDecoration(
                          color: Color(0xffF8F8F8),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 21),
                      child: InkWell(
                          onTap: () {
                            final channel = StreamChannel.of(context).channel;
                            final currentUser =
                                StreamChat.of(context).currentUser;
                            RenderBox renderBox = (widget.key as GlobalKey)
                                .currentContext!
                                .findRenderObject() as RenderBox;
                            final offset = renderBox.localToGlobal(Offset.zero);
                            UtilHelper.showMessageReactionsModalBottomSheet(
                                context,
                                message,
                                [offset.dy, offset.dy + renderBox.size.height]);
                          },
                          child: SvgPicture.asset(
                            'assets/images/reaction-icon.svg',
                            fit: BoxFit.contain,
                            width: 24,
                            height: 24,
                          ))),
                  UtilHelper.buildReactionsList(context, message)
                ],
              )
            ],
          ),
          onLongPress: () => {}),
    );
  }
}
