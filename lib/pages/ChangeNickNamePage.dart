import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/event/ChangeInfoEvent.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/util/toast_util.dart';
import 'package:flutterhybridandroid/util/user_util.dart';

class ChangeNickNamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangeNickNamePageState();
  }
}

class _ChangeNickNamePageState extends State<ChangeNickNamePage> {
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
            "修改昵称",
            style: TextStyle(fontSize: 16),
          ),
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
                  height: 50,
                  color: Color(0xffffffff),
                  child: TextField(
                    controller: _mEtController,
                    decoration: InputDecoration(
                        hintText: "请输入您的昵称",
                        contentPadding: EdgeInsets.only(left: 15, right: 15),
                        border: InputBorder.none),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      "4-30个字符,支持中英文、数字",
                      style: TextStyle(color: Color(0xff999999)),
                    ),
                  ),
                ),
                Container(
                  height: 45,
                  margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: () {
                      if(_mEtController.text.isEmpty){
                        ToastUtil.show('昵称不能为空!');
                        return;
                      }
                      FormData params = FormData.fromMap({
                        'userId': UserUtil.getUserInfo().id,
                        'nick': _mEtController.text
                      });
                      DioManager.getInstance()
                          .post(ServiceUrl.updateNick, params, (data) {
                        ToastUtil.show('修改昵称成功!');
                        UserUtil.saveUserNick(_mEtController.text);
                        Constant.eventBus.fire(ChangeInfoEvent());
                        Navigator.pop(context);
                      }, (error) {
                        ToastUtil.show(error);
                      });
                    },
                    child: Text(
                      "修改",
                    ),
                    color: Color(0xffFF8200),
                    textColor: Colors.white,
                    disabledTextColor: Colors.white,
                    disabledColor: Color(0xffFFD8AF),
                    elevation: 0,
                    disabledElevation: 0,
                    highlightElevation: 0,
                 /*   RoundedRectangleBorder：圆形矩形边框
                     ContinuousRectangleBorder：连续矩形边框
                    BeveledRectangleBorder ： 斜角矩形边框*/
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25.0),
                        topLeft: Radius.circular(25.0),
                        bottomRight: Radius.circular(25.0),
                        bottomLeft: Radius.circular(25.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
