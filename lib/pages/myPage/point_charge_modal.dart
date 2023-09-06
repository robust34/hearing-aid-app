import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:doceo_new/models/ModelProvider.dart';
import 'package:doceo_new/pages/home/home_page.dart';
import 'package:doceo_new/pages/home/loading_animation.dart';
import 'package:doceo_new/pages/myPage/my_page_screen.dart';
import 'package:doceo_new/services/auth_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as GetStream;
import 'package:url_launcher/url_launcher.dart';

class PointChargeModal extends StatefulWidget {
  const PointChargeModal({Key? key}) : super(key: key);

  @override
  _PointChargeModalState createState() => _PointChargeModalState();
}

class _PointChargeModalState extends State<PointChargeModal> {
  int _selectedIndex = 0;

  // Initialize state
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool isLoading = false;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final Uri _terms = Uri.parse('https://doceo.jp/terms/');
  final Uri _specified = Uri.parse('https://doceo.jp/specified-commercial/');
  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _specificRecognizer;

  @override
  void initState() {
    initStoreInfo();
    isLoading = false;
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = _openTerms;
    _specificRecognizer = TapGestureRecognizer()..onTap = _openSpecified;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  _openTerms() async {
    if (!await launchUrl(
      _terms,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $_terms');
    }
  }

  _openSpecified() async {
    if (!await launchUrl(
      _specified,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $_specified');
    }
  }

  _openSpecific() {}

  // Initialize Store Info and get products
  Future<void> initStoreInfo() async {
    final isAvailable = await InAppPurchase.instance.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
      });
      return;
    }
    final productIds = <String>[
      'doceo.point.charge.small',
      'doceo.point.charge.midium',
      'doceo.point.charge.big',
    ];

    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(productIds.toSet());

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Product not found: ${response.notFoundIDs}');
    }

    if (response.error != null) {
      debugPrint('Error: ${response.error}');
      return;
    }

    setState(() {
      _products = response.productDetails.reversed.toList();
      _isAvailable = isAvailable;
    });

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      print('DONE');
      _subscription.cancel();
    }, onError: (Object error) {
      print(error);
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      final _product =
          _products.where((e) => e.id == purchaseDetails.productID);
      print(PurchaseStatus.pending);
      if (purchaseDetails.status == PurchaseStatus.pending) {
        print('PENDING');
        setState(() {
          isLoading = true;
        });
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          setState(() {
            isLoading = false;
          });
          AuthenticateProviderPage.of(context, listen: false)
              .notifyToastDanger(message: "購入に失敗しました。少し時間をおいた後もう一度お試しください。");
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          print('PURCHASED');
          await _addPurchaseData(_product.first);
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          print('PENDING PURCHASED');
          await InAppPurchase.instance.completePurchase(purchaseDetails);
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  Future<void> _addPurchaseData(product) async {
    try {
      final client = GetStream.StreamChat.of(context).client;
      final currentUser = GetStream.StreamChat.of(context).currentUser;
      final purchasedPoint = int.parse(product.title.split(' ')[1]);
      int point = (currentUser!.extraData['point'] != null
              ? currentUser.extraData['point'] as int
              : 0) +
          purchasedPoint;
      currentUser.extraData['point'] = point;
      await client.updateUser(currentUser);
      final pointHistory = PointHistory(
          type: 'purchase',
          text: 'ポイントを購入しました',
          userId: currentUser.id,
          point: purchasedPoint);
      final request = ModelMutations.create(pointHistory);
      await Amplify.API.mutate(request: request).response;
    } catch (err) {
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。少し時間をおいた後もう一度お試しください。");
    }
  }

  Future<void> _buyProduct(ProductDetails product) async {
    print('BUY PRODUCT');
    print(product.title);
    try {
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      print(purchaseParam);
      bool isSuccess = await InAppPurchase.instance
          .buyConsumable(purchaseParam: purchaseParam);
      if (!isSuccess) {
        AuthenticateProviderPage.of(context, listen: false)
            .notifyToastDanger(message: "エラーです。少し時間をおいた後もう一度お試しください。");
      }
    } catch (e) {
      safePrint(e);
      AuthenticateProviderPage.of(context, listen: false)
          .notifyToastDanger(message: "エラーです。少し時間をおいた後もう一度お試しください。");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final modalHeight = height * 0.6;
    final formatter = NumberFormat.compact();

    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Color(0xffF8F8F8),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            width: width,
            height: modalHeight,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(children: [
                          Expanded(
                              child: Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios_rounded),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          )),
                          Container(
                            padding: EdgeInsets.all(width * 0.03),
                            margin: EdgeInsets.only(right: width * 0.02),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '残高：',
                                  style: TextStyle(
                                      fontFamily: 'M_PLUS',
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff777777)),
                                ),
                                SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: SvgPicture.asset(
                                        'assets/images/coin-icon.svg',
                                        fit: BoxFit.contain)),
                                const SizedBox(width: 10),
                                Text(
                                  GetStream.StreamChat.of(context)
                                              .currentUser!
                                              .extraData['point'] !=
                                          null
                                      ? GetStream.StreamChat.of(context)
                                          .currentUser!
                                          .extraData['point']
                                          .toString()
                                      : '0',
                                  style: TextStyle(
                                      fontFamily: 'M_PLUS',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff777777)),
                                ),
                              ],
                            ),
                          ),
                        ])),
                    Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Image.asset(
                                  'assets/images/coin-charge-image.png',
                                  fit: BoxFit.cover),
                            ),
                            Expanded(
                              flex: 1,
                              child: const Text(
                                'D-coin チャージ',
                                style: TextStyle(
                                    fontFamily: 'M_PLUS',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: const Text(
                                'DOCEOの一部サービスは、利用するために\nポイントが必要になります',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'M_PLUS',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: _products.length == 0
                                    ? LoadingAnimation()
                                    : ListView.builder(
                                        itemCount: _products.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final product = _products[index];
                                          final _title =
                                              product.title.split(' ')[1];
                                          return Container(
                                            width: width * 0.3,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: width * 0.01,
                                                vertical: 10),
                                            child: (ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _selectedIndex = index;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    side: _selectedIndex ==
                                                            index
                                                        ? BorderSide(
                                                            color: Color(
                                                                0xff4D7CFF),
                                                            width: 2)
                                                        : BorderSide(
                                                            color: Colors.black,
                                                            width: 0.3),
                                                  ),
                                                ),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                              height: 25,
                                                              width: 25,
                                                              child: SvgPicture.asset(
                                                                  'assets/images/coin-icon.svg',
                                                                  fit: BoxFit
                                                                      .contain)),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            '${_title}',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'M_PLUS',
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xff777777)),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        '${product.price}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'M_PLUS',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xffB4BABF)),
                                                      ),
                                                    ]))),
                                          );
                                        })),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: RichText(
                                      text: TextSpan(
                                        text:
                                            'ポイントに関するポリシーは「利用規約第９条（ポイント）」をご確認ください。',
                                        style: TextStyle(
                                            fontFamily: 'M_PLUS',
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.normal,
                                            color: Color(0xffB4BABF)),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '利用規約',
                                            recognizer: _termsRecognizer,
                                            style: TextStyle(
                                                fontFamily: 'M_PLUS',
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff1997F6)),
                                          ),
                                          TextSpan(
                                            text: ' | ',
                                            style: TextStyle(
                                                fontFamily: 'M_PLUS',
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff1997F6)),
                                          ),
                                          TextSpan(
                                            text: '特定商取引法に基づく表記',
                                            recognizer: _specificRecognizer,
                                            style: TextStyle(
                                                fontFamily: 'M_PLUS',
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff1997F6)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            // _buyTest();
                            _buyProduct(_products[_selectedIndex]);
                          },
                          style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
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
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 40,
                              alignment: Alignment.center,
                              child: const Text(
                                'チャージする',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'M_PLUS',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (isLoading)
                  Container(
                      height: height,
                      width: width,
                      color: Colors.black.withOpacity(0.3),
                      alignment: Alignment.center,
                      child: LoadingAnimation()),
              ],
            ),
          ),
        ));
  }
}
