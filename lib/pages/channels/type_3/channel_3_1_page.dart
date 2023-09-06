import 'dart:io';

import 'package:doceo_new/getstream/custom_date_divider.dart';
import 'package:doceo_new/getstream/custom_message.dart';
import 'package:doceo_new/getstream/custom_search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class Type3Channel1Page extends StatefulWidget {
  const Type3Channel1Page({super.key});

  @override
  _Type3Channel1Page createState() => _Type3Channel1Page();
}

class _Type3Channel1Page extends State<Type3Channel1Page> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String searchKey = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.92,
          child: Container(
              color: const Color(0xfff8f8f8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 55),
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  searchKey = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: 'チャネル内検索',
                                  hintStyle: TextStyle(
                                      fontFamily: 'M_PLUS',
                                      fontSize: 15,
                                      color: Colors.grey)),
                              // controller: email,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.9,
                          // margin: EdgeInsets.only(bottom: 10),
                          child: StreamMessageSearchListView(
                            separatorBuilder: (context, responses, index) {
                              return const SizedBox(
                                height: 4,
                              );
                            },
                            controller: StreamMessageSearchListController(
                              client: StreamChat.of(context).client,
                              filter: Filter.equal(
                                  'id', StreamChannel.of(context).channel.id!),
                              messageFilter:
                                  Filter.autoComplete('text', searchKey),
                            ),
                            itemBuilder:
                                (context, response, index, titleWidget) {
                              return CustomSearchResult(
                                  message: response[index].message);
                            },
                          ),
                        )),
                      ],
                    )
                  ],
                ),
              )),
        ),
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
          actions: [
            // Container(
            //   margin: const EdgeInsets.only(right: 20),
            //   height: 20,
            //   width: 20,
            //   child: InkWell(
            //     onTap: () {
            //       _scaffoldKey.currentState!.openEndDrawer();
            //     },
            //     child: Image.asset(
            //       'assets/images/search.png',
            //       fit: BoxFit.contain,
            //     ),
            //   ),
            // )
          ],
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
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.3),
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
                  'assets/images/user-icon.svg',
                  fit: BoxFit.contain,
                ),
                const Text(' ⇄ ',
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
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              // child: Text('**************'),
              child: StreamMessageListView(
                showFloatingDateDivider: false,
                dateDividerBuilder: (date) {
                  return CustomDateDivider(dateTime: date);
                },
                scrollPhysics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                emptyBuilder: _emptyBuilder,
                messageBuilder: _messageBuilder,
              ),
            ),
            StreamMessageInput(
              showCommandsButton: false,
              attachmentLimit: 1,
              // attachmentsPickerBuilder:
              //     (context, messageInputController, defaultPicker) {
              //   return defaultPicker.copyWith(allowedAttachmentTypes: [
              //     DefaultAttachmentTypes.image,
              //     DefaultAttachmentTypes.video
              //   ]);
              // },
            ),
          ],
        ),
      );

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
              child: const Text('ここではユーザー同士で悩みを共有し合うことが可能です。',
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
    return CustomMessage(
        key: GlobalKey(),
        context: context,
        details: details,
        messages: messages,
        defaultMessageWidget: defaultMessageWidget);
  }
}
