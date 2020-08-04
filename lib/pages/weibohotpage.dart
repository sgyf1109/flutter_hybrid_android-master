import 'package:flutter/material.dart';

import 'weibofollowpage.dart';

class WeiBoHotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeiBoHotPageState();
  }
}

class _WeiBoHotPageState extends State<WeiBoHotPage>
    with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  final List<String> _tabValues = ['推荐', '附近', '榜单', '明星', '搞笑', '社会', '测试'];
  TabController _tabController;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: _tabValues.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          Divider(
            height: 0.5,
            color: Color(0xffBECBC2),
          ),
          Container(
            height: 45,
            color: Color(0xffffffff),//设置背景色可以去除掉水波纹
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              indicator: const BoxDecoration(),
              labelColor: Color(0xffFF3700),
              unselectedLabelColor: Color(0xff666666),
              labelStyle:
                  TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              unselectedLabelStyle: TextStyle(fontSize: 16.0),
              tabs: _tabValues
                  .map((e) => Tab(
                        text: e.toString(),
                      ))
                  .toList(),
            ),
          ),
          Divider(
            height: 0.5,
            color: Color(0xffBECBC2),
          ),
          new Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                new WeiBoFollowPage(mCatId: "1"),
                new WeiBoFollowPage(mCatId: "2"),
                new WeiBoFollowPage(mCatId: "3"),
                new WeiBoFollowPage(mCatId: "4"),
                new WeiBoFollowPage(mCatId: "5"),
                Center(
                  child: Text("暂无数据"),
                ),
                new WeiBoFollowPage(mCatId: "10"),
                //  new WeiBoHomeListPager(),
              ],
            ),
          )
        ],
      )),
    );
  }
}
