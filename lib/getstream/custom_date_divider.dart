import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CustomDateDivider extends StatelessWidget {
  const CustomDateDivider({
    super.key,
    required this.dateTime,
    this.uppercase = false,
  });

  /// [DateTime] to display
  final DateTime dateTime;

  /// If text is uppercase
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    final createdAt = Jiffy(dateTime);
    final now = Jiffy(DateTime.now());

    var dayInfo = createdAt.MMMd;
    if (createdAt.isSame(now, Units.DAY)) {
      dayInfo = context.translations.todayLabel;
    } else if (createdAt.isSame(now.subtract(days: 1), Units.DAY)) {
      dayInfo = context.translations.yesterdayLabel;
    } else if (createdAt.isAfter(now.subtract(days: 7), Units.DAY)) {
      dayInfo = createdAt.EEEE;
    } else if (createdAt.isAfter(now.subtract(years: 1), Units.DAY)) {
      dayInfo = createdAt.MMMd;
    }

    if (uppercase) dayInfo = dayInfo.toUpperCase();

    final chatThemeData = StreamChatTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
      child: Row(children: [
        const Expanded(
            child: Divider(
          color: Color(0xff4F5660),
          height: 1,
        )),
        const SizedBox(
          width: 20,
        ),
        Text(
          dayInfo,
          style: const TextStyle(
              color: Color(0xff4F5660),
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          width: 20,
        ),
        const Expanded(
            child: Divider(
          color: Color(0xff4F5660),
          height: 1,
        )),
      ]),
    );
  }
}
