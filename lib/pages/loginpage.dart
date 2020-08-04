import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/customwidget/TextFieldAccount.dart';
import 'package:flutterhybridandroid/customwidget/TextFieldPwd.dart';
import 'package:flutterhybridandroid/util/sp_util.dart';
import 'package:flutterhybridandroid/util/toast_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/util/user_util.dart';
import 'package:flutterhybridandroid/routers/routers.dart';
import 'package:fluro/fluro.dart';
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  static const nativeChannel =
      const MethodChannel('com.example.flutter/native');
  static const flutterChannel =
      const MethodChannel('com.example.flutter/flutter');
  String _inputAccount = "";
  String _inputPwd = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<dynamic> handler(MethodCall call) async {
      switch (call.method) {
        case 'onActivityResult':
          Fluttertoast.showToast(
            msg: call.arguments['message'],
            toastLength: Toast.LENGTH_SHORT,
          );
          break;
        case 'goBack':
          // 返回上一页
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          } else {
            nativeChannel.invokeMethod('goBack');
          }
          break;
      }
    }

    flutterChannel.setMethodCallHandler(handler);
  }

  @override
  Widget build(BuildContext context) {
    //登录时保存软键盘高度,在聊天界面第一次弹出底部布局时使用
    final keyHeight = MediaQuery.of(context).viewInsets.bottom;
    if (keyHeight != 0) {
      print("键盘高度是:" + keyHeight.toString());
      SpUtil.putDouble(Constant.SP_KEYBOARD_HEGIHT, keyHeight);
    }

    return new Scaffold(
      backgroundColor: Colors.white,
      body: DropdownButtonHideUnderline(
          //如果DropdownButton是DropdownButtonHideUnderline的子控件，那么DropdownButton的下划线将不会起作用，用SingleChildScrollView会占据状态栏
          child: new ListView(
        children: <Widget>[
          buildTile(),
          Container(
            margin: EdgeInsets.only(left: 20, top: 30, bottom: 20),
            child: Text(
              "请输入账号密码",
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: AccountEditText(
              contentStrCallBack: (input) {
                _inputAccount=input;
                setState(() {});
              },
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 5, left: 20, right: 20),
              child: PwdEditText(
                contentStrCallBack: (input) {
                  _inputPwd=input;
                  setState(() {});
                },
              )),
          buildLoginBtn(),
          buildRegistForget(),
          buildOtherLoginWay(),
        ],
      )),
    );
  }

  Widget buildTile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, //子组件的排列方式为主轴两端对齐
      children: <Widget>[
        InkWell(
          //在flutter 开发中用InkWell或者GestureDetector将某个组件包起来，可添加点击事件
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Image.asset(
              Constant.ASSETS_IMG + 'icon_close.png',
              width: 20,
              height: 20,
            ),
          ),
          onTap: () {
            Navigator.maybePop(context);
          },
        ),
        InkWell(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "帮助",
              style: TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
          ),
        )
      ],
    );
  }

  Widget buildLoginBtn() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 60),
      child: RaisedButton(
        onPressed: () {
          if(_inputAccount.isEmpty||_inputPwd.isEmpty){
            ToastUtil.show("账号或密码为空,请重新输入");
          }else{
            FormData params = FormData.fromMap({'username': _inputAccount, 'password': _inputPwd});
            DioManager.getInstance().post(ServiceUrl.login, params, (data){
              UserUtil.saveUserInfo(data['data']);
              ToastUtil.show('登录成功!');
              Navigator.pop(context);
              Routes.navigateTo(context, Routes.indexPage);
            }, (error){

            });
          }
        },
        child:Text(
          "登录"
        ),
        color: Colors.orange,
        textColor: Colors.white,
        disabledTextColor: Colors.white,
        disabledColor: Color(0xffFFD8AF),
        elevation: 0,
        disabledElevation: 0,
        highlightElevation: 0,
      ),
    );
  }
  //注册,忘记密码
  Widget buildRegistForget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, //子组件的排列方式为主轴两端对齐
      children: <Widget>[
        new InkWell(
          child: new Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 3),
              child: new Text(
                "注册",
                style: new TextStyle(fontSize: 13.0, color: Color(0xff6B91BB)),
              )),
          onTap: () {},
        ),
        new InkWell(
          child: new Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 3),
              child: new Text(
                "忘记密码",
                style: new TextStyle(fontSize: 13.0, color: Color(0xff6B91BB)),
              )),
          onTap: () {
            Routes.navigateTo(context, Routes.forgetPage,
                transition: TransitionType.fadeIn);
          },
        ),
      ],
    );
  }

  //其他登陆方式
  Widget buildOtherLoginWay() {
    return Container(
        margin: EdgeInsets.only(top: 150),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    color: Color(0xffEAEAEA),
                    height: 1,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: Text(
                        '其他登陆方式',
                        style:
                        TextStyle(fontSize: 12, color: Color(0xff999999)),
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    color: Color(0xffEAEAEA),
                    height: 1,
                  ),
                  flex: 1,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 20, top: 10),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        Constant.ASSETS_IMG + 'login_weixin.png',
                        width: 40.0,
                        height: 40.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          '微信',
                          style:
                          TextStyle(fontSize: 12, color: Color(0xff999999)),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, top: 10),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        Constant.ASSETS_IMG + 'login_qq.png',
                        width: 40.0,
                        height: 40.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          'QQ',
                          style:
                          TextStyle(fontSize: 12, color: Color(0xff999999)),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
