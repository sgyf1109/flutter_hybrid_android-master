import 'package:dio/dio.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/model/FindHomeModel.dart';
import 'package:flutterhybridandroid/model/WeiBoModel.dart';
import 'package:flutterhybridandroid/routers/routers.dart';
import 'package:flutterhybridandroid/util/user_util.dart';
import 'package:flutterhybridandroid/widgets/MyNoticeVecAnimation.dart';
import 'dart:math' as math;

import 'package:flutterhybridandroid/widgets/weiboitem/WeiBoItem.dart';

import 'getfindinfodate.dart';
import 'common.dart';

class FindPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FindPageState();
  }
}

class _FindPageState extends State<FindPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  //活动导航
  bool isFindKindVisible = false;
  TabController primaryTC;
  List<Findhottop> mTopHotSearchList = []; //顶部热搜列表
  List<Findkind> mFindKindList = []; //发现类型列表
  Findhotcenter mFindCenter;
  List<WeiBoModel> mFindHotList = []; //热点列表
  List<WeiBoModel> mFindLocalList = []; //本地列表
  Findtopic mFindTopic; //话题模块
  List<WeiBoModel> mSuperTopicList = []; //超话列表
  final List<String> _tabValues = [
    '热点',
    '本地',
    '话题',
    '超话',
  ];
  final List<String> _HomeSearchValues = [
    '大家正在搜:  hrl本地微博上线啦!',
    '大家正在搜:  hrl话题微博上线啦!',
    '大家正在搜:  hrl超话微博上线啦!',
    '大家正在搜:  hrl热点微博上线啦!',
  ];
  bool _loading = true; //页面加载状态
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  int index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    primaryTC = TabController(
      length: _tabValues.length, //Tab页数量
      vsync: this, //动画效果的异步处理
    )..addListener(() {
        if (index != primaryTC.index) {
          //your code
          index = primaryTC.index;
        }
      });
    getFindInfoDate();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double mHotSerachTopGridItemHeight = 30;
    final double mHotSerachTopGridItemWidth = size.width / 2;
    final double mFindKindGridItemHeight = 60;
    final double mFindKindGridItemWidth = size.width / 6;

    //使用NestedScrollViewRefreshIndicator代替RefreshIndicator,解决RefreshIndicatorNestedScrollView与冲突的问题
    //https://juejin.im/post/5beb91275188251d9e0c1d73
    return Material(
      color: Colors.white,
      child: NestedScrollViewRefreshIndicator(
        child: NestedScrollView(
            innerScrollPositionKeyBuilder: () {
              String index = 'Tab';
              index += primaryTC.index.toString();
              return Key(index);
            },
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 10, top: 15, right: 10),
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Color(0xffE4E2E8),
                      borderRadius: BorderRadius.all(
                        //圆角
                        Radius.circular(5.0),
                      ),
                    ),
                    child: Center(
                      child: MyNoticeVecAnimation(messages: _HomeSearchValues),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset(
                              Constant.ASSETS_IMG + 'find_search.png',
                              width: 22.0,
                              height: 25.0,
                            ),
                            Text(
                              '微博热搜',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                /*  SliverChildListDelegate一般用来构item建数量明确的列表，会提前build好所有的子item，所以在效率上会有问题，适合item数量不多的情况（不超过一屏）。
          SliverChildBuilderDelegate构建的列表理论上是可以无限长的，因为使用来lazily construct优化。 （两者的区别有些类似于ListView和ListView.builder()的区别。）*/
                SliverList(
                    delegate: SliverChildListDelegate([
                  Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 120,
                            child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 0.0,
                                        crossAxisSpacing: 0.0,
                                        childAspectRatio:
                                            (mHotSerachTopGridItemWidth /
                                                mHotSerachTopGridItemHeight),
                                        crossAxisCount: 2),
                                itemCount: mTopHotSearchList.length + 1,
                                itemBuilder: (
                                  BuildContext context,
                                  int index,
                                ) {
                                  return mHotSearchTopItem(
                                    context,
                                    index,
                                    mTopHotSearchList,
                                  );
                                }),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 15),
                              width: 1,
                              color: Color(0xffE4E4E4),
                              height: 90,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 10,
                        color: Color(0xffEEEEEE),
                      ),
                    ],
                  )
                ])),
                SliverToBoxAdapter(
                  child: Container(
                    height: isFindKindVisible
                        ? mFindKindGridItemHeight * 3
                        : mFindKindGridItemHeight,
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
//                        childAspectRatio:
//                        (mFindKindGridItemWidth / mFindKindGridItemHeight),
                      ),
                      itemBuilder: (context, index) {
                        return mFindKindItem(context, index, mFindKindList);
                      },
                      itemCount:
                          isFindKindVisible ? mFindKindList.length + 1 : 6,
                      primary: false,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 190,
                    child: ConstrainedBox(
                        constraints: BoxConstraints.loose(Size(300, 100)),
                        child: Swiper(
                            pagination: SwiperPagination(
                                alignment: Alignment.bottomRight,
                                builder: DotSwiperPaginationBuilder(
                                    color: Color(0xffF0F0F0),
                                    activeColor: Colors.orange,
                                    size: 7,
                                    space: 2,
                                    activeSize: 7)),
                            itemCount: mFindCenter == null ? 0 : 5,
                            itemBuilder: (BuildContext context, int index) {
                              return mCenterBannerItemWidegt(index);
                            })),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 10,
                    color: Color(0xffEEEEEE),
                  ),
                ),
                SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                        minHeight: 50,
                        maxHeight: 50,
                        child: Container(
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
                              new Tab(
                                text: _tabValues[2],
                              ),
                              new Tab(
                                text: _tabValues[3],
                              ),
                            ],
                            isScrollable: true,
                            indicatorColor: Color(0xffFF3700),
                            indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(
                                    color: Color(0xffFF3700), width: 2),
                                insets: EdgeInsets.only(bottom: 7)),
                            labelColor: Color(0xff333333),
                            unselectedLabelColor: Color(0xff666666),
                            labelStyle: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w700),
                            unselectedLabelStyle: TextStyle(fontSize: 16.0),
                            indicatorSize: TabBarIndicatorSize.label,
                            controller: primaryTC,
                          ),
                        )))
              ];
            },
            body: Column(
              children: <Widget>[
                Expanded(
                  child: TabBarView(
                    controller: primaryTC,
                    children: <Widget>[
                      //这种方式也可以实现保存状态
//                      new ListView.builder(
//                        key: PageStorageKey<String>("tab1"),
//                        itemCount: mFindHotList.length,
//                        itemBuilder: (context, index) {
//                          return getContentItem(context, index, mFindHotList);
//                        },
//                      ),
//                      new ListView.builder(
//                        key: PageStorageKey<String>("tab2"),
//
//                        itemCount: mFindLocalList.length,
//                        itemBuilder: (context, index) {
//                          return getContentItem(context, index, mFindLocalList);
//                        },
//                      ),
//                      (mFindTopic == null)
//                          ? new Container()
//                          : FindTopicPage(mModel: mFindTopic),
//                      new ListView.builder(
//                        key: PageStorageKey<String>("tab4"),
//                        itemCount: mSuperTopicList.length,
//                        itemBuilder: (context, index) {
//                          return getContentItem(
//                              context, index, mSuperTopicList);
//                        },
//                      ),
                      NestedScrollViewInnerScrollPositionKeyWidget(
                        Key('Tab0'),
                        new ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          key: const PageStorageKey<String>('Tab0'),
                          itemCount: mFindHotList.length,
                          itemBuilder: (context, index) {
                            return getContentItem(context, index, mFindHotList);
                          },
                        ),
                      ),
                      NestedScrollViewInnerScrollPositionKeyWidget(
                        Key('Tab1'),
                        new ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          key: const PageStorageKey<String>('Tab1'),
                          itemCount: mFindHotList.length,
                          itemBuilder: (context, index) {
                            return getContentItem(
                                context, index, mFindLocalList);
                          },
                        ),
                      ),
                      NestedScrollViewInnerScrollPositionKeyWidget(
                        Key('Tab2'),
                        (mFindTopic == null)
                            ? new Container()
                            : FindTopicPage(mModel: mFindTopic),
                      ),
                      NestedScrollViewInnerScrollPositionKeyWidget(
                        Key('Tab3'),
                        new ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          key: const PageStorageKey<String>('Tab3'),
                          itemCount: mFindHotList.length,
                          itemBuilder: (context, index) {
                            return getContentItem(
                                context, index, mSuperTopicList);
                          },
                        ),
                      ),
//                      TabViewItem(Key('Tab0'), true),
//                      TabViewItem(Key('Tab1'), true),
//                      TabViewItem(Key('Tab2'), true),
//                      TabViewItem(Key('Tab3'), true),
                    ],
                  ),
                )
//                Expanded(child: SecondaryTabView('Tab', primaryTC, true),
//                )
              ],
            )),
        onRefresh: getFindInfoDate,
      ),
    );
  }

  getContentItem(BuildContext context, int index, List<WeiBoModel> mList) {
    WeiBoModel model = mList[index];
    // return model.momentType == 0 ? getItemTextContainer(model, index) : getItemImageContainer(model, index);
    return InkWell(
      onTap: () {
//        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
//          return WeiBoDetailPage(
//            mModel: model,
//          );
//        }));
      },
      child: WeiBoItemWidget(
        mModel: model,
        isDetail: false,
      ),
    );
  }

  //获取发现页信息
  Future<Null> getFindInfoDate() async {
    FormData formData = FormData.fromMap({"userId": UserUtil.getUserInfo().id});
    DioManager.getInstance().post(ServiceUrl.getFindHomeInfo, formData, (data) {
      print("返回的正确数据:${data}");
      FindHomeModel mModel = FindHomeModel.fromJson(data['data']);
      setState(() {
        mTopHotSearchList = mModel.findhottop;
        mFindKindList = mModel.findkind;
        mFindCenter = mModel.findhotcenter;
        mFindTopic = mModel.findtopic;
        mFindHotList = mModel.findhot;
        mFindLocalList = mModel.findlocal;
        mSuperTopicList = mModel.findsupertopic;
        _loading = false;
      });
    }, (error) {
      _loading = false;
    });

    return null;
  }

  Widget mHotSearchTopItem(
      BuildContext context, int index, List<Findhottop> mTopHotSearchList) {
    Widget mHotSearchTypeWidget;

    if (index == mTopHotSearchList.length) {
      return InkWell(
        onTap:(){
          Routes.navigateTo(context, Routes.hotSearchPage);
        },
          child: Container(
        margin: EdgeInsets.only(left: 10),
        child: Row(
          children: <Widget>[
            Text(
              "更多热搜",
              maxLines: 1,
              style: TextStyle(fontSize: 15, color: Color(0xffFB7A0E)),
            ),
            Image.asset(
              Constant.ASSETS_IMG + 'find_hs_more.png',
              width: 20.0,
              height: 20.0,
            ),
          ],
        ),
      ));
    } else {
      if ("1" == mTopHotSearchList[index].hottype) {
        mHotSearchTypeWidget = Image.asset(
          Constant.ASSETS_IMG + 'find_hs_hot.jpg',
          width: 17.0,
          height: 17.0,
        );
      } else if ("2" == mTopHotSearchList[index].hottype) {
        mHotSearchTypeWidget = Image.asset(
          Constant.ASSETS_IMG + 'find_hs_new.jpg',
          width: 17.0,
          height: 17.0,
        );
      } else if ("3" == mTopHotSearchList[index].hottype) {
        mHotSearchTypeWidget = Image.asset(
          Constant.ASSETS_IMG + 'find_hot_rec.jpg',
          width: 17.0,
          height: 17.0,
        );
      } else if ("null" == mTopHotSearchList[index].hottype) {
        mHotSearchTypeWidget = Container();
      }
      return Container(
        margin: EdgeInsets.only(left: 10, right: 5),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Routes.navigateTo(
              context,
              Routes.topicDetailPage,
              params: {
                'mTitle': mTopHotSearchList[index].hotdesc,
                'mImg': mTopHotSearchList[index].recommendcoverimg,
                'mReadCount': mTopHotSearchList[index].hotread,
                'mDiscussCount': mTopHotSearchList[index].hotdiscuss,
                'mHost': mTopHotSearchList[index].hothost,
              },
            );
          },
          child: Row(
            children: <Widget>[
              //与Expanded组件不同，它不强制子组件填充可用空间。
              Flexible(
                  child: Text(mTopHotSearchList[index].hotdesc + "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, color: Colors.black))),
              Container(
                child: mHotSearchTypeWidget,
              )
            ],
          ),
        ),
      );
    }
  }

  Widget mFindKindItem(
      BuildContext context, int index, List<Findkind> mItemList) {
    if (mItemList.length == 0) return new Container();
    Widget mKindChild;
    if (index == 0 || index == 1 || index == 2 || index == 3 || index == 4)
      mKindChild = Container(
        height: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.network(
              mItemList[index].img,
              fit: BoxFit.cover,
              width: 30,
              height: 30,
            ),
            Text(mItemList[index].name + "",
                style: TextStyle(fontSize: 12, color: Colors.black))
          ],
        ),
      );
    if (index == 5) {
      mKindChild = Container(
        height: 60,
        child: InkWell(
          onTap: () {
            isFindKindVisible = !isFindKindVisible;
            setState(() {});
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              isFindKindVisible
                  ? Image.asset(
                      Constant.ASSETS_IMG + 'find_more_top.png',
                      width: 30.0,
                      height: 30.0,
                    )
                  : Image.asset(
                      Constant.ASSETS_IMG + 'find_more_bottom.png',
                      width: 30.0,
                      height: 30.0,
                    ),
              Text(
                mItemList[index].name + "",
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    } else {
      if (index > 5) {
        mKindChild = Container(
          height: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(
                mItemList[index - 1].img,
                fit: BoxFit.cover,
                width: 30,
                height: 30,
              ),
              Text(mItemList[index - 1].name + "",
                  style: TextStyle(fontSize: 12, color: Colors.black))
            ],
          ),
        );
      }
    }
    return mKindChild;
  }

  Widget mCenterBannerItemWidegt(int i) {
    List<Findhottop> mCneterItem = [];
    if (i == 0) {
      mCneterItem = mFindCenter.page1;
    } else if (i == 1) {
      mCneterItem = mFindCenter.page2;
    } else if (i == 2) {
      mCneterItem = mFindCenter.page3;
    } else if (i == 3) {
      mCneterItem = mFindCenter.page4;
    } else if (i == 4) {
      mCneterItem = mFindCenter.page5;
    }
    return Container(
        child: Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                    image: NetworkImage(mCneterItem[0].recommendcoverimg),
                    fit: BoxFit.cover)),
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 8),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Color(0xffFB304E)),
                          padding:
                              EdgeInsets.only(left: 4, right: 5, bottom: 2),
                          child: Center(
                            child: Text("热搜",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white)),
                          ),
                        ),
                        Text(
                          "#" + mCneterItem[0].hotdesc + "#",
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 3),
                      child: Text(
                          mCneterItem[0].hotdiscuss +
                              "讨论  " +
                              mCneterItem[0].hotread +
                              "阅读",
                          style: TextStyle(fontSize: 10, color: Colors.white)),
                    )
                  ],
                ),
              ),
            ),
          ),
          flex: 3,
        ),
        Expanded(
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 2.5, bottom: 2.5, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image:
                                NetworkImage(mCneterItem[1].recommendcoverimg),
                            fit: BoxFit.cover)),
                    child: Container(
                        padding: EdgeInsets.only(left: 3, right: 3, bottom: 3),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "#" + mCneterItem[1].hotdesc + "#",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        )),
                  ),
                  flex: 1,
                ),
                new Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 2.5, top: 2.5, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                mCneterItem[2].recommendcoverimg))),
                    child: Container(
                        padding: EdgeInsets.only(left: 3, right: 3, bottom: 3),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "#" + mCneterItem[2].hotdesc + "#",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
          flex: 1,
        )
      ],
    ));
  }
}

class TabViewItem extends StatefulWidget {
  const TabViewItem(this.tabKey, this.oldDemo);

  final Key tabKey;
  final bool oldDemo;

  @override
  _TabViewItemState createState() => _TabViewItemState();
}

class _TabViewItemState extends State<TabViewItem>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ListView child = ListView.builder(
//        key:PageStorageKey<String>(widget.tabKey.toString()),//和AutomaticKeepAliveClientMixin作用一致
        physics: const ClampingScrollPhysics(),
        itemBuilder: (BuildContext c, int i) {
          return Container(
            //decoration: BoxDecoration(border: Border.all(color: Colors.orange,width: 1.0)),
            alignment: Alignment.center,
            height: 60.0,
            width: double.infinity,
            //color: Colors.blue,
            child: Text(widget.tabKey.toString() + ': List$i'),
          );
        },
        itemCount: 100,
        padding: const EdgeInsets.all(0.0));

    if (widget.oldDemo) {
      return NestedScrollViewInnerScrollPositionKeyWidget(widget.tabKey, child);
    }

    /// new one doesn't need NestedScrollViewInnerScrollPositionKeyWidget any more.
    else {
      return child;
    }
  }

  @override
  bool get wantKeepAlive => true;
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
