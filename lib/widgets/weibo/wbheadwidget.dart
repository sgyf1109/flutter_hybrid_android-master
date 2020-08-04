import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';

class WbHeadWidget extends StatefulWidget {
  String mTitle;

  WbHeadWidget(this.mTitle);

  @override
  _WbHeadWidgetState createState() => _WbHeadWidgetState();
}

class _WbHeadWidgetState extends State<WbHeadWidget> {
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
                          child: Image.asset(
                            Constant.ASSETS_IMG + 'icon_more.png',
                            width: 23.0,
                            height: 23.0,
                          )))),
            ],
          ),
        ));
  }
}
