import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';

class MessageDynamicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MessageDynamicPageState();
  }
}

class _MessageDynamicPageState extends State<MessageDynamicPage> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            Constant.ASSETS_IMG + "msg_no_dynamic.webp",
            width: 120,
            height: 120,
            fit: BoxFit.fill,
          ),
          Text("你暂时还没有动态",
              style: TextStyle(color: Color(0xff333333), fontSize: 14)),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}