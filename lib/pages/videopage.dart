import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/model/VedioCategory.dart';
import 'package:flutterhybridandroid/model/VedioCategoryList.dart';
import 'package:flutterhybridandroid/pages/videohotpage.dart';
import 'package:flutterhybridandroid/pages/videosmallvideopage.dart';
import 'videorecommendpage.dart';

class VideoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VideoPageState();
  }
}

class _VideoPageState extends State<VideoPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  TabController _tabController;
  List<VedioCategory> mTabList = new List();

  @override
  void initState() {
    mTabList.add(new VedioCategory(id: 1, cname: "推荐"));
    mTabList.add(new VedioCategory(id: 2, cname: "热门"));
    mTabList.add(new VedioCategory(id: 3, cname: "小视频"));
    _tabController = new TabController(length: mTabList.length, vsync: this);
//    DioManager.getInstance().post(ServiceUrl.getVedioCategory, null, (data) {
//      List<VedioCategory> mList = VedioCategoryList.fromJson(data['data']).data;
//      setState(() {
//        mTabList = mList;
//        _tabController = TabController(length: mTabList.length, vsync: this);
//      });
//    }, (error) {
//      //ToastUtil.show(error);
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 50,
              color: Color(0xffffffff), //设置背景色可以去除掉水波纹
              child: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicator: const BoxDecoration(),
                labelColor: Color(0xffFF3700),
                unselectedLabelColor: Color(0xff666666),
                labelStyle:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                unselectedLabelStyle: TextStyle(fontSize: 16.0),
                tabs: mTabList
                    .map((e) => Tab(
                          text: e.cname,
                        ))
                    .toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20),
                    //设置prefixIcon会导致contentpadding无效
                    prefixIconConstraints:
                        BoxConstraints(maxWidth: 50, maxHeight: 50),
                    prefixIcon: Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      child: Image.asset(
                        Constant.ASSETS_IMG + 'find_top_search.png',
                        width: 20.0,
                        height: 20.0,
                      ),
                    ),
                    hintText: "搜你想看的视频",
                    alignLabelWithHint: true,
                    enabledBorder: OutlineInputBorder(
                      /*边角*/
                      borderRadius: BorderRadius.all(
                        Radius.circular(10), //边角为5
                      ),
                      borderSide: BorderSide(
                        color: Colors.white, //边线颜色为白色
                        width: 1, //边线宽度为2
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white, //边框颜色为白色
                        width: 1, //宽度为5
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10), //边角为30
                      ),
                    ),
                    filled: true,
                    fillColor: Color(0xffE4E2E8)),
                onChanged: (msg) {
                  print("文本框内容" + msg);
                },
                onSubmitted: (msg) {
                  print("文本框内容完成" + msg);
                },
              ),
            ),
            Expanded(
                child: TabBarView(
              children: <Widget>[
                VideoRecommendPage(),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: VideoHotPage(),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: VideoSmallVideoPage(),
                )
              ],
              controller: _tabController,
            ))
          ],
        ),
      ),
    );
  }
}
