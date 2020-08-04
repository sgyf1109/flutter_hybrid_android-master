import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';

class ShareWidget extends StatefulWidget {
  @override
  _ShareWidgetState createState() => _ShareWidgetState();
}

class _ShareWidgetState extends State<ShareWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(padding: const EdgeInsets.fromLTRB(30.0, 15.0, 0.0, 10),child: Row(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('分享'),
            InkWell(
              onTap: () {},
              child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Image.asset(
                    Constant.ASSETS_IMG + 'share_group_wx.png',
                    width: 30.0,
                    height: 30.0,
                  )),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Image.asset(
                    Constant.ASSETS_IMG + 'share_group_wxfirend.png',
                    width: 30.0,
                    height: 30.0,
                  )),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Image.asset(
                    Constant.ASSETS_IMG + 'share_group_qq.png',
                    width: 30.0,
                    height: 30.0,
                  )),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Image.asset(
                    Constant.ASSETS_IMG + 'share_group_qqzone.png',
                    width: 30.0,
                    height: 30.0,
                  )),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Image.asset(
                    Constant.ASSETS_IMG + 'share_group_long_pic.png',
                    width: 30.0,
                    height: 30.0,
                  )),
            ),
          ],
        )
      ],),),
    );
  }
}
