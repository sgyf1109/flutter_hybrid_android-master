import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/model/WeiBoCommentList.dart';
import 'package:flutterhybridandroid/model/WeiBoDetail.dart';
import 'package:flutterhybridandroid/model/WeiBoModel.dart';
import 'package:flutterhybridandroid/routers/routers.dart';
import 'package:flutterhybridandroid/util/date_util.dart';
import 'package:flutterhybridandroid/widgets/weibo/wbheadwidget.dart';
import 'dart:convert' as convert;

import 'commentdialogpage.dart';
//评论详情界面
class WeiBoCommentDetailPage extends StatefulWidget {
  Comment mCommentTop;

  WeiBoCommentDetailPage(this.mCommentTop);

  @override
  State<StatefulWidget> createState() {
    return _WeiBoCommentDetailPageState();
  }
}

//刷新状态枚举
enum LoadingStatus {
  //正在加载中
  STATUS_LOADING,
  //数据加载完毕
  STATUS_COMPLETED,
  //空闲状态
  STATUS_IDEL
}

class _WeiBoCommentDetailPageState extends State<WeiBoCommentDetailPage> {
  List<Comment> mCommentList = [];
  int mCommentCurPage = 1;
  int mCommenttotalCount = 0;
  var loadingStatus = LoadingStatus.STATUS_IDEL;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommentDataRefresh();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("调用加载更多");
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
    });
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
                  child: WbHeadWidget("评论详情"),
                )
              ],
            ),
          ),
          Container(
            color: Color(0xffEFEFEF),
            height: 1,
          ),

          Expanded(
              child: RefreshIndicator(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child:Container(
                          child: mCommentWidget(widget.mCommentTop, true),
                        ) ,
                      ),
                      SliverToBoxAdapter(
                        child: Container(
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
                                child: Text('按时间',
                                    style: TextStyle(
                                        color: Color(0xff596D86), fontSize: 12)),
                                margin: EdgeInsets.only(left: 5.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child:  Container(
                          color: Color(0xffEFEFEF),
                          height: 1,
                        ),
                      ),
                      SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        if (index == mCommentList.length) {
                          return _buildLoadMore();
                        } else {
                          return mCommentWidget(mCommentList[index], false);
                        }
                      }, childCount: mCommentList.length + 1))
                    ],
                  ),
                  onRefresh: () {
                    getCommentDataRefresh();
                  })),
          Container(
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
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("回复评论"),
                )
              ),
              onTap:(){
                Navigator.of(context).push(PageRouteBuilder(opaque: false,pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                  return CommentDialogPage(widget.mCommentTop.weiboid, true, (){
                    //评论成功从新获取数据
                    _scrollController.animateTo(0,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.ease);
                    getCommentDataRefresh();
                  });
                }));
              },
            ),
          )
        ],
      ),
    ));
  }

  Future getCommentDataRefresh() async {
    FormData formData = FormData.fromMap({
      'commentid': widget.mCommentTop.commentid,
      "pageNum": "1",
      "pageSize": Constant.PAGE_SIZE,
    });

    DioManager.getInstance().post(ServiceUrl.getWeiBoCommentReplyList, formData,
            (data) {
              CommentList mComment = CommentList.fromJson(data['data']);
          setState(() {
            loadingStatus = LoadingStatus.STATUS_IDEL;
            mCommentCurPage = 1;
            mCommentList = mComment.list;
            mCommenttotalCount = data['data']['total'];
          });
        }, (error) {
          loadingStatus = LoadingStatus.STATUS_IDEL;
        });
  }

  Future getCommentDataLoadMore(int mCurPage) async {
    FormData formData = FormData.fromMap({
      "pageNum": mCurPage,
      "pageSize": Constant.PAGE_SIZE,
      "weiboid": widget.mCommentTop.commentid
    });
    List<WeiBoModel> mListRecords = new List();

    await DioManager.getInstance()
        .post(ServiceUrl.getWeiBoCommentReplyList, formData, (data) {
      CommentList mComment = CommentList.fromJson(data['data']);
      setState(() {
        loadingStatus = LoadingStatus.STATUS_IDEL;
        mCommenttotalCount = data['data']['total'];
        mCommentList.addAll(mComment.list);
      });
    }, (error) {
      setState(() {
        loadingStatus = LoadingStatus.STATUS_IDEL;
      });
    });
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

  Widget mCommentWidget(Comment mComment, bool isTop) {
    return Container(
      margin: EdgeInsets.only(top: 8,right: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: mComment.fromuserisvertify == 0
                      ? Container(
                      width: 35.0,
                      height: 35.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        image: DecorationImage(
                            image: NetworkImage(mComment.fromhead),
                            fit: BoxFit.cover),
                      ))
                      : Stack(
                    children: <Widget>[
                      Container(
                          width: 35.0,
                          height: 35.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            image: DecorationImage(
                                image: NetworkImage(mComment.fromhead),
                                fit: BoxFit.cover),
                          )),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          child: Image.asset(
                            (mComment.fromuserisvertify == 1)
                                ? Constant.ASSETS_IMG +
                                'home_vertify.webp'
                                : Constant.ASSETS_IMG +
                                'home_vertify2.webp',
                            width: 15.0,
                            height: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Center(
                      child: Padding(
                          padding:
                          const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Text(mComment.fromuname,
                              style: TextStyle(
                                  fontSize: 11.0,
                                  color: mComment.fromuserismember == 0
                                      ? Color(0xff636363)
                                      : Color(0xffF86119)))),
                    ),
                    Center(
                      child: mComment.fromuserismember == 0
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
                    Spacer(),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Image.asset(
                            Constant.ASSETS_IMG + 'icon_like.png',
                            width: 15.0,
                            height: 15.0,
                          ),
                        ),
                        Visibility(
                          visible: isTop,
                          child: Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            child: Image.asset(
                              Constant.ASSETS_IMG + 'icon_comment.png',
                              width: 15.0,
                              height: 15.0,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 3),
                  child: Text(
                    DateUtil.getFormatTime2(DateTime.fromMillisecondsSinceEpoch(
                        mComment.createtime))
                        .toString(),
                    style: TextStyle(color: Color(0xff909090), fontSize: 11),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 3),
                  child: Text(
                    mComment.content,
                    style: TextStyle(color: Color(0xff333333), fontSize: 13),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /* Container(
                            child: Text(
                                "点赞转发布局"
                            ),
                          ),*/
                    ],
                  ),
                ),
                Visibility(
                  visible: !isTop,
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 0.5,
                    color: Color(0xffE6E4E3),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
