import 'dart:ui';

import 'package:doceo_new/getstream/custom_reaction_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
// import 'package:stream_chat_flutter/src/extension.dart';
// import 'package:stream_chat_flutter/src/reaction_bubble.dart';

class CustomReactionIcon extends StatefulWidget {
  final dynamic message;
  final String reactionType;
  final double? size;
  final int? reactionScore;

  const CustomReactionIcon(
      {super.key,
      required this.reactionType,
      this.message,
      this.size,
      this.reactionScore});

  @override
  State<CustomReactionIcon> createState() => _CustomReactionIconState();
}

class _CustomReactionIconState extends State<CustomReactionIcon> {
  @override
  Widget build(BuildContext context) {
    final currentUserId = StreamChat.of(context).client.state.currentUser?.id;

    bool checkUserLikedMessage(List<Reaction> latestReactions,
        String? currentUserId, String reactionType) {
      for (Reaction reaction in latestReactions) {
        if (reaction.type == reactionType &&
            reaction.user?.id == currentUserId) {
          return true;
        }
      }
      return false;
    }

    bool isOwnReaction = checkUserLikedMessage(
        widget.message.latestReactions, currentUserId, widget.reactionType);

    return GestureDetector(
      onTap: () async {
        if (isOwnReaction) {
          await StreamChat.of(context)
              .client
              .deleteReaction(widget.message.id, widget.reactionType)
              .catchError((e) => print(e));
          if (widget.reactionScore == null) {
            Navigator.pop(context);
          }
        } else {
          await StreamChat.of(context)
              .client
              .sendReaction(widget.message.id, widget.reactionType)
              .catchError((e) => print(e));
          if (widget.reactionScore == null) {
            Navigator.pop(context);
          }
        }
      },
      child: Row(
        children: [
          reactionIcon(widget.reactionType, isOwnReaction, widget.size),
          if (widget.reactionScore != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text("${widget.reactionScore}",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color:
                          isOwnReaction ? Color(0xff7A96DE) : Colors.black12)),
            ),
        ],
      ),
    );
  }

  Widget reactionIcon(type, isOwnReaction, size) {
    var colorStyle = isOwnReaction ? Colors.blue : Colors.black12;
    final chatThemeData = StreamChatTheme.of(context);
    switch (type) {
      case 'okay':
        return Container(
          height: size,
          child: Center(
              child: SvgPicture.asset(
            'assets/images/emo_1.svg',
            fit: BoxFit.contain,
          )),
        );
      case 'sad':
        return Container(
          height: size,
          child: Center(
              child: SvgPicture.asset(
            'assets/images/emo_2.svg',
            fit: BoxFit.contain,
          )),
        );
      case 'think':
        return Container(
          height: size,
          child: Center(
              child: SvgPicture.asset(
            'assets/images/emo_3.svg',
            fit: BoxFit.contain,
          )),
        );
      case 'good':
        return Container(
          height: size,
          child: Center(
              child: SvgPicture.asset(
            'assets/images/emo_4.svg',
            fit: BoxFit.contain,
          )),
        );
      case 'thanks':
        return Container(
          height: size,
          child: Center(
              child: SvgPicture.asset(
            'assets/images/emo_5.svg',
            fit: BoxFit.contain,
          )),
        );
      default:
        return Container(
          height: size,
          child: Center(
              child: SvgPicture.asset(
            'assets/images/emo_1.svg',
            fit: BoxFit.contain,
          )),
        );
    }
  }
}

class CustomMessageReactionsModal extends StatelessWidget {
  /// Message to display reactions of
  final Message message;

  /// [StreamMessageThemeData] to apply to [message]
  // final StreamMessageThemeData messageTheme;

  /// Flag to reverse message
  final bool reverse;

  /// Flag to show reactions on message
  final bool? showReactions;

  /// Callback when user avatar is tapped
  final void Function(User)? onUserAvatarTap;

  const CustomMessageReactionsModal(
      {super.key,
      required this.message,
      // required this.messageTheme,
      this.reverse = false,
      this.showReactions,
      this.onUserAvatarTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = StreamChat.of(context).currentUser;
    final _userPermissions = StreamChannel.of(context).channel.ownCapabilities;

    final hasReactionPermission =
        _userPermissions.contains(PermissionType.sendReaction);

    final roughMaxSize = size.width * 2 / 3;
    var messageTextLength = message.text!.length;
    if (message.quotedMessage != null) {
      var quotedMessageLength = message.quotedMessage!.text!.length + 40;
      if (message.quotedMessage!.attachments.isNotEmpty) {
        quotedMessageLength += 40;
      }
      if (quotedMessageLength > messageTextLength) {
        messageTextLength = quotedMessageLength;
      }
    }
    final roughSentenceSize = messageTextLength * (12 ?? 1) * 1.2;
    final divFactor = message.attachments.isNotEmpty
        ? 1
        : (roughSentenceSize == 0 ? 1 : (roughSentenceSize / roughMaxSize));

    final numberOfReactions =
        StreamChatConfiguration.of(context).reactionIcons.length;
    final shiftFactor =
        numberOfReactions < 5 ? (5 - numberOfReactions) * 0.1 : 0.0;

    final child = Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if ((showReactions ?? hasReactionPermission) &&
                  (message.status == MessageSendingStatus.sent))
                Align(
                  alignment: Alignment(
                    user!.id == message.user!.id
                        ? (divFactor >= 1.0
                            ? -0.2 - shiftFactor
                            : (1.2 - divFactor))
                        : (divFactor >= 1.0
                            ? shiftFactor + 0.2
                            : -(1.2 - divFactor)),
                    0,
                  ),
                  child: CustomReactionPicker(
                    message: message,
                  ),
                )
            ],
          ),
        ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.maybePop(context),
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: StreamChatTheme.of(context).colorTheme.overlay,
                ),
              ),
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutBack,
            builder: (context, val, widget) => Transform.scale(
              scale: val,
              child: widget,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
