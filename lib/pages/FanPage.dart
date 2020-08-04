import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/pages/FanListPage.dart';

import 'FFRecommandPage.dart';
import 'FollowListPage.dart';

class FanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FanPageState();
  }
}

class _FanPageState extends State<FanPage>
    with SingleTickerProviderStateMixin {
  final List<String> _tabValues = [
    '推荐',
    '粉丝',
  ];
  TabController primaryTC;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    primaryTC = TabController(length: _tabValues.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Color(0xffFAFAFA),
          leading: IconButton(
              iconSize: 30,
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            "粉丝",
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          elevation: 0.5,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 15),
              alignment: Alignment.center,
              child: Text(
                "发现用户",
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
        preferredSize: Size.fromHeight(50),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: TabBar(
              tabs: [
                new Tab(
                  text: _tabValues[0],
                ),
                new Tab(
                  text: _tabValues[1],
                ),
              ],
              isScrollable: true,
              indicatorColor: Color(0xffFF3700),
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Color(0xffFF3700), width: 2),
                  insets: EdgeInsets.only(bottom: 7)),
              labelColor: Color(0xff333333),
              unselectedLabelColor: Color(0xff666666),
              labelStyle:
                  TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
              unselectedLabelStyle: TextStyle(fontSize: 16.0),
              indicatorSize: TabBarIndicatorSize.label,
              controller: primaryTC,
            ),
          ),
          Expanded(child: TabBarView(controller: primaryTC, children: <Widget>[
            FFRecommandPage(),
            FanListPage()
          ]))
        ],
      ),
    ));
  }
}
