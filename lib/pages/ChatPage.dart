import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterhybridandroid/model/MessageNormal.dart';
import 'package:flutterhybridandroid/widgets/message/chat_bottom.dart';
import 'package:flutterhybridandroid/widgets/message/expanded_viewport.dart';
import 'package:flutterhybridandroid/widgets/message_msg_head_widget.dart';
import 'package:flutterhybridandroid/widgets/message/message_item.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui show Codec, FrameInfo, Image;

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController listScrollController = new ScrollController();
  List<HrlMessage> mlistMessage = new List();
  AudioPlayer mAudioPlayer = AudioPlayer();
  bool isPalyingAudio = false;
  String mPalyingPosition = "";
  bool isShowLoading = false;
  final changeNotifier = new StreamController.broadcast();

  getHistroryMessage() {
    print("获取历史消息");
    List<HrlMessage> mHistroyListMessage = new List();
    final HrlTextMessage mMessgae = new HrlTextMessage();
    mMessgae.text = "测试消息";
    mMessgae.msgType = HrlMessageType.text;
    mMessgae.isSend = false;
    mHistroyListMessage.add(mMessgae);
    mHistroyListMessage.add(mMessgae);
    final HrlImageMessage mMessgaeImg = new HrlImageMessage();
    mMessgaeImg.msgType = HrlMessageType.image;
    mMessgaeImg.isSend = false;
    mMessgaeImg.thumbUrl =
        "https://c-ssl.duitang.com/uploads/item/201208/30/20120830173930_PBfJE.thumb.700_0.jpeg";
    mHistroyListMessage.add(mMessgaeImg);
    mlistMessage.addAll(mHistroyListMessage);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistroryMessage();
    listScrollController.addListener(() {
      if (listScrollController.position.pixels ==
          listScrollController.position.maxScrollExtent) {
        isShowLoading = true;
        setState(() {});
        Future.delayed(Duration(seconds: 2), () {
          getHistroryMessage();
          isShowLoading = false;
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    changeNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
            child: Scaffold(
//            如果为true，则body和scaffold的浮动窗口小部件应自行调整大小，以避免屏幕键盘的高度由环境MediaQuery的MediaQueryData.viewInsets bottom属性定义。
            resizeToAvoidBottomInset: false,
                body: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Message_Msg_Head_Widget("用户名"),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,//自己和child都可以接收事件
                          onTap: () {
                            //  点击顶部空白处触摸收起键盘
                            FocusScope.of(context).requestFocus(FocusNode());
                            changeNotifier.sink.add(null);
                          },
                          child: new ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: Scrollable(
                              physics: AlwaysScrollableScrollPhysics(),
                              controller: listScrollController,
                              axisDirection: AxisDirection.up,
                              viewportBuilder: (context, offset) {
                                return ExpandedViewport(
                                  offset: offset,
                                  axisDirection: AxisDirection.up,
                                  slivers: <Widget>[
                                    SliverExpanded(),
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (c, i) {
                                          final GlobalKey<ChatMessageItemState>
                                              mMessageItemKey = GlobalKey();
                                          mMessageItemKey.currentState
                                              ?.methodInChild(false, "");
                                          ChatMessageItem mChatItem =
                                              ChatMessageItem(
                                            key: mMessageItemKey,
                                            mMessage: mlistMessage[i],
                                            onAudioTap: (String str) {
                                              if (isPalyingAudio) {
                                                isPalyingAudio = false;
                                                mMessageItemKey.currentState
                                                    ?.methodInChild(false,
                                                        mPalyingPosition);
                                                mAudioPlayer
                                                    .release(); // manually release when no longer needed
                                                mPalyingPosition = "";
                                                setState(() {});
                                              } else {
                                                Future<int> result =
                                                    mAudioPlayer.play(str,
                                                        isLocal: true);
                                                mAudioPlayer.onPlayerCompletion
                                                    .listen((event) {
                                                  mMessageItemKey.currentState
                                                      ?.methodInChild(false,
                                                          mPalyingPosition);
                                                  isPalyingAudio = false;
                                                  mPalyingPosition = "";
                                                });

                                                isPalyingAudio = true;
                                                mPalyingPosition =
                                                    mlistMessage[i].uuid;
                                                mMessageItemKey.currentState
                                                    ?.methodInChild(
                                                        true, mPalyingPosition);
                                              }
                                            },
                                          );
                                          return mChatItem;
                                        },
                                        childCount: mlistMessage.length,
                                      ),
                                    ),
                                    SliverToBoxAdapter(
                                      child: isShowLoading
                                          ? Container(
                                              margin: EdgeInsets.only(top: 5),
                                              height: 50,
                                              child: Center(
                                                child: SizedBox(
                                                  width: 25.0,
                                                  height: 25.0,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 3,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : new Container(),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      /*  ],
          )*/
                      //   ),

                      ChatBottomInputWidget(
                          shouldTriggerChange: changeNotifier.stream,
                          onSendCallBack: (value) {
                            print("发送的文字:" + value);
                            final HrlTextMessage mMessgae =
                                new HrlTextMessage();
                            mMessgae.uuid = Uuid().v4() + "";
                            mMessgae.text = value;
                            mMessgae.msgType = HrlMessageType.text;
                            mMessgae.isSend = true;
                            mMessgae.state = HrlMessageState.sending;
                            mlistMessage.insert(0, mMessgae);
                            listScrollController.animateTo(0.00,
                                duration: Duration(milliseconds: 1),
                                curve: Curves.easeOut);
                            setState(() {});
                            Future.delayed(new Duration(seconds: 1), () {
                              mMessgae.state = HrlMessageState.send_succeed;
                              setState(() {});
                            });
                          },
                          onImageSelectCallBack: (value) {
                            File image = new File(value
                                .path); // Or any other way to get a File instance.
                            Future<ui.Image> decodedImage =
                                decodeImageFromList(image.readAsBytesSync());

                            decodedImage.then((result) {
                              print("图片的宽:" + "${result.width}");
                              print("图片的高:" + "${result.height}");
                            });
                            final HrlImageMessage mMessgae =
                                new HrlImageMessage();
                            mMessgae.uuid = Uuid().v4() + "";
                            mMessgae.msgType = HrlMessageType.image;
                            mMessgae.isSend = true;
                            mMessgae.thumbPath = value.path;

                            mMessgae.state = HrlMessageState.sending;
                            mlistMessage.insert(0, mMessgae);
                            listScrollController.animateTo(0.00,
                                duration: Duration(milliseconds: 1),
                                curve: Curves.easeOut);
                            setState(() {});
                            Future.delayed(new Duration(seconds: 1), () {
                              mMessgae.state = HrlMessageState.send_succeed;
                              setState(() {});
                            });
                          },
                          onAudioCallBack: (value, duration) {
                            final HrlVoiceMessage mMessgae =
                                new HrlVoiceMessage();
                            mMessgae.uuid = Uuid().v4() + "";
                            mMessgae.msgType = HrlMessageType.voice;
                            mMessgae.isSend = true;
                            mMessgae.path = value.path;
                            mMessgae.duration = duration;
                            mMessgae.state = HrlMessageState.sending;
                            mlistMessage.insert(0, mMessgae);
                            listScrollController.animateTo(0.00,
                                duration: Duration(milliseconds: 1),
                                curve: Curves.easeOut);
                            setState(() {});
                            Future.delayed(new Duration(seconds: 1), () {
                              mMessgae.state = HrlMessageState.send_succeed;
                              setState(() {});
                            });
                          }),
                    ],
                  ),
                )),
            onWillPop: () {
              FocusScope.of(context).requestFocus(FocusNode());
              changeNotifier.sink.add(null);
              Navigator.pop(context);
            }));
  }
}

class MyBehavior extends ScrollBehavior {
  //去除滑动布局的蓝色回弹效果
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return super.buildViewportChrome(context, child, axisDirection);
    }
  }
}
