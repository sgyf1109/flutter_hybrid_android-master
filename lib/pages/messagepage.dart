import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/pages/message_msg_page.dart';

import 'message_dynamic_page.dart';
import 'weibofollowpage.dart';
import 'weibohotpage.dart';

class MessagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MessagePageState();
  }
}

class _MessagePageState extends State<MessagePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TabController _tabController;
  final List<String> _tabValues = [
    '动态',
    '消息',
  ];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: _tabValues.length, vsync: this)..addListener(() {
      print("_tabController.index的值:" + _tabController.index.toString());
      setState(() {

    });});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 50,
                color: Color(0xffF9F9F9),
                //  color:Colors.red,
                alignment: Alignment.center,
                child: TabBar(
                    isScrollable: true,
                    indicatorColor: Color(0xffFF3700),
                    indicator: UnderlineTabIndicator(
                        borderSide:
                        BorderSide(color: Color(0xffFF3700), width: 2),
                        insets: EdgeInsets.only(bottom: 7)),
                    labelColor: Color(0xff333333),
                    unselectedLabelColor: Color(0xff666666),
                    labelStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                    unselectedLabelStyle: TextStyle(fontSize: 16.0),
                    indicatorSize: TabBarIndicatorSize.label,
                    controller: _tabController,
                    tabs: [
                      new Tab(
                        text: _tabValues[0],
                      ),
                      new Tab(
                        text: _tabValues[1],
                      ),
                    ]),
              ),
              new Align(
                alignment: Alignment.centerLeft,
                child: new Container(
                  margin: EdgeInsets.only(left: 15),
                  child: (_tabController.index == 1)
                      ? Text(
                    "发现群",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )
                      : new Container(),
                ),
              ),
              new Align(
                alignment: Alignment.centerRight,
                child: new IconButton(
                  icon: new Image.asset("assets/images/message_setting.webp",
                      width: 30.0, height: 30.0),
                  onPressed: () {
                    // Routes .navigateTo(context, '${Routes.weiboPublishPage}');
                  },
                ),
              ),
            ],
          ),
          Expanded(
              child: TabBarView(
                children: [MessageDynamicPage(), MessageMsgPage()],
                controller: _tabController,
              ))
        ],
      )),
    );
  }
}
