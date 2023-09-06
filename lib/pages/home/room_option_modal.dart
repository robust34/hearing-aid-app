import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/models/ModelProvider.dart';
import 'package:doceo_new/services/app_provider.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class RoomOptionsModal extends StatefulWidget {
  final Map<String, dynamic> room;
  final bool isRequest;
  const RoomOptionsModal(
      {super.key, required this.room, required this.isRequest});

  @override
  State<RoomOptionsModal> createState() => _RoomOptionsModal();
}

class _RoomOptionsModal extends State<RoomOptionsModal> {
  TextEditingController textEditingController = TextEditingController();
  bool btnStatus = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    String sharedUrl = 'https://www.profuture.co.jp/mk/column/39138';

    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: height * 0.512,
          width: width,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7),
              topRight: Radius.circular(7),
            ),
          ),
          child: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Image.asset(
                          widget.isRequest
                              ? 'assets/images/request.png'
                              : 'assets/images/invitation.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                              widget.isRequest
                                  ? 'ROOM内リクエスト'
                                  : '悩みを持つ家族・友人に共有しよう',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'M_PLUS',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.08),
                            child: Text(
                                widget.isRequest
                                    ? 'チャネルのテーマ整理や欲しい機能など\nあなたなんでもお伝えください'
                                    : 'このリンクをシェアするとURLからROOMへの\n参加が可能です',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'M_PLUS',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal)),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.9,
                            child: widget.isRequest
                                ? TextFormField(
                                    textAlign: TextAlign.center,
                                    controller: textEditingController,
                                    maxLines: 3,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      hintText: '自由にお書きください',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: width * 0.02),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hoverColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            width: 0.1,
                                            color: Color(0xff4F5660)),
                                      ),
                                    ),
                                  )
                                : OutlinedButton(
                                    onPressed: () {
                                      var data = ClipboardData(text: sharedUrl);
                                      Clipboard.setData(data);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                        'Copied to clipboard',
                                        style: TextStyle(
                                            fontFamily: 'M_PLUS',
                                            fontSize: 15,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.white),
                                      )));
                                    },
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xffEBECEE),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.04,
                                            vertical: 10),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 12,
                                          child: Text(
                                            sharedUrl,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontFamily: 'M_PLUS',
                                                fontSize: 15,
                                                fontStyle: FontStyle.normal,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Image.asset(
                                            'assets/images/copy-icon.png',
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.9,
                            child: ElevatedButton(
                              onPressed: () {
                                if (widget.isRequest) {
                                  submitRequest();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                      Color(0xffB44DD9),
                                      Color(0xff70A4F2)
                                    ]),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: btnStatus
                                      ? const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          strokeWidth: 1)
                                      : Text(
                                          widget.isRequest
                                              ? '送信する'
                                              : 'リンクを共有する',
                                          style: const TextStyle(
                                              fontFamily: 'M_PLUS',
                                              fontSize: 15,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.white),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ]),
          ),
        ));
  }

  Future<void> submitRequest() async {
    if (textEditingController.text.isNotEmpty) {
      final suggestion = RoomSuggestion(
          roomId: widget.room['channel']['id'],
          userId: StreamChat.of(context).currentUser!.id,
          suggestion: textEditingController.text);
      final request = ModelMutations.create(suggestion);

      setState(() {
        btnStatus = true;
      });

      try {
        final response = await Amplify.API.mutate(request: request).response;
        if (response.errors.isNotEmpty) {
          AuthenticateProviderPage.of(context, listen: false)
              .notifyToastDanger(message: "エラーです。もう一度お試しください。");
        } else {
          setState(() {
            btnStatus = false;
          });
          textEditingController.clear();
          Navigator.pop(context);
        }
      } catch (e) {
        safePrint(e);
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: "エラーです。もう一度お試しください。");

        setState(() {
          btnStatus = false;
        });
      }
    }
  }
}
