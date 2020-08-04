import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterhybridandroid/pages/loginpage.dart';
import 'package:flutterhybridandroid/util/sp_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constant/constant.dart';
import '../routers/routers.dart';
import '../util/user_util.dart';
import 'SettingPage.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // App启动时读取Sp数据，需要异步等待Sp初始化完成。
    SpUtil.getInstance();
//    Navigator.pop(context);
    Future.delayed(Duration(seconds: 1), () {
//      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {//替换当前页面
//        return LoginPage();
//      }));
//      Routes.navigateTo(context, Routes.loginPage, clearStack: true);

      if (!UserUtil.isLogin()) {
        Navigator.pop(context);
        Routes.navigateTo(context, Routes.loginPage, clearStack: true);
      } else {
        Navigator.pop(context);
        Routes.navigateTo(context, Routes.indexPage, clearStack: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 100),
            child: Image.asset(
              Constant.ASSETS_IMG + 'welcome_android_slogan.png',
              width: 200,
              height: 100,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    Constant.ASSETS_IMG + 'welcome_android_logo.png',
                    width: 100.0,
                    height: 100.0,
                  ),
                  color: Color(0xFFFFFFFF),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
