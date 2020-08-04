import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';

class Message_Msg_Head_Widget extends StatefulWidget {
  String mTitle;

  Message_Msg_Head_Widget(this.mTitle);

  @override
  _Message_Msg_Head_WidgetState createState() => _Message_Msg_Head_WidgetState();
}

class _Message_Msg_Head_WidgetState extends State<Message_Msg_Head_Widget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Center(
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.mTitle,
                    style: TextStyle(fontSize: 18),
                  )),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      Constant.ASSETS_IMG + 'icon_back.png',
                      width: 23.0,
                      height: 23.0,
                    )),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      child: GestureDetector(
                          onTap: () {
                            //  Navigator.pop(context);
                          },
                          child: Text("设置",style: TextStyle(fontSize: 16),)))),
            ],
          ),
        ));
  }
}
