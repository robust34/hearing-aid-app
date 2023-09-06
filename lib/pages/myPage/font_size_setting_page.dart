// ignore_for_file: avoid_print

import 'package:doceo_new/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSizeSettingPage extends StatefulWidget {
  const FontSizeSettingPage({super.key});

  @override
  _FontSizeSettingPage createState() => _FontSizeSettingPage();
}

class _FontSizeSettingPage extends State<FontSizeSettingPage> {
  List<double> magnificationValues = [0.7, 0.85, 1.0, 1.2];

  int _selectedIndex = 2;

  void _setSelectedIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('font_size_selectedIndex', index);
    setState(() {
      _selectedIndex = index;
    });
    AppStyles.loadSelectedIndex();
  }

  @override
  void initState() {
    super.initState();
    _loadSelectedIndex();
  }

  Future<void> _loadSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = prefs.getInt('font_size_selectedIndex') ?? 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            leading: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            title: Text('文字サイズ',
                style: TextStyle(
                    fontFamily: 'M_PLUS',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/splash_1.png'),
                  backgroundColor: Colors.transparent,
                ),
                title: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: Color(0xffF8F8F8),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('運営',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'M_PLUS',
                              fontSize:
                                  15 * magnificationValues[_selectedIndex],
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Text('2023/4/1',
                          style: TextStyle(
                              color: Color(0xffB4BABF),
                              fontFamily: 'M_PLUS',
                              fontSize:
                                  12 * magnificationValues[_selectedIndex],
                              fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                      decoration: const BoxDecoration(
                          color: Color(0xffF8F8F8),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Text(
                          '糖尿病など多くの生活習慣病は肥満が原因であるものが多く、自助努力だけではダイエットが困難である方や生まれつき太りやすい方、健康面から今すぐに減量を検討すべき方を対象としたROOMです。',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'M_PLUS',
                              fontSize:
                                  15 * magnificationValues[_selectedIndex],
                              fontWeight: FontWeight.normal)),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Aa',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'M_PLUS',
                          fontSize: 12 * magnificationValues[_selectedIndex],
                          fontWeight: FontWeight.normal)),
                  Expanded(
                    child: SliderTheme(
                        data: const SliderThemeData(
                          trackHeight: 1,
                          thumbShape: RoundSliderThumbShape(
                              elevation: 3, enabledThumbRadius: 12),
                        ),
                        child: Slider(
                          min: 0,
                          max: 3,
                          activeColor: Colors.black,
                          inactiveColor: Colors.black,
                          thumbColor: Colors.white,
                          divisions: 3,
                          onChanged: (newValue) {
                            _setSelectedIndex(newValue.toInt());
                            setState(() {
                              _selectedIndex = newValue.toInt();
                            });
                          },
                          value: _selectedIndex.toDouble(),
                        )),
                  ),
                  Text('Aa',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'M_PLUS',
                          fontSize: 18 * magnificationValues[_selectedIndex],
                          fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ],
        ));
  }
}
