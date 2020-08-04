import 'dart:async';

import 'package:dio/dio.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart' hide NestedScrollView;
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/model/WeiBoCommentList.dart';
import 'package:flutterhybridandroid/model/WeiBoDetail.dart';
import 'package:flutterhybridandroid/model/WeiBoForwardList.dart';
import 'package:flutterhybridandroid/model/WeiBoModel.dart';
import 'package:flutterhybridandroid/pages/commentdialogpage.dart';
import 'package:flutterhybridandroid/routers/routers.dart';
import 'package:flutterhybridandroid/util/date_util.dart';
import 'package:flutterhybridandroid/util/toast_util.dart';
import 'package:flutterhybridandroid/util/user_util.dart';
import 'package:flutterhybridandroid/widgets/likeButton/like_button.dart';
import 'package:flutterhybridandroid/widgets/likeButton/utils/like_button_model.dart';
import 'package:flutterhybridandroid/widgets/weibo/wbheadwidget.dart';
import 'package:flutterhybridandroid/widgets/weiboitem/WeiBoItem.dart';
import 'package:flutterhybridandroid/widgets/sharewidget.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'dart:math' as math;
import 'dart:convert' as convert;

import 'weibo_retweet_page.dart';

//刷新状态枚举
enum LoadingStatus {
  //正在加载中
  STATUS_LOADING,
  //数据加载完毕
  STATUS_COMPLETED,
  //空闲状态
  STATUS_IDEL
}

//刷新状态枚举
enum LoadingStatus1 {
  //正在加载中
  STATUS_LOADING,
  //数据加载完毕
  STATUS_COMPLETED,
  //空闲状态
  STATUS_IDEL
}

class WeiBoDetailPage extends StatefulWidget {
  final WeiBoModel mModel;

  WeiBoDetailPage({Key key, this.mModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WeiBoDetailPageState();
  }
}

class _WeiBoDetailPageState extends State<WeiBoDetailPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  final List<String> _tabValues = [
    '转发',
    '评论',
  ];
  List<Comment> mCommentList = [];
  List<Forward> mForwardList = [];
  int mCommentCurPage = 1;
  int mForwardCurPage = 1;
  int mCommenttotalCount = 20;
  int mForwardtotalCount = 20;

  var loadingStatus = LoadingStatus.STATUS_IDEL;
  var loadingStatus1 = LoadingStatus1.STATUS_IDEL;
  ScrollController mCommentScrollController = new ScrollController();

  @override
  void initState() {
    getWeiBoDeatilData();

    super.initState();
    _controller = TabController(
      length: _tabValues.length, //Tab页数量
      vsync: ScrollableState(), //动画效果的异步处理
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      child: WbHeadWidget("微博正文"),
                    )
                  ],
                ),
              ),
              Container(
                color: Color(0xffEFEFEF),
                height: 8,
              ),
              Expanded(
                  child: NestedScrollView(
                      headerSliverBuilder: (context, bool) {
                        return <Widget>[
                          SliverToBoxAdapter(
                            child: Container(
                              child: WeiBoItemWidget(
                                mModel: widget.mModel,
                                isDetail: true,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              child: ShareWidget(),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(height: 8, color: Color(0xffEFEFEF)),
                          ),
                          SliverPersistentHeader(delegate:_SliverAppBarDelegate2(Container(
                            color: Colors.white,
                            height: 50,
                            child: Row(
                              children: <Widget>[
                                TabBar(
                                  tabs: [
                                    new Tab(
                                      text: _tabValues[0] +
                                          widget.mModel.zhuanfaNum.toString(),
                                    ),
                                    new Tab(
                                      text: _tabValues[1] +
                                          widget.mModel.commentNum.toString(),
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
                                  controller: _controller,
                                ),
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: Text(
                                    "赞" + "${widget.mModel.commentNum}",
                                    style: TextStyle(color: Color(0xff666666)),
                                  ),
                                )
                              ],
                            ),
                          ),) ,pinned: true,floating: true,)
                        ];
                      },
                      //2.[inner scrollables in tabview sync issue](https://github.com/flutter/flutter/issues/21868)
                      innerScrollPositionKeyBuilder: () {
                        String index = 'Tab';

                        index += _controller.index.toString();

                        return Key(index);
                      },
                      body: Column(
                        children: <Widget>[

                          Expanded(
                              child: TabBarView(
                                  controller: _controller,
                                  children: <Widget>[
                                    buildForwardNestedScrollViewInnerScrollPositionKeyWidget(),
                                    buildCommentNestedScrollViewInnerScrollPositionKeyWidget()
//                            TabViewItem(Key('Tab0'), _controller,mCommentCurPage),
//                            TabViewItem(Key('Tab1'), _controller,mForwardCurPage)
                                  ]))
                        ],
                      ))),
              Container(
                height: 40,
                child: _detailBottom(widget.mModel),
                color: Color(0xffF9F9F9),
              )
            ],
          ),
        ));
  }

  Future getWeiBoDeatilData() async {
    FormData params = FormData.fromMap({
      'weiboid': widget.mModel.weiboId,
    });
    DioManager.getInstance().post(ServiceUrl.getWeiBoDetail, params, (data) {
      mForwardList.clear();
      mForwardList.addAll(WeiBoDetail.fromJson(data['data']).forward);
      mCommentList.clear();
      mCommentList.addAll(WeiBoDetail.fromJson(data['data']).comment);
      mCommentCurPage = 1;
      mForwardCurPage = 1;
      setState(() {});
    }, (error) {});
  }

  NestedScrollViewInnerScrollPositionKeyWidget
  buildCommentNestedScrollViewInnerScrollPositionKeyWidget() {
    return NestedScrollViewInnerScrollPositionKeyWidget(
      Key('Tab1'),
      NotificationListener(
        child: new ListView.builder(
          physics: const ClampingScrollPhysics(),
          key: const PageStorageKey<String>('Tab1'), //保持各个Tabview互不影响
          itemCount: mCommentList.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                margin: EdgeInsets.only(right: 15, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Image.asset(
                      Constant.ASSETS_IMG + 'weibo_comment_shaixuan.png',
                      width: 15.0,
                      height: 17.0,
                    ),
                    Container(
                      child: Text('按热度',
                          style: TextStyle(
                              color: Color(0xff596D86), fontSize: 12)),
                      margin: EdgeInsets.only(left: 5.0),
                    ),
                  ],
                ),
              );
            } else if (index == mCommentList.length + 1) {
              return _buildLoadMore();
            } else {
              return getContentItem(context, index, mCommentList);
            }
          },
        ),
        onNotification: (ScrollNotification scrollInfo) {
          _onScrollNotification(scrollInfo);
        },
      ),
    );
  }

  _onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      //滑到了底部
      print("滑动到了底部");
      if (loadingStatus == LoadingStatus.STATUS_IDEL) {
        setState(() {
          loadingStatus = LoadingStatus.STATUS_LOADING;
        });

        if (mCommentList.length < mCommenttotalCount) {
          setState(() {
            mCommentCurPage += 1;
          });
          getCommentDataLoadMore(mCommentCurPage);
        } else {
          setState(() {
            loadingStatus = LoadingStatus.STATUS_COMPLETED;
          });
        }
      }
    }
  }

  Future getCommentDataLoadMore(int mCurPage) async {
    FormData formData = FormData.fromMap({
      "pageNum": mCurPage,
      "pageSize": Constant.PAGE_SIZE,
      "weiboid": widget.mModel.weiboId
    });

    await DioManager.getInstance()
        .post(ServiceUrl.getWeiBoDetailComment, formData, (data) {
      CommentList mComment = CommentList.fromJson(data['data']);
      setState(() {
        loadingStatus = LoadingStatus.STATUS_IDEL;
        mCommenttotalCount = data['data']['total'];
        if (mCommentList.length < mCommenttotalCount) {
          mCommentList.addAll(mComment.list);
        }
      });
    }, (error) {
      setState(() {
        loadingStatus = LoadingStatus.STATUS_IDEL;
      });
    });
  }

  Widget getContentItem(
      BuildContext context, int index, List<Comment> mFindHotList) {
    Widget mCommentReplyWidget;
    if (mCommentList[index - 1].commentreplynum == 0) {
    } else if (mCommentList[index - 1].commentreplynum == 1) {
      mCommentReplyWidget = Container(
        padding: EdgeInsets.all(5),
        child: RichText(
            text: TextSpan(
                text: mCommentList[index - 1].commentreply[0].fromuname + ": ",
                style: TextStyle(fontSize: 12.0, color: Color(0xff45587E)),
                children: <TextSpan>[
                  TextSpan(
                    text: mCommentList[index - 1].commentreply[0].content,
                    style: TextStyle(fontSize: 12.0, color: Color(0xff333333)),
                  )
                ])),
      );
    } else if (mCommentList[index - 1].commentreplynum == 2) {
      mCommentReplyWidget = new Container(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //margin: EdgeInsets.only(top: 2),
                  child: RichText(
                      text: TextSpan(
                          text: mCommentList[index - 1]
                              .commentreply[0]
                              .fromuname +
                              ": ",
                          style: TextStyle(
                              fontSize: 12.0, color: Color(0xff45587E)),
                          children: <TextSpan>[
                            TextSpan(
                              text: mCommentList[index - 1].commentreply[0].content,
                              style:
                              TextStyle(fontSize: 12.0, color: Color(0xff333333)),
                            )
                          ]))),
              Container(
                  margin: EdgeInsets.only(top: 3),
                  child: RichText(
                      text: TextSpan(
                          text: mCommentList[index - 1]
                              .commentreply[1]
                              .fromuname +
                              ": ",
                          style: TextStyle(
                              fontSize: 12.0, color: Color(0xff45587E)),
                          children: <TextSpan>[
                            TextSpan(
                              text: mCommentList[index - 1].commentreply[1].content,
                              style: TextStyle(
                                  fontSize: 12.0, color: Color(0xff333333)),
                            )
                          ]))),
            ],
          ));
    } else {
      mCommentReplyWidget = new Container(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              //margin: EdgeInsets.only(top: 2),
                child: RichText(
                    text: TextSpan(
                        text:
                        mCommentList[index - 1].commentreply[0].fromuname +
                            ": ",
                        style:
                        TextStyle(fontSize: 12.0, color: Color(0xff45587E)),
                        children: <TextSpan>[
                          TextSpan(
                            text: mCommentList[index - 1].commentreply[0].content,
                            style: TextStyle(fontSize: 12.0, color: Color(0xff333333)),
                          )
                        ]))),
            Container(
                margin: EdgeInsets.only(top: 3),
                child: RichText(
                    text: TextSpan(
                        text:
                        mCommentList[index - 1].commentreply[1].fromuname +
                            ": ",
                        style:
                        TextStyle(fontSize: 12.0, color: Color(0xff45587E)),
                        children: <TextSpan>[
                          TextSpan(
                            text: mCommentList[index - 1].commentreply[1].content,
                            style:
                            TextStyle(fontSize: 12.0, color: Color(0xff333333)),
                          )
                        ]))),
            Container(
              margin: EdgeInsets.only(top: 2),
              child: Row(
                children: <Widget>[
                  Text(
                    "共" +
                        mCommentList[index - 1].commentreplynum.toString() +
                        "条回复 >",
                    style: TextStyle(color: Color(0xff45587E), fontSize: 12),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: mCommentList[index - 1].fromuserisvertify == 0
                  ? CircleAvatar(
                  radius: 20,
                  backgroundImage:
                  NetworkImage(mCommentList[index - 1].fromhead))
                  : Stack(
                children: <Widget>[
                  CircleAvatar(
                      radius: 20,
                      backgroundImage:
                      NetworkImage(mCommentList[index - 1].fromhead)),
                  Positioned(
                    child: Container(
                      child: Image.asset(
                        (mCommentList[index - 1].fromuserisvertify == 1)
                            ? Constant.ASSETS_IMG + 'home_vertify.webp'
                            : Constant.ASSETS_IMG + 'home_vertify2.webp',
                        width: 15.0,
                        height: 15.0,
                      ),
                    ),
                    right: 0,
                    bottom: 0,
                  )
                ],
              )),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: new Text(
                        mCommentList[index - 1].fromuname,
                        style: TextStyle(
                            fontSize: 14,
                            color: mCommentList[index - 1].fromuserismember == 0
                                ? Colors.black
                                : Colors.orange),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      child: Center(
                        child: mCommentList[index - 1].fromuserismember == 0
                            ? new Container()
                            : Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Image.asset(
                            Constant.ASSETS_IMG + 'home_memeber.webp',
                            width: 15.0,
                            height: 13.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 3),
                  child: new Text(
                    mCommentList[index - 1].content,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(//评论区
                  onTap: () {
                    Routes.navigateTo(context, Routes.weiboCommentDetailPage,
                        params: {
                          'comment':
                          convert.jsonEncode(mCommentList[index - 1]),
                        },
                        transition: TransitionType.fadeIn);
                  },
                  child: Container(
                    decoration: new BoxDecoration(
                      //背景
                      color: Color(0xffF7F7F7),
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    margin: EdgeInsets.only(right: 15),
                    child: mCommentReplyWidget,
                  ),
                ),
                Container(
                  height: 30,
                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          DateUtil.getFormatTime2(
                              DateTime.fromMillisecondsSinceEpoch(
                                  mCommentList[index - 1].createtime)),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Image.asset(
                          Constant.ASSETS_IMG + 'icon_retweet.png',
                          width: 15.0,
                          height: 15.0,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Image.asset(
                          Constant.ASSETS_IMG + 'icon_comment.png',
                          width: 15.0,
                          height: 15.0,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Image.asset(
                          Constant.ASSETS_IMG + 'icon_like.png',
                          width: 15.0,
                          height: 15.0,
                        ),
                      )
                    ],
                  ),
                ),//时间区
                Container(
                  margin: EdgeInsets.only(top: 7, bottom: 7),
                  height: 0.5,
                  color: Color(0xffE6E4E3),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoadMore() {
    if (loadingStatus == LoadingStatus.STATUS_LOADING) {
      return Container(
        child: Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: SizedBox(
                    //能强制子控件具有特定宽度、高度或两者都有,使子控件设置的宽高失效
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                    height: 12.0,
                    width: 12.0,
                  ),
                ),
                Text("加载中..."),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        child: mCommentList.length < mCommenttotalCount
            ? new Container()
            : Center(
          child: Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                "没有更多数据",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )),
        ),
      );
    }
  }

  NestedScrollViewInnerScrollPositionKeyWidget
  buildForwardNestedScrollViewInnerScrollPositionKeyWidget() {
    return NestedScrollViewInnerScrollPositionKeyWidget(
      Key('Tab0'),
      NotificationListener(
        child: new ListView.builder(
          physics: const ClampingScrollPhysics(),
          key: const PageStorageKey<String>('Tab0'), //保持各个Tabview互不影响
          itemCount: mForwardList.length + 1,
          itemBuilder: (context, index) {
            if (index == mForwardList.length) {
              return _buildLoadMore1();
            } else {
              return getContentItem1(context, index, mForwardList);
            }
          },
        ),
        onNotification: (ScrollNotification scrollInfo) {
          _onScrollNotification1(scrollInfo);
        },
      ),
    );
  }

  void _onScrollNotification1(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      //滑到了底部
      print("滑动到了底部");
      if (loadingStatus1 == LoadingStatus1.STATUS_IDEL) {
        setState(() {
          loadingStatus1 = LoadingStatus1.STATUS_LOADING;
        });

        if (mForwardList.length < mForwardtotalCount) {
          setState(() {
            mForwardCurPage += 1;
          });
          getForwardDataLoadMore(mForwardCurPage);
        } else {
          setState(() {
            loadingStatus1 = LoadingStatus1.STATUS_COMPLETED;
          });
        }
      }
    }
  }

  void getForwardDataLoadMore(int mForwardCurPage) {
    FormData formData = FormData.fromMap({
      "pageNum": mForwardCurPage,
      "pageSize": Constant.PAGE_SIZE,
      "weiboid": widget.mModel.weiboId
    });
    DioManager.getInstance().post(ServiceUrl.getWeiBoDetailForward, formData,
            (data) {
          ForwardList mForward = ForwardList.fromJson(data['data']);
          setState(() {
            loadingStatus1 = LoadingStatus1.STATUS_IDEL;
            mForwardtotalCount = data['data']['total'];
            if (mForwardList.length < mForwardtotalCount) {
              mForwardList.addAll(mForward.list);
            }
          });
        }, (error) {
          setState(() {
            loadingStatus1 = LoadingStatus1.STATUS_IDEL;
          });
        });
  }

  Widget getContentItem1(
      BuildContext context, int index, List<Forward> mForwardList) {
    return Container(
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: mForwardList[index].fromuserisvertify == 0
                    ? CircleAvatar(
                    radius: 20,
                    backgroundImage:
                    NetworkImage(mForwardList[index].fromhead))
                    : Stack(
                  children: <Widget>[
                    CircleAvatar(
                        radius: 20,
                        backgroundImage:
                        NetworkImage(mForwardList[index].fromhead)),
                    Positioned(
                      child: Container(
                        child: Image.asset(
                          (mForwardList[index].fromuserisvertify == 1)
                              ? Constant.ASSETS_IMG + 'home_vertify.webp'
                              : Constant.ASSETS_IMG +
                              'home_vertify2.webp',
                          width: 15.0,
                          height: 15.0,
                        ),
                      ),
                      right: 0,
                      bottom: 0,
                    )
                  ],
                )),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        mForwardList[index].fromuname,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Container(
                      child: Text(
                        mForwardList[index].content,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        DateUtil.getFormatTime2(DateTime.fromMillisecondsSinceEpoch(
                            mForwardList[index].createtime)),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 7, bottom: 7),
                      height: 0.5,
                      color: Color(0xffE6E4E3),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMore1() {
    if (loadingStatus1 == LoadingStatus1.STATUS_LOADING) {
      return Container(
        child: Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: SizedBox(
                    //能强制子控件具有特定宽度、高度或两者都有,使子控件设置的宽高失效
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                    height: 12.0,
                    width: 12.0,
                  ),
                ),
                Text("加载中..."),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        child: mForwardList.length < mForwardtotalCount
            ? new Container()
            : Center(
          child: Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                "没有更多数据",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )),
        ),
      );
    }
  }

  //转发收藏点赞布局
  _detailBottom(WeiBoModel mModel) {
    return Row(
      children: <Widget>[
        Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return RetWeetPage(
                    mModel: mModel,
                  );
                }));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    Constant.ASSETS_IMG + 'icon_retweet.png',
                    width: 20.0,
                    height: 20.0,
                  ),
                  Container(
                    child: Text('转发',
                        style: TextStyle(color: Colors.black, fontSize: 13)),
                    margin: EdgeInsets.only(left: 5.0),
                  ),
                ],
              ),
            )),
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          width: 1.0,
          color: Colors.black12,
        ),
        Expanded(
            child: InkWell(
              onTap: (){
                Navigator.of(context).push(PageRouteBuilder(opaque: false,pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                  return CommentDialogPage(mModel.weiboId, false, (){
                    //评论成功从新获取数据
                    mCommentScrollController.animateTo(0,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.ease);
                    getWeiBoDeatilData();
                  });
                }));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    Constant.ASSETS_IMG + 'icon_comment.png',
                    width: 20.0,
                    height: 20.0,
                  ),
                  Container(
                    child: Text('评论',
                        style: TextStyle(color: Colors.black, fontSize: 13)),
                    margin: EdgeInsets.only(left: 5.0),
                  ),
                ],
              ),
            )),
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          width: 1.0,
          color: Colors.black12,
        ),
        Expanded(
            child: LikeButton(
              isLiked: mModel.zanStatus == 1,
              onTap: (bool isLiked) {
                return onLikeButtonTapped(isLiked, mModel);
              },
              size: 21,
              circleColor:
              CircleColor(start: Colors.orange, end: Colors.deepOrange),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Colors.orange,
                dotSecondaryColor: Colors.deepOrange,
              ),
              likeBuilder: (bool isLiked) {
                return /*Icon(
                    Icons.home,
                    color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                    size: 20,
                  )*/
                  Image.asset(
                    isLiked
                        ? Constant.ASSETS_IMG + 'ic_home_liked.webp'
                        : Constant.ASSETS_IMG + 'ic_home_like.webp',
                    width: 21.0,
                    height: 21.0,
                  );
              },
              likeCount: mModel.likeNum,
              countBuilder: (int count, bool isLiked, String text) {
                var color = isLiked ? Colors.orange : Colors.black;
                Widget result;
                if (count == 0) {
                  result = Text(
                    "",
                    style: TextStyle(color: color, fontSize: 13),
                  );
                } else
                  result = Text(
                    text,
                    style: TextStyle(color: color, fontSize: 13),
                  );
                return result;
              },
            ))
      ],
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked, WeiBoModel weiboItem) async {
    final Completer<bool> completer = new Completer<bool>();

    FormData formData = FormData.fromMap({
      "weiboId": weiboItem.weiboId,
      "userId": UserUtil.getUserInfo().id,
      "status": weiboItem.zanStatus == 0 ? 1 : 0, //1点赞,0取消点赞
    });
    DioManager.getInstance().post(ServiceUrl.zanWeiBo, formData, (data) {
      if (weiboItem.zanStatus == 0) {
        //点赞成功
        weiboItem.zanStatus = 1;
        weiboItem.likeNum++;
        completer.complete(true);
      } else {
        //取消点赞成功
        weiboItem.zanStatus = 0;
        weiboItem.likeNum--;
        completer.complete(false);
      }
    }, (error) {
      if (weiboItem.zanStatus == 0) {
        completer.complete(false);
      } else {
        completer.complete(true);
      }
    });

    return completer.future;
  }
}
class _SliverAppBarDelegate2 extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate2(this._tabBar);

  final Widget _tabBar;

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