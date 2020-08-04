import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/model/MsgComZanModel.dart';
import 'package:flutterhybridandroid/util/date_util.dart';
import 'package:flutterhybridandroid/widgets/message_msg_head_widget.dart';
import 'package:flutterhybridandroid/widgets/weibo/match_text.dart';
import 'package:flutterhybridandroid/widgets/weibo/parsed_text.dart';
import 'package:flutterhybridandroid/widgets/weibo/wbheadwidget.dart';

class MsgZanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MsgZanPageState();
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

class _MsgZanPageState extends State<MsgZanPage> {
  ScrollController _scrollController = new ScrollController();
  List<ComZanModel> mZanList = [];
  var loadingStatus = LoadingStatus.STATUS_IDEL;
  int mCurPage = 1;
  int totalCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubDataRefresh();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == //滑动距离
          _scrollController.position.maxScrollExtent) {
        ///最大可滑动距离，滑动组件内容长度
        print("调用加载更多");
        if (loadingStatus == LoadingStatus.STATUS_IDEL) {
          setState(() {
            loadingStatus = LoadingStatus.STATUS_LOADING;
          });

          if (mZanList.length < totalCount) {
            setState(() {
              mCurPage += 1;
            });
            getSubDataLoadMore(mCurPage);
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
                  child: Message_Msg_Head_Widget("所有评论"),
                )
              ],
            ),
          ),
          Expanded(
              child: Container(
            child: RefreshIndicator(
              onRefresh: getSubDataRefresh,
              child: new ListView.builder(
                itemCount: mZanList.length + 1,
                itemBuilder: (context, index) {
                  if (index == mZanList.length) {
                    return _buildLoadMore();
                  } else {
                    return getContentItem(index, mZanList);
                  }
                },
                controller: _scrollController,
              ),
            ),
          ))
        ],
      ),
    ));
  }

  Future getSubDataRefresh() async {
    FormData formData = FormData.fromMap({
      "pageNum": "1",
      "pageSize": Constant.PAGE_SIZE,
    });
    DioManager.getInstance().post(ServiceUrl.getMsgZanList, formData, (data) {
      ComZanListModel mList = ComZanListModel.fromJson(data['data']);
      mZanList.clear();
      mZanList = mList.list;
      loadingStatus = LoadingStatus.STATUS_IDEL;
      mCurPage = 1;
      totalCount = data['data']['total'];
      setState(() {});
    }, (error) {
      loadingStatus = LoadingStatus.STATUS_IDEL;
      setState(() {});
    });
  }

  Future getSubDataLoadMore(int mCurPage) async {
    FormData formData = FormData.fromMap({
      "pageNum": mCurPage,
      "pageSize": Constant.PAGE_SIZE,
    });
    DioManager.getInstance().post(ServiceUrl.getMsgZanList, formData, (data) {
      ComZanListModel mList = ComZanListModel.fromJson(data['data']);
      mZanList.addAll(mList.list);
      loadingStatus = LoadingStatus.STATUS_IDEL;
      setState(() {});
    }, (error) {
      loadingStatus = LoadingStatus.STATUS_IDEL;
      setState(() {});
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
        child: mZanList.length < totalCount
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

  Widget getContentItem(int index, List<ComZanModel> mList) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                mList[index].username + "评论了",
                style: TextStyle(color: Colors.grey),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  Constant.ASSETS_IMG + 'msg_comment_close.png',
                  width: 10.0,
                  height: 10.0,
                ),
              ))
            ],
          ),
          _authorRow(mList[index]),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 8),
                  child: Text(mList[index].content),
                ),
                Container(
                  decoration: BoxDecoration(
                    border:
                        new Border.all(color: Colors.orange, width: 3),
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                  child: Image.asset(
                    Constant.ASSETS_IMG + 'msg_zan.webp',
                    width: 10.0,
                    height: 10.0,
                  ),
                )
              ],
            ),
          ),
          _retweetcontent(mList[index]),
          Container(
            margin: EdgeInsets.only(top: 13),
            height: 10,
            color: Color(0xffEEEEEE),
            //  margin: EdgeInsets.only(left: 60),
          ),
        ],
      ),
    );
  }

  //发布者昵称头像布局
  Widget _authorRow(ComZanModel mModel) {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 2),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: Container(
                child: mModel.isvertify == 0
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(mModel.userheadurl),
                                fit: BoxFit.cover)),
                      )
                    : Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                      image: NetworkImage(mModel.userheadurl),
                                      fit: BoxFit.cover),
                                )),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                child: Image.asset(
                                  (mModel.isvertify == 1)
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
                      )),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    //头像右边上面文字
                    children: <Widget>[
                      Center(
                        child: Text(
                          mModel.username,
                          style: TextStyle(
                              fontSize: 16,
                              color: mModel.ismember == 0
                                  ? Colors.black
                                  : Colors.deepOrange),
                        ),
                      ),
                      Center(
                        child: mModel.ismember == 0
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Image.asset(
                                  Constant.ASSETS_IMG + 'home_memeber.webp',
                                  width: 15.0,
                                  height: 13.0,
                                ),
                              ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                          DateUtil.getFormatTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  mModel.createtime)),
                          //fromMillisecondsSinceEpoch时间戳转DateTime
                          style: TextStyle(
                              color: Color(0xff808080), fontSize: 11.0)),
                      Container(
                        margin: EdgeInsets.only(left: 7, right: 7),
                        child: Text("来自",
                            style: TextStyle(
                                color: Color(0xff808080), fontSize: 11.0)),
                      ),
                      Text(mModel.tail == null ? "" : mModel.tail,
                          style: TextStyle(
                              color: Color(0xff5B778D), fontSize: 11.0))
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              child: Container(
                margin: EdgeInsets.only(left: 5),
                padding: new EdgeInsets.only(
                    top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: new BorderRadius.circular(12.0),
                ),
                child: Text(
                  '回复',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _retweetcontent(ComZanModel mModel) {
    return InkWell(
      onTap: () {},
      child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          color: Color(0xFFF8F8F8),
          child: Row(
            children: <Widget>[
              new Container(
                child: FadeInImage.assetNetwork(
                    placeholder: Constant.ASSETS_IMG + 'img_default.png',
                    image: mModel.weibopicurl,
                    fit: BoxFit.fill,
                    width: 90,
                    height: 90),
              ),
              Expanded(
                  child: new Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '@' + mModel.weibousername,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    new Container(
                        margin: EdgeInsets.only(top: 5.0),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child:
                            /* Text('' + widget.mModel.content,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    )*/
                            ParsedText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: mModel.weibcontent,
                          style: TextStyle(
                              height: 1.5, fontSize: 13, color: Colors.grey),
                          parse: <MatchText>[
                            MatchText(
                                pattern: r"\[(@[^:]+):([^\]]+)\]",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                                renderText: ({String str, String pattern}) {
                                  Map<String, String> map =
                                      Map<String, String>();
                                  RegExp customRegExp = RegExp(pattern);
                                  Match match = customRegExp.firstMatch(str);
                                  map['display'] = match.group(1);
                                  map['value'] = match.group(2);
                                  print("正则:" +
                                      match.group(1) +
                                      "---" +
                                      match.group(2));
                                  return map;
                                },
                                onTap: (url) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AlertDialog(
                                        title: new Text("Mentions clicked"),
                                        content: new Text("$url clicked."),
                                        actions: <Widget>[
                                          // usually buttons at the bottom of the dialog
                                          new FlatButton(
                                            child: new Text("Close"),
                                            onPressed: () {},
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }),
                            MatchText(
                                pattern: '#.*?#',
                                //       pattern: r"\B#+([\w]+)\B#",
                                //   pattern: r"\[(#[^:]+):([^#]+)\]",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                                renderText: ({String str, String pattern}) {
                                  Map<String, String> map =
                                      Map<String, String>();
                                  //  RegExp customRegExp = RegExp(pattern);
                                  //#fskljflsk:12#
                                  // Match match = customRegExp.firstMatch(str);

                                  /*  String idStr =str.substring(str.indexOf(";"),
                     (str.lastIndexOf("#")-1));*/

                                  String idStr = str.substring(
                                      str.indexOf(":") + 1,
                                      str.lastIndexOf("#"));
                                  String showStr = str
                                      .substring(str.indexOf("#"),
                                          str.lastIndexOf("#") + 1)
                                      .replaceAll(":" + idStr, "");
                                  map['display'] = showStr;
                                  map['value'] = idStr;
                                  //   print("正则:"+str+"---"+idStr+"--"+startIndex.toString()+"--"+str.lastIndexOf("#").toString());

                                  return map;
                                },
                                onTap: (url) async {
                                  print("点击的id:" + url);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AlertDialog(
                                        title: new Text("Mentions clicked"),
                                        content: new Text("点击的id:" + url),
                                        actions: <Widget>[
                                          // usually buttons at the bottom of the dialog
                                          new FlatButton(
                                            child: new Text("Close"),
                                            onPressed: () {},
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }),
                            MatchText(
                              pattern: '(\\[/).*?(\\])',
                              //       pattern: r"\B#+([\w]+)\B#",
                              //   pattern: r"\[(#[^:]+):([^#]+)\]",
                              style: TextStyle(
                                fontSize: 13,
                              ),
                              renderText: ({String str, String pattern}) {
                                Map<String, String> map = Map<String, String>();
                                print("表情的正则:" + str);
                                String mEmoji2 = "";
                                try {
                                  String mEmoji = str.replaceAll(
                                      RegExp('(\\[/)|(\\])'), "");
                                  int mEmojiNew = int.parse(mEmoji);
                                  mEmoji2 = String.fromCharCode(mEmojiNew);
                                } on Exception catch (_) {
                                  mEmoji2 = str;
                                }
                                map['display'] = mEmoji2;

                                return map;
                              },
                            ),
                            MatchText(
                                pattern: '全文',
                                //       pattern: r"\B#+([\w]+)\B#",
                                //   pattern: r"\[(#[^:]+):([^#]+)\]",
                                style: TextStyle(
                                  color: Color(0xff5B778D),
                                  fontSize: 15,
                                ),
                                renderText: ({String str, String pattern}) {
                                  Map<String, String> map =
                                      Map<String, String>();
                                  map['display'] = '全文';
                                  map['value'] = '全文';
                                  return map;
                                },
                                onTap: (url) async {
                                  print("点击的id:" + url);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AlertDialog(
                                        title: new Text("Mentions clicked"),
                                        content: new Text("点击的id:" + url),
                                        actions: <Widget>[
                                          // usually buttons at the bottom of the dialog
                                          new FlatButton(
                                            child: new Text("Close"),
                                            onPressed: () {},
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }),
                          ],
                        )),
                  ],
                ),
              ))
            ],
          )),
    );
  }
}
