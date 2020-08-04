import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/event/ChangeInfoEvent.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/routers/routers.dart';
import 'package:flutterhybridandroid/util/toast_util.dart';
import 'package:flutterhybridandroid/util/user_util.dart';
import 'package:flutterhybridandroid/widgets/choose_photo_widget.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Constant.eventBus.on<ChangeInfoEvent>().listen((event) {
      setState(() {
        print("接收更换个人信息的消息");
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Color(0xffFAFAFA),
          leading: IconButton(
              iconSize: 30,
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            "设置",
            style: TextStyle(fontSize: 16),
          ),
          elevation: 0.5,
        ),
        preferredSize: Size.fromHeight(50),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            InkWell(
              onTap: (){
//                ToastUtil.show("立即拍照");
                showModalBottomSheet(context: context, builder: (context){
                  return ChoosePhotoWidget(
                    chooseImgCallBack: (mHeadFile){
                      FormData formData = FormData.fromMap({
                        "userId": UserUtil.getUserInfo().id,
                        "headFile": MultipartFile.fromFileSync(mHeadFile.path)
                      });
                      request(ServiceUrl.updateHead,formData: formData).then((val){
                        int code = val['status'];
                        if (code == 200) {
                          String mUrl = val['data'];
                          print("返回的头像的url:${mUrl}");
                          UserUtil.saveUserHeadUrl(mUrl);
                          ToastUtil.show('提交成功!');
                          setState(() {});
                        } else {
                          String msg = val['msg'];
                          ToastUtil.show(msg);
                        }
                      });
                    },
                  );
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 15),
                height: 80,
                child: Row(
                  children: <Widget>[
                    Text("头像管理",style: TextStyle(fontSize: 18),),
                    Spacer(),
                    new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                      child: new CircleAvatar(
                        backgroundImage:
                        new NetworkImage(UserUtil.getUserInfo().headurl),
                        radius: 20.0,
                      ),
                    ),
                    new Container(
                      margin: const EdgeInsets.only(left: 5.0, right: 15),
                      child: new InkWell(
                        child: Image.asset(
                          Constant.ASSETS_IMG + "icon_right_arrow.png",
                          width: 15,
                          height: 15,
                        ),
                        onTap: () {
                          // TODO(implement)
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 0.5,
              color: Colors.black12,
            ),
            InkWell(
              onTap: (){
                Routes.navigateTo(context, '${Routes.changeNickNamePage}');
              },
              child: Container(
                margin: EdgeInsets.only(left: 15),
                height: 80,
                child: Row(
                  children: <Widget>[
                    Text("用户昵称",style: TextStyle(fontSize: 18),),
                    Spacer(),
                    new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(UserUtil.getUserInfo().nick),
                    ),
                    new Container(
                      margin: const EdgeInsets.only(left: 5.0, right: 15),
                      child: new InkWell(
                        child: Image.asset(
                          Constant.ASSETS_IMG + "icon_right_arrow.png",
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 0.5,
              color: Colors.black12,
            ),
            InkWell(
              onTap: (){
                Routes.navigateTo(context, '${Routes.changeDescPage}');
              },
              child: Container(
                margin: EdgeInsets.only(left: 15),
                height: 80,
                child: Row(
                  children: <Widget>[
                    Text("个性签名",style: TextStyle(fontSize: 18),),
                    Spacer(),
                    new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(UserUtil.getUserInfo().decs),
                    ),
                    new Container(
                      margin: const EdgeInsets.only(left: 5.0, right: 15),
                      child: new InkWell(
                        child: Image.asset(
                          Constant.ASSETS_IMG + "icon_right_arrow.png",
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 0.5,
              color: Colors.black12,
            ),
            InkWell(
              onTap: (){

              },
              child: Container(
                margin: EdgeInsets.only(left: 15),
                height: 80,
                child: Row(
                  children: <Widget>[
                    Text("生日",style: TextStyle(fontSize: 18),),
                    Spacer(),
                    new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text("2020-02-03"),
                    ),
                    new Container(
                      margin: const EdgeInsets.only(left: 5.0, right: 15),
                      child: new InkWell(
                        child: Image.asset(
                          Constant.ASSETS_IMG + "icon_right_arrow.png",
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 0.5,
              color: Colors.black12,
            ),
            InkWell(
              onTap: (){

              },
              child: Container(
                margin: EdgeInsets.only(left: 15),
                height: 80,
                child: Row(
                  children: <Widget>[
                    Text("所在区域",style: TextStyle(fontSize: 18),),
                    Spacer(),
                    new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(""),
                    ),
                    new Container(
                      margin: const EdgeInsets.only(left: 5.0, right: 15),
                      child: new InkWell(
                        child: Image.asset(
                          Constant.ASSETS_IMG + "icon_right_arrow.png",
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 30,
              color: Colors.black12,
            ),
            InkWell(
              onTap: (){
                Routes.navigateTo(context, '${Routes.feedbackPage}');
              },
              child: Container(
                margin: EdgeInsets.only(left: 15),
                height: 80,
                child: Row(
                  children: <Widget>[
                    Text("意见反馈",style: TextStyle(fontSize: 18),),
                    Spacer(),
                    new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(""),
                    ),
                    new Container(
                      margin: const EdgeInsets.only(left: 5.0, right: 15),
                      child: new InkWell(
                        child: Image.asset(
                          Constant.ASSETS_IMG + "icon_right_arrow.png",
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 0.5,
              color: Colors.black12,
            ),
            InkWell(
              onTap: (){

              },
              child: Container(
                margin: EdgeInsets.only(left: 15),
                height: 80,
                child: Row(
                  children: <Widget>[
                    Text("关于微博",style: TextStyle(fontSize: 18),),
                    Spacer(),
                    new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(""),
                    ),
                    new Container(
                      margin: const EdgeInsets.only(left: 5.0, right: 15),
                      child: new InkWell(
                        child: Image.asset(
                          Constant.ASSETS_IMG + "icon_right_arrow.png",
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 0.5,
              color: Colors.black12,
            ),
            InkWell(
              onTap: (){

              },
              child: Container(
                margin: EdgeInsets.only(left: 15),
                height: 80,
                child: Row(
                  children: <Widget>[
                    Text("清理缓存",style: TextStyle(fontSize: 18),),
                    Spacer(),
                    new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(""),
                    ),
                    new Container(
                      margin: const EdgeInsets.only(left: 5.0, right: 15),
                      child: new InkWell(
                        child: Image.asset(
                          Constant.ASSETS_IMG + "icon_right_arrow.png",
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 30,
              color: Colors.black12,
            ),
            InkWell(
              onTap: (){
                showDialog(context: context,barrierDismissible: true,builder: (context){
                      return AlertDialog(
                        content: Text("退出登录"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('确定'),
                            onPressed: () {
                              UserUtil.loginout();
                              Navigator.of(context).pop();
                              Routes.navigateTo(
                                  context, '${Routes.loginPage}',
                                  clearStack: true,
                                  transition: TransitionType.fadeIn);
                            },
                          ),
                          FlatButton(
                            child: Text('取消'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                        backgroundColor: Colors.white,
                        elevation: 20,
                        shape:RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ) ,
                      );
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 15),
                height: 80,
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("退出登录",style: TextStyle(fontSize: 18,color: Colors.red),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}