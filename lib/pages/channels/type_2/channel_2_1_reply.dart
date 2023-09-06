// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math';

import 'package:doceo_new/getstream/custom_comment_message.dart';
import 'package:doceo_new/getstream/custom_date_divider.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/helper/video_player.dart';
import 'package:doceo_new/pages/channels/type_2/channel_2_1_page.dart';
import 'package:doceo_new/pages/channels/type_2/gift_modal.dart';
import 'package:doceo_new/pages/myPage/point_charge_modal.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:doceo_new/styles/colors.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/src/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:toast/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class Type2Channel2ReplyPage extends StatefulWidget {
  final Message parent;
  const Type2Channel2ReplyPage({super.key, required this.parent});

  @override
  _Type2Channel2ReplyPage createState() => _Type2Channel2ReplyPage();
}

class _Type2Channel2ReplyPage extends State<Type2Channel2ReplyPage> {
  List<User> participants = [];

  @override
  void initState() {
    super.initState();
    // allrepliesMessages = widget.repliesMsg;
    // expanded = widget.repliesMsg.map((e) => e.text!.length < 26).toList();
    print('Participants: ${widget.parent.threadParticipants}');
    participants = (widget.parent.threadParticipants ?? [])
        .where((user) => user.role == 'doctor')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;

    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [Container()],
            leading: IconButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            title: SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        widget.parent.text!.isNotEmpty
                            ? (widget.parent.text!.toString().length > 14
                                ? '${widget.parent.text!.toString().substring(0, 14)}...'
                                : widget.parent.text!.toString())
                            : widget.parent.attachments[0].title.toString(),
                        style: TextStyle(
                            color: AppColors.mainText,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/main-channel-title.svg',
                          width: 10,
                          height: 10,
                          color: AppColors.subText,
                        ),
                        const SizedBox(width: 6),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.4),
                          child: Text(
                            '${channel.name} / ',
                            style: TextStyle(
                              fontFamily: 'M_PLUS',
                              color: AppColors.subText,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/images/doctor-icon.svg',
                          fit: BoxFit.contain,
                        ),
                        Text(' ⇄ ',
                            style: TextStyle(
                                color: AppColors.subText,
                                fontFamily: 'M_PLUS',
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                        SvgPicture.asset('assets/images/user-icon.svg'),
                      ],
                    )
                  ],
                )),
            centerTitle: true,
          ),
          body: Container(
              // padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: StreamMessageListView(
                      footerBuilder: (context) => Container(),
                      threadSeparatorBuilder: (context, message) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 0),
                          child: Row(children: const [
                            Expanded(
                                child: Divider(
                              color: Color(0xff4F5660),
                              height: 1,
                            )),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'reply',
                              style: TextStyle(
                                  color: Color(0xff4F5660),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: Divider(
                              color: Color(0xff4F5660),
                              height: 1,
                            )),
                          ]),
                        );
                      },
                      parentMessageBuilder: (context, message, messageWidget) {
                        return Column(children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              UtilHelper.userAvatar(widget.parent.user!, 30),
                              const Icon(
                                Icons.arrow_left,
                                size: 40,
                              ),
                              Stack(children: [
                                SizedBox(
                                  width: 38 * participants.length + 22.0,
                                  height: 60,
                                ),
                                for (int i = 0; i < participants.length; i++)
                                  Positioned(
                                      left: 38.0 * i,
                                      width: 60,
                                      height: 60,
                                      child: UtilHelper.userAvatar(
                                          participants[i], 30))
                              ]),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    UtilHelper.getDisplayName(
                                        widget.parent.user!, 'channel-2'),
                                    style: AppStyles.title,
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    UtilHelper.formatDate(
                                        widget.parent.createdAt),
                                    style: AppStyles.date,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      widget.parent.text != null &&
                                              widget.parent.text!.isNotEmpty
                                          ? Text(
                                              textAlign: TextAlign.start,
                                              widget.parent.text.toString(),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'M_PLUS',
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          : Container(),
                                      widget.parent.attachments.isNotEmpty
                                          ? (widget.parent.attachments[0]
                                                      .type ==
                                                  "image")
                                              ? Image.network(widget.parent
                                                  .attachments[0].imageUrl
                                                  .toString())
                                              : (widget.parent.attachments[0]
                                                          .type ==
                                                      'video')
                                                  ? VideoPlayerPage(
                                                      attachment: widget.parent
                                                          .attachments[0],
                                                      videoPlayerController:
                                                          VideoPlayerController.network(
                                                              widget
                                                                      .parent
                                                                      .attachments[
                                                                          0]
                                                                      .assetUrl ??
                                                                  widget
                                                                      .parent
                                                                      .attachments[
                                                                          0]
                                                                      .localUri
                                                                      .toString(),
                                                              videoPlayerOptions:
                                                                  VideoPlayerOptions()),
                                                      looping: false,
                                                      autoplay: false,
                                                    )
                                                  : Text(widget.parent
                                                      .attachments[0].title
                                                      .toString())
                                          : Container()
                                    ]),
                              ),
                              UtilHelper.buildReactionsList(
                                  context, widget.parent)
                            ],
                          ),
                        ]);
                      },
                      reverse: true,
                      showFloatingDateDivider: false,
                      dateDividerBuilder: (date) {
                        return CustomDateDivider(dateTime: date);
                      },
                      parentMessage: widget.parent,
                      scrollPhysics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      messageBuilder: _replyMessage),
                ),
              ),
              StreamMessageInput(
                attachmentLimit: 1,
                hideSendAsDm: true,
                showCommandsButton: false,
                messageInputController: StreamMessageInputController(
                  message: Message(parentId: widget.parent.id),
                ),
                // attachmentsPickerBuilder:
                //     (context, messageInputController, defaultPicker) {
                //   return defaultPicker.copyWith(allowedAttachmentTypes: [
                //     DefaultAttachmentTypes.image,
                //     DefaultAttachmentTypes.video
                //   ]);
                // },
              )
            ],
          )),
          // bottomSheet: ,
        ),
        onWillPop: () => Future.value(false));
  }

  Widget _replyMessage(
    BuildContext context,
    MessageDetails details,
    List<Message> messages,
    StreamMessageWidget defaultMessageWidget,
  ) {
    print('Messages: ${messages}');

    return CustomCommentMessage(
      key: GlobalKey(),
      context: context,
      details: details,
      messages: messages,
      defaultMessageWidget: defaultMessageWidget,
      channelType: 'channel-2',
    );
  }
}
