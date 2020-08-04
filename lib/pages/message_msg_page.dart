import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/routers/routers.dart';
import 'package:flutterhybridandroid/util/toast_util.dart';

class MessageMsgPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MessageMsgPageState();
  }
}

class _MessageMsgPageState extends State<MessageMsgPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    //设置prefixIcon会导致contentpadding无效
                    prefixIconConstraints:
                        BoxConstraints(maxWidth: 20, maxHeight: 20),
                    prefixIcon: Image.asset(
                      Constant.ASSETS_IMG + 'find_top_search.png',
                      width: 20.0,
                      height: 20.0,
                    ),
                    hintText: "搜索",
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
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 15),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 2),
                    child: Image.asset(
                      Constant.ASSETS_IMG + 'message_at.webp',
                      width: 40.0,
                      height: 40.0,
                    ),
                  ),
                  Text(
                    "@我的",
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Image.asset(
                      Constant.ASSETS_IMG + 'icon_right_arrow.png',
                      width: 12.0,
                      height: 15.0,
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 18),
              height: 0.5,
              color: Color(0xffE5E5E5),
            ),
          ),
          SliverToBoxAdapter(
            child:InkWell(
              onTap: (){
                Routes.navigateTo(context, Routes.msgCommentPage,
                    transition: TransitionType.fadeIn);
              },
              child:  Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 2),
                      child: Image.asset(
                        Constant.ASSETS_IMG + 'message_comments.png',
                        width: 40.0,
                        height: 40.0,
                      ),
                    ),
                    Text(
                      "评论",
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Image.asset(
                        Constant.ASSETS_IMG + 'icon_right_arrow.png',
                        width: 12.0,
                        height: 15.0,
                      ),
                    )
                  ],
                ),
              ),
            )
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(top: 18),
              height: 0.5,
              color: Color(0xffE5E5E5),
            ),
          ),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: (){
                Routes.navigateTo(context, Routes.msgZanPage,
                    transition: TransitionType.fadeIn);
              },
              child: Container(
                margin: EdgeInsets.only(top: 15),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 2),
                      child: Image.asset(
                        Constant.ASSETS_IMG + 'message_good.webp',
                        width: 40.0,
                        height: 40.0,
                      ),
                    ),
                    Text(
                      "赞",
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Image.asset(
                        Constant.ASSETS_IMG + 'icon_right_arrow.png',
                        width: 12.0,
                        height: 15.0,
                      ),
                    )
                  ],
                ),
              ),
            )
          ),
          SliverToBoxAdapter(
              child: Container(
            margin: EdgeInsets.only(top: 18),
            height: 0.5,
            color: Color(0xffE5E5E5),
          )),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () {
                Routes.navigateTo(context, Routes.chatPage,
                    transition: TransitionType.fadeIn);
              },
              child: Container(
                margin: EdgeInsets.only(left: 15),
                height: 65,
                child: Row(
                  children: <Widget>[
                    // * 设置child为要显示的url时，并不能显示为圆形，只有设置backgroundColor或者backgroundImage时才显示为了圆形
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://c-ssl.duitang.com/uploads/item/201208/30/20120830173930_PBfJE.thumb.700_0.jpeg"),
                      radius: 20.0,
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: new Text(
                              "测试号001",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            child: new Text(
                              "明天几点吃饭？",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: new Text(
                              "19:22",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                  color: Colors.red, width: 0.5),
                              color: Colors.red,
                            ),
                            margin: EdgeInsets.only(top: 3),
                            child:Center(
                              child: Text(
                                "2",
                                style:
                                TextStyle(fontSize: 12, color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
                height: 0.5,
                color: Color(0xffE5E5E5),
              )),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () {
                Routes.navigateTo(context, Routes.chatPage,
                    transition: TransitionType.fadeIn);
              },
              child: Container(
                margin: EdgeInsets.only(left: 15),
                height: 65,
                child: Row(
                  children: <Widget>[
                    // * 设置child为要显示的url时，并不能显示为圆形，只有设置backgroundColor或者backgroundImage时才显示为了圆形
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://uploadfile.huiyi8.com/up/a2/e3/83/a2e3832e52216b846c80313049591938.jpg"),
                      radius: 20.0,
                    ),
                    Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: new Text(
                                  "测试号002",
                                  style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 3),
                                child: new Text(
                                  "可以的,明天你来找我",
                                  style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(right: 10,top: 20),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: new Text(
                              "19:22",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
                height: 0.5,
                color: Color(0xffE5E5E5),
              )),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
