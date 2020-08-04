import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/model/WeiBoModel.dart';
import 'package:flutterhybridandroid/pages/weibo_retweet_page.dart';
import 'package:flutterhybridandroid/routers/routers.dart';
import 'package:flutterhybridandroid/util/date_util.dart';
import 'package:flutterhybridandroid/util/toast_util.dart';
import 'package:flutterhybridandroid/util/user_util.dart';
import 'package:flutterhybridandroid/widgets/likeButton/like_button.dart';
import 'package:flutterhybridandroid/widgets/likeButton/utils/like_button_model.dart';
import 'package:flutterhybridandroid/widgets/video/video_widget.dart';
import 'package:flutterhybridandroid/widgets/weibo/match_text.dart';
import 'package:flutterhybridandroid/widgets/weibo/parsed_text.dart';
import 'package:nine_grid_view/nine_grid_view.dart';

class WeiBoItemWidget extends StatefulWidget {
  WeiBoModel mModel;
  bool isDetail; //是否是详情界面

  WeiBoItemWidget({Key key, this.mModel, this.isDetail}) : super(key: key);

  @override
  _WeiBoItemWidgetState createState() =>
      _WeiBoItemWidgetState(mModel, isDetail);
}

class _WeiBoItemWidgetState extends State<WeiBoItemWidget> {
  WeiBoModel mModel;
  bool isDetail; //是否是详情界面
  _WeiBoItemWidgetState(WeiBoModel mModel, bool isDetail) {
    this.mModel = mModel;
    this.isDetail = isDetail;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _authorRow(mModel),
          _textContent(mModel.content, isDetail),
          _videoLayout(mModel.vediourl),
          _NineGrid(mModel.picurl),
          _RetWeetLayout(mModel,isDetail),
          Visibility(
            visible: !isDetail,
            child: Column(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 10,
                      top: mModel.containZf ? 0 : 12),
                  height: 1,
                  color: Color(0xffDBDBDB),
                ), //下划线
                _RePraCom(mModel),
                new Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 12,
                  color: Color(0xffEFEFEF),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

//发布者昵称头像布局
  Widget _authorRow(WeiBoModel weiboItem) {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 2),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              Routes.navigateTo(context, Routes.personinfoPage, params: {
                'userid': weiboItem.userInfo.id.toString(),
              });
            },
            child: Container(
                child: mModel.userInfo.isvertify == 0
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(weiboItem.userInfo.headurl),
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
                                      image: NetworkImage(
                                          weiboItem.userInfo.headurl),
                                      fit: BoxFit.cover),
                                )),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                child: Image.asset(
                                  (weiboItem.userInfo.isvertify == 1)
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
          Expanded(child:      Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  //头像右边上面文字
                  children: <Widget>[
                    Center(
                      child: Text(
                        weiboItem.userInfo.nick,
                        style: TextStyle(
                            fontSize: 16,
                            color: weiboItem.userInfo.ismember == 0
                                ? Colors.black
                                : Colors.deepOrange),
                      ),
                    ),
                    Center(
                      child: weiboItem.userInfo.ismember == 0
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
                if (weiboItem.tail.isEmpty) //头像右边下面文字
                  Text(weiboItem.userInfo.decs,
                      style:
                      TextStyle(color: Color(0xff808080), fontSize: 11.0))
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                          DateUtil.getFormatTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  weiboItem.createtime)),
                          //fromMillisecondsSinceEpoch时间戳转DateTime
                          style: TextStyle(
                              color: Color(0xff808080), fontSize: 11.0)),
                      Container(
                        margin: EdgeInsets.only(left: 7, right: 7),
                        child: Text("来自",
                            style: TextStyle(
                                color: Color(0xff808080), fontSize: 11.0)),
                      ),
                      Text(weiboItem.tail,
                          style: TextStyle(
                              color: Color(0xff5B778D), fontSize: 11.0))
                    ],
                  ),
              ],
            ),
          ),),

          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              child: Container(
                margin: EdgeInsets.only(left: 5),
                padding: new EdgeInsets.only(
                    top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.orange),
                  borderRadius: new BorderRadius.circular(12.0),
                ),
                child: Text(
                  '+ 关注',
                  style: TextStyle(color: Colors.orange, fontSize: 12),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //中间文本布局
  Widget _textContent(String content, bool isDetail) {
    if (!isDetail) {
      if (content.length > 150) {
        content = content.substring(0, 148) + '...' + '全文';
      }
    }
    content = content.replaceAll("\\n", "\n");
    return Container(
      alignment: FractionalOffset.centerLeft,
      //Aligment的坐标系原点是在父控件的中间，而FractionalOffset的坐标系是在父控件的左上角
      margin: EdgeInsets.fromLTRB(15, 5, 5, 0),
      child: ParsedText(
        text: content,
        style: TextStyle(color: Colors.black, height: 1.5, fontSize: 15),
        parse: <MatchText>[
          MatchText(
              pattern: r"\[(@[^:]+):([^\]]+)\]",
              style: TextStyle(
                color: Color(0xff5B778D),
                fontSize: 15,
              ),
              renderText: ({String str, String pattern}) {
                Map<String, String> map = Map<String, String>();
                RegExp customRegExp = RegExp(pattern);
                Match match = customRegExp.firstMatch(str);
                map['display'] = match.group(1);
                map['value'] = match.group(2);
                print("正则:" +
                    match.group(1) +
                    "---" +
                    match.group(2) +
                    "---" +
                    match.group(0));
                return map;
              },
              onTap: (content, contentId) {
                print("点击传值:" + content + "---" + contentId);
                Routes.navigateTo(context, Routes.personinfoPage, params: {
                  'userid': contentId,
                });
              }),
          MatchText(
              pattern: '#.*?#',
              //       pattern: r"\B#+([\w]+)\B#",
              //   pattern: r"\[(#[^:]+):([^#]+)\]",
              style: TextStyle(
                color: Color(0xff5B778D),
                fontSize: 15,
              ),
              renderText: ({String str, String pattern}) {
                Map<String, String> map = Map<String, String>();

                String idStr =
                    str.substring(str.indexOf(":") + 1, str.lastIndexOf("#"));
                String showStr = str
                    .substring(str.indexOf("#"), str.lastIndexOf("#") + 1)
                    .replaceAll(":" + idStr, "");
                map['display'] = showStr;
                map['value'] = idStr;
                //   print("正则:"+str+"---"+idStr+"--"+startIndex.toString()+"--"+str.lastIndexOf("#").toString());
                print("正则:" + str + "---" + idStr);

                return map;
              },
              onTap: (String content, String contentId) async {
                print("id是:" + contentId.toString());
                Routes.navigateTo(
                  context,
                  Routes.topicDetailPage,
                  params: {
                    'mTitle': content.replaceAll("#", ""),
                    'mImg': "",
                    'mReadCount': "123",
                    'mDiscussCount': "456",
                    'mHost': "测试号",
                  },
                );
              }),
          MatchText(
            pattern: '(\\[/).*?(\\])',
            //       pattern: r"\B#+([\w]+)\B#",
            //   pattern: r"\[(#[^:]+):([^#]+)\]",
            style: TextStyle(
              fontSize: 15,
            ),
            renderText: ({String str, String pattern}) {
              Map<String, String> map = Map<String, String>();
              print("表情的正则:" + str);
              String mEmoji2 = "";
              try {
                String mEmoji = str.replaceAll(
                    RegExp('(\\[/)|(\\])'), ""); //[/127774]变为127774
                print("表情的正则===:" + mEmoji);

                int mEmojiNew = int.parse(mEmoji);
                mEmoji2 = String.fromCharCode(mEmojiNew); //将 Unicode 编码转为一个字符:
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
                Map<String, String> map = Map<String, String>();
                map['display'] = '全文';
                map['value'] = '全文';
                return map;
              },
              onTap: (display, value) async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: new Text("Mentions clicked"),
                      content: new Text("点击全文了"),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          child: new Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
        ],
      ),
    );
  }

  Widget _videoLayout(String vedioUrl) {
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10),
      child: (vedioUrl.isEmpty || "null" == vedioUrl)
          ? Container()
          : Container(
              constraints: BoxConstraints(
                  //一个对其子控件进行额外约束的控件
                  maxHeight: 250,
                  maxWidth: MediaQuery.of(context).size.width,
                  //    maxWidth: 200,
                  minHeight: 150,
                  minWidth: 150),
              child: VideoWidget(vedioUrl),
            ),
    );
  }

//九宫格图片布局
  Widget _NineGrid(List<String> picList) {
    //如果包含九宫格图片
    if (picList != null && picList.length > 0) {
      return  Align(
        alignment: Alignment.centerLeft,
        child: NineGridView(
          margin: EdgeInsets.only(left: 10, right: 10),
          itemCount: picList.length,
          type: NineGridType.weiBo,
          itemBuilder: (context, index) {
            return InkWell(
              child: Image.network(
                picList[index],
                fit: BoxFit.cover,
              ),
              onTap: (){
                ToastUtil.show(picList[index].toString());
              },
            );
          },
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }
//转发内容的布局
  Widget _RetWeetLayout(WeiBoModel weiboItem, bool isDetail) {
    if (weiboItem.containZf) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Container(
            padding: EdgeInsets.only(bottom: 12),
            margin: EdgeInsets.only(top: 5),
            color: Color(0xffF7F7F7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _textContent(
                    '[@' +
                        weiboItem.zfNick +
                        ':' +
                        weiboItem.zfUserId +
                        ']' +
                        ":" +
                        weiboItem.zfContent,
                    isDetail),
                /*   Text(,
                    style: TextStyle(color: Colors.black, fontSize: 12)),*/
                _videoLayout(weiboItem.zfVedioUrl),
                _NineGrid(weiboItem.zfPicurl),
              ],
            )),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  //转发收藏点赞布局
  Widget _RePraCom(WeiBoModel weiboItem) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Flexible(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return RetWeetPage(
                  mModel: weiboItem,
                );
              }));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  Constant.ASSETS_IMG + 'ic_home_reweet.png',
                  width: 22.0,
                  height: 22.0,
                ),
                Container(
                  child: Text(weiboItem.zhuanfaNum.toString() + "",
                      style: TextStyle(color: Colors.black, fontSize: 13)),
                  margin: EdgeInsets.only(left: 4.0),
                ),
              ],
            ),
          ),
          flex: 1,
        ),
        new Flexible(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return RetWeetPage(
                  mModel: weiboItem,
                );
              }));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  Constant.ASSETS_IMG + 'ic_home_comment.webp',
                  width: 22.0,
                  height: 22.0,
                ),
                Container(
                  child: Text(weiboItem.commentNum.toString() + "",
                      style: TextStyle(color: Colors.black, fontSize: 13)),
                  margin: EdgeInsets.only(left: 4.0),
                ),
              ],
            ),
          ),
          flex: 1,
        ),
        new Flexible(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return RetWeetPage(
                  mModel: weiboItem,
                );
              }));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                LikeButton(
                  isLiked: weiboItem.zanStatus == 1,
                  onTap: (bool isLiked) {
                    return onLikeButtonTapped(isLiked, weiboItem);
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
                  likeCount: weiboItem.likeNum,
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
                ),
              ],
            ),
          ),
          flex: 1,
        ),
      ],
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked, WeiBoModel weiboItem) async {
    //Completer允许你做某个异步事情的时候，调用c.complete(value)方法来传入最后要返回的值。最后通过c.future的返回值来得到结果，
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
