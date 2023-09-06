import 'package:doceo_new/getstream/reply_message.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CustomSearchMessage extends StatefulWidget {
  final Message message;
  final ChannelModel channel;

  const CustomSearchMessage(
      {super.key, required this.message, required this.channel});

  @override
  State<CustomSearchMessage> createState() => _CustomSearchMessage();
}

class _CustomSearchMessage extends State<CustomSearchMessage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final client = StreamChat.of(context).client;

    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: Color(0xff4f5660), width: 0.1))),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                      width: screenWidth,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/images/main-channel-title.svg',
                          ),
                          const SizedBox(width: 24),
                          ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: screenWidth * 0.5),
                              child: Text(widget.channel.name,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'M_PLUS',
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis)),
                          // ])),
                          const SizedBox(width: 12),
                          const Text(
                            '( ',
                            style: TextStyle(
                                color: Color(0xff4F5660),
                                fontFamily: 'M_PLUS',
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          SvgPicture.asset(
                            'assets/images/user-icon.svg',
                            fit: BoxFit.contain,
                          ),
                          const Text(' ⇄ ',
                              style: TextStyle(
                                  color: Color(0xff4F5660),
                                  fontFamily: 'M_PLUS',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                          if (widget.channel.type == 'channel-2')
                            SvgPicture.asset('assets/images/doctor-icon.svg')
                          else
                            SvgPicture.asset('assets/images/user-icon.svg'),
                          const Text(' )',
                              style: TextStyle(
                                  color: Color(0xff4F5660),
                                  fontFamily: 'M_PLUS',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )))),
          ListTile(
              contentPadding: const EdgeInsets.only(
                  left: 18, top: 16, right: 15, bottom: 30),
              leading: UtilHelper.userAvatar(widget.message.user!, 21),
              title: Stack(clipBehavior: Clip.none, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Color(0xffF8F8F8),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    UtilHelper.getDisplayName(
                                        widget.message.user!,
                                        widget.channel.type),
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'M_PLUS',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                Text(
                                    UtilHelper.formatDate(
                                        widget.message.createdAt),
                                    style: const TextStyle(
                                        fontFamily: 'M_PLUS',
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal)),
                              ],
                            ),
                            Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: (widget.message.text!.isNotEmpty)
                                    ? Text(widget.message.text!,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'M_PLUS',
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal))
                                    : (widget.message.attachments[0].type ==
                                            "image")
                                        ? Image.network(widget
                                            .message.attachments[0].imageUrl
                                            .toString())
                                        : Text(widget
                                            .message.attachments[0].title
                                            .toString()))
                          ])),
                  UtilHelper.buildReactionsList(context, widget.message)
                ]),
                (widget.message.replyCount! > 0)
                    ? Positioned(
                        top: 54,
                        left: -38,
                        bottom: -32,
                        width: 40,
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                            bottom:
                                BorderSide(width: 2, color: Color(0xffd9d9d9)),
                            left:
                                BorderSide(width: 2, color: Color(0xffd9d9d9)),
                          )),
                        ))
                    : const SizedBox.shrink()
              ]),
              subtitle: Container(
                child: (widget.message.replyCount! > 0)
                    ? Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, bottom: 10, top: 10),
                        decoration: const BoxDecoration(
                            color: Color(0xffF8F8F8),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: CustomReplyMessage(
                            message: widget.message,
                            channel: client.channel(widget.channel.type,
                                id: widget.channel.id)),
                      )
                    : const SizedBox.shrink(),
              ))
        ]));
  }
}
