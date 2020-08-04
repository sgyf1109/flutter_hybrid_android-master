import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/event/ChangeInfoEvent.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/util/toast_util.dart';
import 'package:flutterhybridandroid/util/user_util.dart';

class ChangeDescPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangeDescPageState();
  }
}

class _ChangeDescPageState extends State<ChangeDescPage> {
  TextEditingController _mEtController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF3F1F4),
        appBar: AppBar(
          backgroundColor: Color(0xffFAFAFA),
          leading: IconButton(
              iconSize: 30,
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            "编辑简介",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            InkWell(
              child: Container(
                color: Color(0xffFAFAFA),
                padding: EdgeInsets.only(right: 15),
                alignment: Alignment.center,
                child: Text("完成"),
              ),
              onTap: (){
                if (_mEtController.text.isEmpty) {
                  ToastUtil.show('内容不能为空!');
                  return;
                }
                FormData params = FormData.fromMap({
                  'userId': UserUtil.getUserInfo().id,
                  'personSign': _mEtController.text
                });
                DioManager.getInstance()
                    .post(ServiceUrl.updateIntroduce, params, (data) {
                  ToastUtil.show('修改个性签名成功!');
                  UserUtil.saveUserDesc(_mEtController.text);
                  Constant.eventBus.fire(ChangeInfoEvent());
                  Navigator.pop(context);
                }, (error) {
                  ToastUtil.show(error);
                });
              },
            )
          ],
          elevation: 0.5,
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context)
                .requestFocus(FocusNode()); //container不设置背景色点击无效
          },
          child: Container(
            margin: EdgeInsets.only(top: 15),
            color: Color(0xffF3F1F4),
            child: Column(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(
                    minHeight: 100,
                  ),
                  color: Color(0xffffffff),
                  child: TextField(
                    maxLength: 50,
                    maxLines: 3,
                    controller: _mEtController,
                    decoration: InputDecoration(
                        hintText: "介绍下自己",
                        contentPadding: EdgeInsets.only(left: 15, right: 15,top: 10),
                        border: InputBorder.none,
                        hintStyle:
                        TextStyle(color: Color(0xff999999), fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
