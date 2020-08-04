import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/util/date_util.dart';

class PersonInfoHomePage extends StatefulWidget {
  String name;
  String desc;
  int registtime;
  String gender;

  PersonInfoHomePage(this.name, this.desc, this.registtime, this.gender);

  @override
  State<StatefulWidget> createState() {
    return _PersonInfoHomePageState();
  }
}

class _PersonInfoHomePageState extends State<PersonInfoHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                color: Colors.white,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 12.0, bottom: 12, left: 15),
                child: Text(
                  '基本资料',
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
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
          Container(
            padding: EdgeInsets.only(top: 12.0, bottom: 12, left: 15),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text("信息",style: TextStyle(color: Colors.grey, fontSize: 16)),
                  margin: EdgeInsets.only(right: 40),
                ),
                Container(
                  child: Text(widget.name+" "+(widget.gender==1?"男":"女")+" ",style: TextStyle(color: Colors.black, fontSize: 16)),
                )
              ],
            ),
          ),
          Container(
            height: 0.5,
            color: Colors.black12,
            //  margin: EdgeInsets.only(left: 60),
          ),
          Container(
            padding: EdgeInsets.only(top: 12.0, bottom: 12, left: 15),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text("公司",style: TextStyle(color: Colors.grey, fontSize: 16)),
                  margin: EdgeInsets.only(right: 40),
                ),
                Container(
                  child: Text("点击编辑我的公司",style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
                )
              ],
            ),
          ),
          Container(
            height: 0.5,
            color: Colors.black12,
            //  margin: EdgeInsets.only(left: 60),
          ),
          Container(
            padding: EdgeInsets.only(top: 12.0, bottom: 12, left: 15),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text("学校",style: TextStyle(color: Colors.grey, fontSize: 16)),
                  margin: EdgeInsets.only(right: 40),
                ),
                Container(
                  child: Text("上海交通大学",style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
                )
              ],
            ),
          ),
          Container(
            height: 0.5,
            color: Colors.black12,
            //  margin: EdgeInsets.only(left: 60),
          ),
          Container(
            padding: EdgeInsets.only(top: 12.0, bottom: 12, left: 15),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text("情感状况",style: TextStyle(color: Colors.grey, fontSize: 16)),
                  margin: EdgeInsets.only(right: 40),
                ),
                Container(
                  child: Text("单身",style: TextStyle(color: Colors.black, fontSize: 16)),
                )
              ],
            ),
          ),
          Container(
            height: 0.5,
            color: Colors.black12,
            //  margin: EdgeInsets.only(left: 60),
          ),
          Container(
            padding: EdgeInsets.only(top: 12.0, bottom: 12, left: 15),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text("注册时间",style: TextStyle(color: Colors.grey, fontSize: 16)),
                  margin: EdgeInsets.only(right: 40),
                ),
                Container(
                  child: Text(DateUtil.getFormatTime3(
                      DateTime.fromMillisecondsSinceEpoch(widget.registtime)),style: TextStyle(color: Colors.black, fontSize: 16)),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 12.0, bottom: 12, left: 15),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text("简介",style: TextStyle(color: Colors.grey, fontSize: 16)),
                  margin: EdgeInsets.only(right: 40),
                ),
                Container(
                  child: Text(widget.desc,style: TextStyle(color: Colors.black, fontSize: 16)),
                )
              ],
            ),
          ),
          Container(
            height: 0.5,
            color: Colors.black12,
            //  margin: EdgeInsets.only(left: 60),
          ),
        ],
      ),
    );
  }
}
