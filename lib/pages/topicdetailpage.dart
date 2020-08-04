import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'dart:math'as math;
class TopicDetailPage extends StatefulWidget {
  String mTitle;
  String mImg;
  String mReadCount;
  String mDiscussCount;
  String mHost;

  TopicDetailPage(
      this.mTitle, this.mImg, this.mReadCount, this.mDiscussCount, this.mHost);

  @override
  State<StatefulWidget> createState() {
    return _TopicDetailPageState();
  }
}

class _TopicDetailPageState extends State<TopicDetailPage> with SingleTickerProviderStateMixin{
  final List<String> _tabs = [
    '综合',
    '实时',
    '热门',
    '视频',
    '问答',
    '图片',
    '同城',
  ];
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 10),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        Constant.ASSETS_IMG + 'icon_back.png',
                        width: 23.0,
                        height: 23.0,
                      ))),
              Expanded(
                  child: Container(
                child: InkWell(
                  child: Container(
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xffF4F4F4),
                        borderRadius: BorderRadius.all(
                          //圆角
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            Constant.ASSETS_IMG + 'find_top_search.png',
                            width: 16.0,
                            height: 16.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              "#" + widget.mTitle + "#",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xffee565656)),
                            ),
                          )
                        ],
                      )),
                  onTap: () {

                  },
                ),
              ))
            ],
          ),
          Expanded(child: NestedScrollView(headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
              return <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 130,
                          child: Image.asset(Constant.ASSETS_IMG +
                              'topic_detail_top.webp',
                              fit: BoxFit.fill),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    top: 10, left: 15, right: 15),
                                width: 70,
                                height: 70,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                1.0),
                                            shape: BoxShape.rectangle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    widget.mImg),
                                                fit: BoxFit.cover))),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10,top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "#" + widget.mTitle + "#",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      child: new Text(
                                        widget.mReadCount +
                                            "阅读   " +
                                            widget.mDiscussCount +
                                            "讨论   详情>",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white),
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                      margin: EdgeInsets.only(
                                          top: 8, right: 15),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 3, right: 15),
                                      child: new Text(
                                        "主持人:" + widget.mHost,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white),
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(delegate: _SliverAppBarDelegate(minHeight: 50, maxHeight: 50, child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(child: Container(
                          child: TabBar(
                            tabs: _tabs.map((e) => Tab(text: e,)).toList(),
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
                          ),
                          color: Colors.white,
                        ),),
                        Container(
                          padding: EdgeInsets.only(
                              right: 5, top: 5, bottom: 5),
                          child:Image.asset(
                            Constant.ASSETS_IMG +
                                'topic_detail_add.png',
                            width: 20,
                            height: 20,
                          ) ,
                        ),
                      ],
                    ),
                    Container(
                      height: 0.5,
                      color: Color(0xffE5E5E5),
                    ),
                  ],
                ),),pinned: true,floating: true,),
              ];
          }, body: TabBarView(controller:_tabController,children: _tabs.map((name) => Container(
            child:CustomScrollView(
              key: PageStorageKey<String>(name),
              slivers: <Widget>[
                SliverFixedExtentList(delegate: SliverChildBuilderDelegate((context,index){
                  return ListTile(
                    title: Text("Item${index}"),
                  );
                },childCount: 40), itemExtent: 40)
              ],
            ) ,
          )).toList())))
        ],
      ),
    ));
  }
}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}