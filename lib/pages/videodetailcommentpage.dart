import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/model/WeiBoCommentList.dart';
import 'package:flutterhybridandroid/model/WeiBoDetail.dart';
import 'package:flutterhybridandroid/routers/routers.dart';
import 'package:flutterhybridandroid/util/date_util.dart';
import 'dart:convert' as convert;

import 'commentdialogpage.dart';

class VideoDetailCommentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VideoDetailCommentPageState();
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

class _VideoDetailCommentPageState extends State<VideoDetailCommentPage> with AutomaticKeepAliveClientMixin {
  int mCommenttotalCount = 20;
  int mCommentCurPage = 1;
  var loadingStatus = LoadingStatus.STATUS_IDEL;
  ScrollController _scrollController = new ScrollController();
  List<Comment> mCommentList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommentDataLoadMore(mCommentCurPage, "1");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == //滑动距离
          _scrollController.position.maxScrollExtent) {
        ///最大可滑动距离，滑动组件内容长度
        print("调用加载更多");
        if (loadingStatus == LoadingStatus.STATUS_IDEL) {
          setState(() {
            loadingStatus = LoadingStatus.STATUS_LOADING;
          });

          if (mCommentList.length < mCommenttotalCount) {
            setState(() {
              mCommentCurPage += 1;
            });
            getCommentDataLoadMore(mCommentCurPage, "1");
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
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(child:  Container(
            child: new ListView.builder(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
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
          ),),
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
                    child: Text("说点什么"),
                  )
              ),
              onTap:(){
                Navigator.of(context).push(PageRouteBuilder(opaque: false,pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                  return CommentDialogPage("1", true, (){
                    //评论成功从新获取数据
                    _scrollController.animateTo(0,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.ease);
                    getCommentDataLoadMore(mCommentCurPage, "1");
                  });
                }));
              },
            ),
          )
        ],
      ),
    );
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
                InkWell(
                  //评论区
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
                ), //时间区
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

  Future getCommentDataLoadMore(int mCommentCurPage, String weiboId) async {
    FormData formData = FormData.fromMap({
      "pageNum": mCommentCurPage,
      "pageSize": Constant.PAGE_SIZE,
      "weiboid": weiboId
    });
    DioManager.getInstance().post(ServiceUrl.getWeiBoDetailComment, formData,
        (data) {
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


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
