import 'dart:io';
import 'dart:ui';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'pages/firstpage.dart';
import 'routers/routers.dart';
import 'pages/splashpage.dart';

void main() {
  runApp(MyApp(window.defaultRouteName));
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xffffffff),
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Color(0xffffffff),
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

Widget MyApp(String url) {
  String route = _getRouteName(url);
  Map<String, dynamic> params = _getParamsStr(url);
  print("$params");
  switch (route) {
    case 'route1':
      return MaterialApp(
        home: Scaffold(
          body: FirstPage(route, params),
        ),
      );
    default:
      final router = Router();
      Routes.configureRoutes(router);
      return Container(
        child: MaterialApp(
            title: "微博",
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primaryColor: Colors.white),
            home: SplashPage()),
      );
  }
}

// 获取路由名称
String _getRouteName(String s) {
  if (s.indexOf('?') == -1) {
    return s;
  } else {
    return s.substring(0, s.indexOf('?'));
  }
}

// 获取参数
Map<String, dynamic> _getParamsStr(String s) {
  if (s.indexOf('?') == -1) {
    return Map();
  } else {
    return json.decode(s.substring(s.indexOf('?') + 1));
  }
}
