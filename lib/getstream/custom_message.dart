import 'package:doceo_new/getstream/custom_image_attachment.dart';
import 'package:doceo_new/getstream/custom_message_actions.dart';
import 'package:doceo_new/helper/fcm_helper.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/helper/video_player.dart';
import 'package:doceo_new/pages/channels/type_2/channel_2_1_reply.dart';
import 'package:doceo_new/pages/channels/type_3/channel_3_1_reply.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:doceo_new/getstream/custom_reaction_icon.dart';
import 'package:doceo_new/getstream/reply_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

class CustomMessage extends StatefulWidget {
  BuildContext context;
  MessageDetails details;
  List<Message> messages;
  StreamMessageWidget defaultMessageWidget;

  CustomMessage(
      {super.key,
      required this.context,
      required this.details,
      required this.messages,
      required this.defaultMessageWidget});
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  _CustomMessage createState() => _CustomMessage();
}

class _CustomMessage extends State<CustomMessage> {
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.details.message;
    final channel = StreamChannel.of(widget.context).channel;
    final themeData = StreamChatTheme.of(widget.context).otherMessageTheme;

    return Container(
        color: isEdit
            ? const Color.fromRGBO(139, 170, 255, .13)
            : Colors.transparent,
        child: ListTile(
          contentPadding:
              const EdgeInsets.only(left: 18, top: 16, right: 15, bottom: 30),
          leading: (message.user!.image != null)
              ? CircleAvatar(
                  radius: 21,
                  backgroundImage: AssetImage(message.user!.image.toString()),
                  backgroundColor: Colors.transparent,
                )
              : const CircleAvatar(
                  radius: 21,
                  backgroundImage: AssetImage('assets/images/splash_1.png'),
                  backgroundColor: Colors.transparent,
                ),
          title: Stack(clipBehavior: Clip.none, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  padding: const EdgeInsets.all(10),
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
                                    message.user!, channel.type),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'M_PLUS',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Text(UtilHelper.formatDate(message.createdAt),
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
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: !message.isDeleted
                                    ? [
                                        (message.text != null &&
                                                message.text!.isNotEmpty)
                                            ? Text(message.text!,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'M_PLUS',
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.normal))
                                            : const SizedBox(),
                                        (message.attachments.isNotEmpty
                                            ? (message.attachments[0].type ==
                                                    "image")
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child:
                                                        CustomImageAttachment(
                                                      message: message,
                                                      attachment: message
                                                          .attachments[0],
                                                      messageTheme: themeData,
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxHeight: 400),
                                                    ))
                                                : (message.attachments[0]
                                                            .type ==
                                                        "video")
                                                    ? StreamVideoAttachment(
                                                        message: message,
                                                        attachment: message
                                                            .attachments[0],
                                                        messageTheme: themeData,
                                                        constraints:
                                                            const BoxConstraints(
                                                                maxHeight: 400),
                                                      )
                                                    // VideoPlayerPage(
                                                    //     attachment: message
                                                    //         .attachments[0],
                                                    //     videoPlayerController: message
                                                    //                 .attachments[
                                                    //                     0]
                                                    //                 .assetUrl !=
                                                    //             null
                                                    //         ? VideoPlayerController.network(
                                                    //             message
                                                    //                 .attachments[
                                                    //                     0]
                                                    //                 .assetUrl
                                                    //                 .toString(),
                                                    //             videoPlayerOptions:
                                                    //                 VideoPlayerOptions())
                                                    //         : VideoPlayerController
                                                    //             .contentUri(message
                                                    //                 .attachments[
                                                    //                     0]
                                                    //                 .localUri!),
                                                    //     looping: false,
                                                    //     autoplay: false,
                                                    //   )
                                                    : (message.attachments[0]
                                                                .type ==
                                                            "file")
                                                        ? StreamFileAttachment(
                                                            message: message,
                                                            attachment: message
                                                                .attachments[0],
                                                            constraints:
                                                                BoxConstraints
                                                                    .expand(
                                                                        height:
                                                                            50),
                                                          )
                                                        : Text(message
                                                            .attachments[0]
                                                            .title
                                                            .toString())
                                            : Container())
                                      ]
                                    : [
                                        const Text('The message was deleted',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal))
                                      ]))
                      ])),
              if (!message.isDeleted)
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (StreamChannel.of(context).channel.type == 'channel-2')
                        Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            decoration: const BoxDecoration(
                                color: Color(0xffF8F8F8),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 21),
                            child: InkWell(
                                onTap: () {
                                  final channel =
                                      StreamChannel.of(context).channel;
                                  final currentUser =
                                      StreamChat.of(context).currentUser;
                                  RenderBox renderBox =
                                      (widget.key as GlobalKey)
                                          .currentContext!
                                          .findRenderObject() as RenderBox;
                                  final offset =
                                      renderBox.localToGlobal(Offset.zero);
                                  UtilHelper
                                      .showMessageReactionsModalBottomSheet(
                                          context, message, [
                                    offset.dy,
                                    offset.dy + renderBox.size.height
                                  ]);
                                },
                                child: SvgPicture.asset(
                                  'assets/images/reaction-icon.svg',
                                  fit: BoxFit.contain,
                                  width: 24,
                                  height: 24,
                                ))),
                      UtilHelper.buildReactionsList(context, message)
                    ])
              // UtilHelper.buildReactionsList(context, message)
            ]),
            (message.replyCount! > 0)
                ? Positioned(
                    top: 54,
                    left: -38,
                    bottom: -32,
                    width: 40,
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                        bottom: BorderSide(width: 2, color: Color(0xffd9d9d9)),
                        left: BorderSide(width: 2, color: Color(0xffd9d9d9)),
                      )),
                    ))
                : const SizedBox.shrink()
          ]),
          subtitle: !message.isDeleted
              ? Container(
                  child: (message.replyCount! > 0)
                      ? Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 10, top: 10),
                          decoration: const BoxDecoration(
                              color: Color(0xffF8F8F8),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: CustomReplyMessage(
                              message: message, channel: channel),
                        )
                      : const SizedBox.shrink(),
                )
              : Container(),
          onLongPress: () async {
            final channel = StreamChannel.of(widget.context).channel;
            if (channel.type == 'channel-2') {
              return;
            }
            final currentUser = StreamChat.of(context).currentUser;
            RenderBox renderBox = (widget.key as GlobalKey)
                .currentContext!
                .findRenderObject() as RenderBox;
            final offset = renderBox.localToGlobal(Offset.zero);

            showDialog(
              useRootNavigator: false,
              context: widget.context,
              barrierColor: const Color.fromRGBO(0, 0, 0, 0.33),
              builder: (context) => StreamChannel(
                channel: channel,
                child: CustomMessageActionsModal(
                    onCopyTap: (message) =>
                        Clipboard.setData(ClipboardData(text: message.text)),
                    message: message,
                    onEditTap: (message) {
                      setState(() {
                        isEdit = true;
                      });
                    },
                    onEdited: (message) {
                      setState(() {
                        isEdit = false;
                      });
                    },
                    onThreadReplyTap: (message) {
                      replyMsg(message);
                    },
                    showCopyMessage: message.text?.trim().isNotEmpty == true,
                    showReplyMessage: false,
                    showThreadReplyMessage: channel.type == 'channel-3' &&
                        currentUser!.id != message.user!.id,
                    showDeleteMessage: currentUser!.id == message.user!.id &&
                        !message.isDeleted,
                    showEditMessage: currentUser.id == message.user!.id &&
                        !message.attachments
                            .any((element) => element.type == 'giphy'),
                    showWatchButton: true,
                    pos: [offset.dy, offset.dy + renderBox.size.height]),
              ),
            );
          },
        ));
  }

  void replyMsg(Message message) async {
    final channel = StreamChannel.of(context).channel;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StreamChannel(
                channel: channel,
                child: channel.type == 'channel-2'
                    ? Type2Channel2ReplyPage(
                        parent: message,
                      )
                    : Type3Channel1ReplyPage(
                        parent: message,
                      ))));
  }
}
