import 'package:flutter/material.dart' ;
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/model/OtherUserModel.dart';
import 'package:flutterhybridandroid/pages/PageInfoPic.dart';
import 'package:flutterhybridandroid/pages/PageInfoWeiBo.dart';

import 'minepage.dart';
import 'personinfohomepage.dart';
import 'weibofollowpage.dart';

class PersonInfoPage extends StatefulWidget {
  String mOtherUserId;

  PersonInfoPage(this.mOtherUserId);

  @override
  State<StatefulWidget> createState() {
    return _PersonInfoPageState();
  }
}

class _PersonInfoPageState extends State<PersonInfoPage>
    with SingleTickerProviderStateMixin {
  bool isShowBlackTitle = false;
  OtherUser mUser = new OtherUser(
      id: "0",
      username: "",
      nick: "嘻嘻哈哈",
      headurl: "",
      decs: "",
      gender: "0",
      followCount: "1314",
      fanCount: "520",
      ismember: 0,
      isvertify: 0,
      relation: 0,
      createtime: 0);
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: NotificationListener(
        child: NestedScrollView(
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
                title: isShowBlackTitle ? Text(mUser.nick) : Text(''),
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
                              Constant.ASSETS_IMG + 'ic_personinfo_bg4.png',
                            ),
                            fit: BoxFit.cover)),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                mUser.headurl == null ? "" : mUser.headurl),
                            radius: 33.0,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Text(
                                mUser.nick,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15, left: 5),
                              child: mUser.gender == "1"
                                  ? new Container(
                                child: Image.asset(
                                  Constant.ASSETS_IMG + 'mine_male.webp',
                                  width: 15,
                                  height: 15,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : new Container(
                                child: Image.asset(
                                  Constant.ASSETS_IMG + 'mine_female.png',
                                  width: 15,
                                  height: 15,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: mUser.ismember == 0
                                  ? new Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Image.asset(
                                  Constant.ASSETS_IMG +
                                      'mine_openmember.webp',
                                  width: 40.0,
                                  height: 25.0,
                                ),
                              )
                                  : Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Image.asset(
                                  Constant.ASSETS_IMG +
                                      'home_memeber.webp',
                                  width: 15.0,
                                  height: 13.0,
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "关注  " + mUser.followCount,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                height: 10,
                                width: 1,
                                margin: EdgeInsets.only(left: 15, right: 15),
                              ),
                              Container(
                                child: Text(
                                  "粉丝 " + mUser.fanCount,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            "编辑简介: " + mUser.decs,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate2(_timeSelection()),
                pinned: true,
              ),
            ];
          },
          body: Column(
            children: <Widget>[
              Expanded(
                  child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[PersonInfoHomePage(mUser.nick, mUser.decs,
                          mUser.createtime, mUser.gender), PageInfoWeiBo(), PageInfoPic()]))
            ],
          ),
        ),
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
  Widget _timeSelection() {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Container(
              height: 50,
              color: Colors.white,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 70),
              child: TabBar(
                tabs: [
                  Tab(text: '主页'),
                  Tab(text: '微博'),
                  Tab(text: '相册'),
                ],
                controller: _tabController,
                isScrollable: false,
                labelPadding: EdgeInsets.symmetric(horizontal: 10),
                indicatorColor: Colors.deepOrange,
                indicatorPadding: EdgeInsetsDirectional.only(bottom: 3),
                labelColor: Colors.black,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
                unselectedLabelColor: Color(0xff999999),
                unselectedLabelStyle:
                TextStyle(fontSize: 15, color: Colors.black),
              ),
            )
          ],
        ),
        Container(
          height: 0.5,
          color: Colors.black12,
          //  margin: EdgeInsets.only(left: 60),
        ),
      ],
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

class _SliverAppBarDelegate2 extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate2(this._tabBar);

  final Column _tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  double get maxExtent => 52;

  @override
  double get minExtent => 52;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
