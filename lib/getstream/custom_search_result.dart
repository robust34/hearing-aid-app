import 'package:doceo_new/getstream/reply_message.dart';
import 'package:doceo_new/helper/util_helper.dart';
import 'package:doceo_new/pages/channels/type_2/channel_2_1_reply.dart';
import 'package:doceo_new/pages/channels/type_3/channel_3_1_reply.dart';
import 'package:doceo_new/styles/colors.dart';
import 'package:doceo_new/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CustomSearchResult extends StatefulWidget {
  final Message message;

  const CustomSearchResult({super.key, required this.message});

  @override
  State<CustomSearchResult> createState() => _CustomSearchResult();
}

class _CustomSearchResult extends State<CustomSearchResult> {
  late Message target = widget.message;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    if (widget.message.parentId != null) {
      loading = true;
      getMessage();
    }
  }

  void getMessage() async {
    try {
      final client = StreamChat.of(context).client;
      final response = await client.getMessage(widget.message.parentId!);

      setState(() {
        target = response.message;
        loading = false;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;

    return Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: loading
            ? const LinearProgressIndicator(
                minHeight: 15,
              )
            : InkWell(
                onTap: () {
                  goToReplyPage(context);
                },
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          textAlign: TextAlign.left,
                          target.text.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: AppStyles.content
                              .copyWith(color: AppColors.mainText)),
                      const SizedBox(height: 10),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        UtilHelper.userAvatar(target.user!, 10),
                        const SizedBox(width: 7),
                        Text(
                            UtilHelper.getDisplayName(
                                target.user!, channel.type),
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainText)),
                        const SizedBox(width: 11),
                        Text(UtilHelper.formatDate(widget.message.createdAt),
                            style: TextStyle(
                                color: AppColors.subText,
                                fontFamily: 'M_PLUS',
                                fontSize: 12,
                                fontWeight: FontWeight.normal)),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/images/comment-icon.svg',
                                  width: 19, height: 18),
                              Container(
                                padding: const EdgeInsets.only(left: 3),
                                child: Text(target.replyCount.toString(),
                                    style: TextStyle(
                                        color: AppColors.subText,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        ),
                      ])
                    ])));
  }

  void goToReplyPage(context) {
    final channel = StreamChannel.of(context).channel;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StreamChannel(
                channel: channel,
                child: channel.type == 'channel-2'
                    ? Type2Channel2ReplyPage(
                        parent: target,
                      )
                    : Type3Channel1ReplyPage(
                        parent: target,
                      ))));
  }
}
