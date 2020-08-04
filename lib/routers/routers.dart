import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/model/VideoModel.dart';
import 'package:flutterhybridandroid/model/WeiBoDetail.dart';
import 'package:flutterhybridandroid/pages/ChangeDescPage.dart';
import 'package:flutterhybridandroid/pages/ChangeNickNamePage.dart';
import 'package:flutterhybridandroid/pages/ChatPage.dart';
import 'package:flutterhybridandroid/pages/FanPage.dart';
import 'package:flutterhybridandroid/pages/FeedbackPage.dart';
import 'package:flutterhybridandroid/pages/FollowPage.dart';
import 'package:flutterhybridandroid/pages/HotSearchPage.dart';
import 'package:flutterhybridandroid/pages/MessageCommentPage.dart';
import 'package:flutterhybridandroid/pages/MsgZanPage.dart';
import 'package:flutterhybridandroid/pages/indexpage.dart';
import 'package:flutterhybridandroid/pages/loginpage.dart';
import 'package:flutterhybridandroid/pages/forgetpwd.dart';
import 'package:flutterhybridandroid/pages/personinfopage.dart';
import 'package:flutterhybridandroid/pages/SettingPage.dart';
import 'package:flutterhybridandroid/pages/topicdetailpage.dart';
import 'package:flutterhybridandroid/pages/videodetailpage.dart';
import 'package:flutterhybridandroid/pages/weibocommentdetailpage.dart';
import 'package:flutterhybridandroid/pages/weibopublishatuserpage.dart';
import 'dart:convert' as convert;

import 'package:flutterhybridandroid/pages/weibopublishtopicpage.dart';

class Routes {
  // 路由管理
  static Router routers;
  static String indexPage = '/indexpage';
  static String loginPage = '/loginpage';
  static String forgetPage = '/forgetpage';
  static String personinfoPage = '/personinfoPage';
  static String topicDetailPage = '/topicDetailPage';
  static String weiboPublishAtUsrPage = '/weiboPublishAtUsrPage';
  static String weiboPublishTopicPage = '/weiboPublishTopicPage';
  static String settingPage = '/settingpage';
  static String weiboCommentDetailPage = '/weiboCommentDetailPage';
  static String videoDetailPage = '/videoDetailPage';
  static String hotSearchPage = '/hotSearchPage';
  static String msgCommentPage = '/msgCommentPage';
  static String msgZanPage = '/msgZanPage';
  static String chatPage = '/chatPage';
  static String personMyFollowPage = '/personMyFollowPage';
  static String personFanPage = '/personFanPage';
  static String changeNickNamePage = '/changeNickNamePage';
  static String changeDescPage = '/changeDescPage';
  static String feedbackPage = '/feedbackpage';


  static void configureRoutes(Router router) {
    routers = router;
    router.notFoundHandler = new Handler(
        handlerFunc:
            (BuildContext context, Map<String, List<String>> params) {});

    router.define(indexPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return IndexPage();
    }));

    router.define(loginPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return LoginPage();
    }));

    router.define(forgetPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return ForgetPage();
        }));
    router.define(personinfoPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          String userid = params["userid"]?.first;

          return PersonInfoPage(userid);
        }));
    router.define(topicDetailPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          String mTitle = params['mTitle']?.first;
          String mImg = params['mImg']?.first;
          String mReadCount = params['mReadCount']?.first;
          String mDiscussCount = params['mDiscussCount']?.first;
          String mHost = params['mHost']?.first;

          return TopicDetailPage(mTitle, mImg, mReadCount, mDiscussCount, mHost);
        }));
    router.define(weiboPublishAtUsrPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return WeiBoPublishAtUserPage();
        }));
    router.define(weiboPublishTopicPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return WeiBoPublishTopicPage();
        }));
    router.define(settingPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return SettingPage();
        }));
    router.define(weiboCommentDetailPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          Comment comment = Comment.fromJson(convert.jsonDecode(params['comment'].first));  //jsonDecode把string转为map
          return WeiBoCommentDetailPage(comment);
        }));
    router.define(videoDetailPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          VideoModel mVideo =
          VideoModel.fromJson(convert.jsonDecode(params['video'][0]));
          return VideoDetailPage(mVideo);
        }));

    router.define(hotSearchPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return HotSearchPage();
        }));
    router.define(msgCommentPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return MessageCommentPage();
        }));
    router.define(msgZanPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return MsgZanPage();
        }));
    router.define(chatPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return ChatPage();
        }));
    router.define(personMyFollowPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return FollowPage();
        }));
    router.define(personFanPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return FanPage();
        }));
    router.define(changeNickNamePage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return ChangeNickNamePage();
        }));
    router.define(changeDescPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return ChangeDescPage();
        }));
    router.define(feedbackPage, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          return FeedBackPage();
        }));
  }

  // 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配(https://www.jianshu.com/p/e575787d173c)
  static Future navigateTo(BuildContext context, String path,
      {Map<String, dynamic> params,
      bool clearStack = false,
      TransitionType transition = TransitionType.fadeIn}) {
    String query = "";
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }
    print('我是navigateTo传递的参数：$query');

    path = path + query;
    return routers.navigateTo(context, path,
        clearStack: clearStack, transition: transition);
  }
}
