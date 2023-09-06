import 'package:doceo_new/getstream/custom_image_attachment.dart';
import 'package:doceo_new/getstream/custom_message_actions.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/helper/video_player.dart';
import 'package:doceo_new/pages/channels/type_2/gift_modal.dart';
import 'package:doceo_new/styles/colors.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

class CustomCommentMessage extends StatefulWidget {
  final BuildContext context;
  final MessageDetails details;
  final List<Message> messages;
  final StreamMessageWidget defaultMessageWidget;
  final String channelType;

  const CustomCommentMessage(
      {super.key,
      required this.context,
      required this.details,
      required this.messages,
      required this.defaultMessageWidget,
      required this.channelType});
  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  _CustomCommentMessage createState() => _CustomCommentMessage();
}

class _CustomCommentMessage extends State<CustomCommentMessage> {
  bool isEdit = false;
  late bool expanded = widget.details.message.text.toString().length <= 26;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.details.message;
    final theme = StreamChatTheme.of(context).otherMessageTheme;
    var isVideoReply = item.attachments.any((e) => e.type == 'video');

    return Container(
      color: isEdit
          ? const Color.fromRGBO(139, 170, 255, .13)
          : Colors.transparent,
      child: ListTile(
          contentPadding: EdgeInsets.zero,
          style: ListTileStyle.drawer,
          leading: UtilHelper.userAvatar(item.user!, 21),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color:
                        isEdit ? Colors.transparent : const Color(0xfff8f8f8),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                              child: Text(
                                  UtilHelper.getDisplayName(
                                      item.user!, widget.channelType),
                                  textAlign: TextAlign.left,
                                  style: AppStyles.title.copyWith(
                                      color: item.user!.role == 'doctor'
                                          ? const Color(0xff7A96DE)
                                          : AppColors.mainText))),
                          const SizedBox(width: 8),
                          Text(UtilHelper.formatDate(item.createdAt),
                              style: AppStyles.date),
                        ],
                      ),
                      item.text != null && item.text.toString() != ''
                          ? Container(
                              child: expanded
                                  ? Text(
                                      '${item.user!.role == 'doctor' && isVideoReply ? '（自動字幕） ' : ''}${item.text.toString()}',
                                      textAlign: TextAlign.left,
                                      style: AppStyles.content,
                                    )
                                  : RichText(
                                      text: TextSpan(
                                          text:
                                              '${item.user!.role == 'doctor' && isVideoReply ? '（自動字幕） ' : ''}${item.text.toString().substring(0, 26)}...',
                                          style: AppStyles.content,
                                          children: [
                                          WidgetSpan(
                                              baseline:
                                                  TextBaseline.ideographic,
                                              alignment:
                                                  PlaceholderAlignment.middle,
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0)),
                                                child: Text(
                                                  'さらに表示',
                                                  style: AppStyles.content
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    expanded = true;
                                                  });
                                                },
                                              ))
                                        ])),
                            )
                          : Container(),
                    ]),
              ),
              // Container(
              //     margin: const EdgeInsets.only(top: 14),
              //     child: UtilHelper.buildReactionsList(context, item)),
              (item.attachments.isNotEmpty)
                  ? Container(
                      margin: const EdgeInsets.only(top: 14),
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        color: Color(0xffF8F8F8),
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                      child: (item.attachments.isNotEmpty &&
                              item.attachments[0].type == 'video')
                          ? VideoPlayerPage(
                              attachment: item.attachments[0],
                              videoPlayerController:
                                  VideoPlayerController.network(
                                      item.attachments[0].assetUrl ??
                                          item.attachments[0].localUri
                                              .toString(),
                                      videoPlayerOptions: VideoPlayerOptions()),
                              looping: false,
                              autoplay: false,
                            )
                          : (item.attachments[0].type == 'image')
                              ? CustomImageAttachment(
                                  message: item,
                                  attachment: item.attachments[0],
                                  messageTheme: theme,
                                  constraints:
                                      const BoxConstraints(maxHeight: 400),
                                )
                              : (item.attachments[0].type == "file")
                                  ? StreamFileAttachment(
                                      message: item,
                                      attachment: item.attachments[0],
                                      constraints:
                                          BoxConstraints.expand(height: 50),
                                    )
                                  : Text(item.attachments[0].title.toString()),
                    )
                  : Container(),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UtilHelper.buildReactionsList(context, item),
                  // Container(
                  //   decoration: const BoxDecoration(
                  //       color: Color(0xffF8F8F8),
                  //       borderRadius: BorderRadius.all(Radius.circular(5))),
                  //   padding: const EdgeInsets.symmetric(
                  //       vertical: 2, horizontal: 21),
                  //   child: InkWell(
                  //       onTap: () {
                  //         RenderBox renderBox = (widget.key as GlobalKey)
                  //             .currentContext!
                  //             .findRenderObject() as RenderBox;
                  //         final offset =
                  //             renderBox.localToGlobal(Offset.zero);
                  //         UtilHelper.showMessageReactionsModalBottomSheet(
                  //             context, item, [
                  //           offset.dy,
                  //           offset.dy + renderBox.size.height
                  //         ]);
                  //       },
                  //       child: SvgPicture.asset(
                  //         'assets/images/reaction-icon.svg',
                  //         fit: BoxFit.contain,
                  //         width: 24,
                  //         height: 24,
                  //       )),
                  // ),
                  item.user!.role == 'doctor'
                      ? Container(
                          decoration: const BoxDecoration(
                              color: Color(0xffF8F8F8),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 15),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                useRootNavigator: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                isScrollControlled: true,
                                builder: ((context) {
                                  return GiftModal(msg: item);
                                }),
                              );
                            },
                            child: Row(children: [
                              SvgPicture.asset(
                                'assets/images/gift.svg',
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                              item.extraData['gifts'] != null
                                  ? Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        item.extraData['gifts'].toString(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Color(0xff777777),
                                            fontWeight: FontWeight.w800),
                                      ))
                                  : SizedBox()
                            ]),
                          ))
                      : Container()
                ],
              )
            ],
          ),
          // ),
          onLongPress: () {
            if (item.user?.role == 'doctor') {
              return;
            }
            final message = item;
            final channel = StreamChannel.of(context).channel;
            final currentUser = StreamChat.of(context).currentUser;
            RenderBox renderBox = (widget.key as GlobalKey)
                .currentContext!
                .findRenderObject() as RenderBox;
            final offset = renderBox.localToGlobal(Offset.zero);

            showDialog(
              useRootNavigator: false,
              context: context,
              barrierColor: Color.fromRGBO(0, 0, 0, 0.329),
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
                    showCopyMessage: message.text?.trim().isNotEmpty == true,
                    showReplyMessage: false,
                    showThreadReplyMessage: false,
                    showDeleteMessage: currentUser!.id == message.user!.id &&
                        !message.isDeleted,
                    showEditMessage: currentUser.id == message.user!.id &&
                        !message.attachments
                            .any((element) => element.type == 'giphy'),
                    showWatchButton: true,
                    pos: [offset.dy, offset.dy + renderBox.size.height]),
              ),
            );
          }),
    );
  }
}
