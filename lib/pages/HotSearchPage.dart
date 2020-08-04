import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/model/FindHomeModel.dart';
import 'package:flutterhybridandroid/model/OtherUserModel.dart';
import 'package:flutterhybridandroid/pages/PageInfoPic.dart';
import 'package:flutterhybridandroid/pages/PageInfoWeiBo.dart';

import 'minepage.dart';
import 'personinfohomepage.dart';
import 'weibofollowpage.dart';

class HotSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HotSearchPageState();
  }
}

class _HotSearchPageState extends State<HotSearchPage> {
  bool isShowBlackTitle = false;
  List<Findhottop> mHotSearchList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DioManager.getInstance().post(ServiceUrl.getHotSearchList, null, (data) {
      mHotSearchList.clear();
      data['data'].forEach((data) {
        mHotSearchList.add(Findhottop.fromJson(data));
      });
      setState(() {});
    }, (error) {});
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: NotificationListener(
        child: Column(children: <Widget>[
          Expanded(child: NestedScrollView(
            headerSliverBuilder: (context, bool) {
              return <Widget>[
                SliverAppBar(
                  leading: new Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    child: isShowBlackTitle
                        ? Image.asset(
                      Constant.ASSETS_IMG + 'userinfo_icon_back_black.png',
                      fit: BoxFit.fitHeight,
                    )
                        : Image.asset(
                      Constant.ASSETS_IMG + 'userinfo_icon_back_white.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  title: isShowBlackTitle ? Text("微博热搜") : Text(''),
                  centerTitle: true,
                  pinned: true,
                  floating: false,
                  snap: false,
                  primary: true,
                  expandedHeight: 210.0,
                  backgroundColor: Color(0xffF8F8F8),
                  elevation: 0,
                  actions: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(right: 10, top: 20, bottom: 10),
                      child: isShowBlackTitle
                          ? Image.asset(
                        Constant.ASSETS_IMG + 'userinfo_search_black.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        Constant.ASSETS_IMG + 'userinfo_search_white.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(right: 10, top: 20, bottom: 10),
                      child: isShowBlackTitle
                          ? Image.asset(
                        Constant.ASSETS_IMG + 'userinfo_more_black.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        Constant.ASSETS_IMG + 'userinfo_more_white.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Container(
                      height: 210,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                Constant.ASSETS_IMG + 'hot_search_top.png',
                              ),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ),
              ];
            },
            body: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(top: 8, bottom: 5, left: 10),
                    color: Color(0xffEEEEEE),
                    child: Text(
                      "实时热点,每分钟更新一次",
                      style:
                      TextStyle(fontSize: 12, color: Color(0xff333333)),
                    ),
                  ),
                ),
                SliverList(delegate: SliverChildBuilderDelegate((context,index){
                  return hotSearchItem(index);
                },childCount: mHotSearchList.length))
              ],
            ),
          )),
          Container(
            color: Color(0xffF9F9F9),
            height: 45,
            child:  Row(
              children: <Widget>[
                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      Constant.ASSETS_IMG +
                          'hot_search_bottom1.png',
                      width: 20,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      "热搜榜",
                      style: TextStyle(
                          color: Color(0xffE0905D),
                          fontSize: 12),
                    )
                  ],
                ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Color(0xffE7E7E7),
                ),
                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      Constant.ASSETS_IMG +
                          'hot_search_bottom2.png',
                      width: 20,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      "话题榜",
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 12),
                    )
                  ],
                ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Color(0xffE7E7E7),
                ),
                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      Constant.ASSETS_IMG +
                          'hot_search_bottom3.png',
                      width: 20,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      "要闻榜",
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 12),
                    )
                  ],
                ),
                )
              ],
            ),
          )
        ],),
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification &&
              scrollNotification.depth == 0) {
            //滚动并且是列表滚动的时候
            _onScroll(scrollNotification.metrics.pixels);
          }
        },
      )),
    ));
  }

  Widget hotSearchItem(int index) {
    Widget mHotSearchTypeWidget;

    if ("1" == mHotSearchList[index].hottype) {
      mHotSearchTypeWidget = Image.asset(
        Constant.ASSETS_IMG + 'find_hs_hot.jpg',
        width: 17.0,
        height: 17.0,
      );
    } else if ("2" == mHotSearchList[index].hottype) {
      mHotSearchTypeWidget = Image.asset(
        Constant.ASSETS_IMG + 'find_hs_new.jpg',
        width: 17.0,
        height: 17.0,
      );
    } else if ("3" == mHotSearchList[index].hottype) {
      mHotSearchTypeWidget = Image.asset(
        Constant.ASSETS_IMG + 'find_hot_rec.jpg',
        width: 17.0,
        height: 17.0,
      );
    } else if ("null" == mHotSearchList[index].hottype) {
      mHotSearchTypeWidget = Container(
        height: 17.0,
      );
    }

      return Container(
      child:Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15),
            height: 40,
            child:  Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Text("${(index+1)}",style: TextStyle(fontFamily: 'HotSearch',fontSize: 16,color: Colors.red),),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child:Text(mHotSearchList[index].hotdesc + "",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      )) ,
                ),
                Container(
                  child: Text(mHotSearchList[index].hotread + "",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      )),
                ),
                Container(
                  child: Text(
                      String.fromCharCode(mHotSearchList[index].hotattitude) +//将 Unicode 编码转为一个字符:
                          "",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      )),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: mHotSearchTypeWidget,
                ),
              ],
            ),
          ),
          Container(
            height: 0.5,
            color: Color(0xffE6E4E3),
          )
        ],
      ),
    );
  }

  //判断滚动改变透明度
  void _onScroll(offset) {
    if (offset > 100) {
      setState(() {
        isShowBlackTitle = true;
      });
    } else {
      setState(() {
        isShowBlackTitle = false;
      });
    }
  }
}
