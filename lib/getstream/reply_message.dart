import 'dart:math';

import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/pages/channels/type_2/channel_2_1_reply.dart';
import 'package:doceo_new/pages/channels/type_3/channel_3_1_reply.dart';
import 'package:doceo_new/styles/colors.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CustomReplyMessage extends StatefulWidget {
  final Message message;
  final Channel channel;

  const CustomReplyMessage(
      {super.key, required this.message, required this.channel});
  @override
  State<CustomReplyMessage> createState() => _CustomReplyMessageState();
}

class _CustomReplyMessageState extends State<CustomReplyMessage> {
  List<User> participants = [];
  bool expanded = false;
  @override
  void initState() {
    participants = widget.message.threadParticipants ?? [];
    if (widget.channel.type == 'channel-2') {
      participants =
          participants.where((user) => user.role == 'doctor').toList();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        goDetailChannel(widget.message);
      },
      child: Column(
        children: [
          Row(
            children: [
              Stack(children: [
                SizedBox(
                  width: 12 * participants.length + 8.toDouble(),
                  height: 20,
                ),
                for (int i = 0; i < participants.length; i++)
                  Positioned(
                      left: 12.0 * i,
                      width: 20,
                      height: 20,
                      child: UtilHelper.userAvatar(participants[i], 10))
              ]),
              widget.channel.type == 'channel-2'
                  ? Text('${participants.length}名の医師',
                      style: AppStyles.date.copyWith(
                          color: const Color(0xff7A96DE),
                          fontWeight: FontWeight.w800,
                          fontSize: 15))
                  : const SizedBox(),
              Expanded(
                flex: 5,
                child: Text(
                    widget.channel.type == 'channel-2' ? 'が回答しました' : 'が返信しました',
                    style: AppStyles.date.copyWith(fontSize: 15)),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    SvgPicture.asset('assets/images/comment-icon.svg',
                        width: 19, height: 18),
                    Container(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(widget.message.replyCount.toString(),
                          style: TextStyle(
                              color: AppColors.subText,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void goDetailChannel(Message message) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => widget.channel.type == 'channel-2'
                ? StreamChannel(
                    channel: widget.channel,
                    child: Type2Channel2ReplyPage(
                      parent: message,
                    ))
                : StreamChannel(
                    channel: widget.channel,
                    child: Type3Channel1ReplyPage(
                      parent: message,
                    ))));
  }
}
