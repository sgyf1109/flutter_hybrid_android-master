import 'package:flutter/material.dart';

class PageInfoWeiBo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageInfoWeiBoState();
  }
}

class _PageInfoWeiBoState extends State<PageInfoWeiBo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text("暂无数据"),
      ),
    );
  }
}