import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/pages/videopage.dart';
import 'package:flutterhybridandroid/pages/weibofollowpage.dart';
import 'package:flutterhybridandroid/pages/weibohotpage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TabController _tabController;
  final List<String> _tabValues = [
    '关注',
    '热门',
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    print("主页");
    _tabController = new TabController(length: _tabValues.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.deepOrange,
                      indicatorSize: TabBarIndicatorSize.label,
                      //下划线
                      indicator: UnderlineTabIndicator( //下划线样式
                          borderSide: BorderSide(
                              color: Colors.deepOrange, width: 2),
                          insets: EdgeInsets.only(bottom: 7)
                      ),
                      labelColor: Colors.deepOrange,
                      //字体颜色
                      unselectedLabelColor: Colors.grey,
                      labelStyle: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                      //字体风格
                      unselectedLabelStyle: TextStyle(fontSize: 16),
                      tabs: [
                        Tab(text: _tabValues[0]),
                        new Tab(text: _tabValues[1])
                      ],
                      controller: _tabController,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(icon: Image.asset(
                      "assets/images/ic_main_add.png", width: 40, height: 40,),
                      onPressed:(){

                      }),
                  )
                ],
              ),
              Expanded(
                  child: TabBarView(
                    children: [WeiBoFollowPage(mCatId: "0",), WeiBoHotPage()],
                    controller: _tabController,
                  ))
            ],
          ),
        ));
  }
}
