import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/routers/routers.dart';
import 'package:flutterhybridandroid/util/toast_util.dart';
import 'package:flutterhybridandroid/util/user_util.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  var tabImages;
  var bottomsImages;

  void initData() {
    tabImages = [
      [
        Image.asset(Constant.ASSETS_IMG + "icon_mine_pic.png",
            width: 25.0, height: 25.0),
        Text(
          "我的相册",
          style: TextStyle(color: Colors.black, fontSize: 16),
        )
      ],
      [
        Image.asset(Constant.ASSETS_IMG + "icon_mine_story.png",
            width: 25.0, height: 25.0),
        Text(
          "我的故事",
          style: TextStyle(color: Colors.black, fontSize: 16),
        )
      ],
      [
        Image.asset(Constant.ASSETS_IMG + "icon_mine_zan.png",
            width: 25.0, height: 25.0),
        Text(
          "我的赞",
          style: TextStyle(color: Colors.black, fontSize: 16),
        )
      ],
      [
        Image.asset(Constant.ASSETS_IMG + "icon_mine_fans.png",
            width: 25.0, height: 25.0),
        Text(
          "我的粉丝",
          style: TextStyle(color: Colors.black, fontSize: 16),
        )
      ],
      [
        Image.asset(Constant.ASSETS_IMG + "icon_mine_wallet.png",
            width: 25.0, height: 25.0),
        Text(
          "微博钱包",
          style: TextStyle(color: Colors.black, fontSize: 16),
        )
      ],
      [
        Image.asset(Constant.ASSETS_IMG + "icon_mine_gchoose.png",
            width: 25.0, height: 25.0),
        Text(
          "微博优选",
          style: TextStyle(color: Colors.black, fontSize: 16),
        )
      ],
      [
        Image.asset(Constant.ASSETS_IMG + "icon_mine_fannews.png",
            width: 25.0, height: 25.0),
        Text(
          "粉丝头条",
          style: TextStyle(color: Colors.black, fontSize: 16),
        )
      ],
      [
        Image.asset(Constant.ASSETS_IMG + "icon_mine_customservice.png",
            width: 25.0, height: 25.0),
        Text(
          "客服中心",
          style: TextStyle(color: Colors.black, fontSize: 16),
        )
      ],
    ];


    bottomsImages = [
      [
        Image.asset(Constant.ASSETS_IMG + "icon_mine_freenet.png",
            width: 25.0, height: 25.0),
        Text(
          "免流量",
          style: TextStyle(color: Colors.black, fontSize: 16),
        )
      ],
      [
        Image.asset(Constant.ASSETS_IMG + "icon_mine_sport.png",
            width: 25.0, height: 25.0),
        Text(
          "微博运动",
          style: TextStyle(color: Colors.black, fontSize: 16),
        )
      ],
      [
        Image.asset(Constant.ASSETS_IMG + "icon_mine_draft.png",
            width: 25.0, height: 25.0),
        Text(
          "草稿箱",
          style: TextStyle(color: Colors.black, fontSize: 16),
        )
      ],
    ];
  }

  @override
  void initState() {
    initData();
    super.initState();

    if (UserUtil.isLogin()) {
      print("请求参数的值是:" + UserUtil.getUserInfo().id);
      FormData params = FormData.fromMap({
        'muserId': UserUtil.getUserInfo().id,
        'otheruserId': UserUtil.getUserInfo().id,
      });
      DioManager.getInstance().post(ServiceUrl.getUserInfo, params, (data) {
        UserUtil.saveUserInfo(data['data']);
        setState(() {});
      }, (error) {});
    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    var isTopRoute = ModalRoute.of(context)
        .isCurrent; //判断当前路由是否为最顶层路由，如果胃true，则isActive也一定是true。
    if (isTopRoute) {
      if (UserUtil.isLogin()) {
        FormData params = FormData.fromMap({
          'muserId': UserUtil.getUserInfo().id,
          'otheruserId': UserUtil.getUserInfo().id,
        });
        DioManager.getInstance().post(ServiceUrl.getUserInfo, params, (data) {
          UserUtil.saveUserInfo(data['data']);
          //通过addPostFrameCallback可以做一些安全的操作，在有些时候是很有用的，
          // 它会在当前Frame绘制完后进行回调，并只会回调一次，如果要再次监听需要再设置。
          SchedulerBinding.instance
              .addPostFrameCallback((_) => setState(() {}));
        }, (error) {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _buildTitle(),
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 10,
            color: Color(0xffEEEEEE),
          ),
          Expanded(
              child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: _buildMyInfo(),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "249",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              child: Text(
                                "微博",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          ToastUtil.show("点击微博");
                        },
                      ),
                      InkWell(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "1487",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              child: Text(
                                "关注",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                        onTap: () {
//                          ToastUtil.show("点击关注");
                          Routes.navigateTo(context, Routes.personMyFollowPage,
                              transition: TransitionType.fadeIn);
                        },
                      ),
                      InkWell(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "107",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              child: Text(
                                "粉丝",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                        onTap: () {
//                          ToastUtil.show("点击粉丝");
                          Routes.navigateTo(context, Routes.personFanPage,
                              transition: TransitionType.fadeIn);
                        },
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 10,
                  color: Color(0xffEEEEEE),
                ),
              ),
              SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        tabImages[index][0],
                        tabImages[index][1]
                      ],
                    ),
                  );
                }, childCount: 8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 10,
                  color: Color(0xffEEEEEE),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context,index) {
                        return Container(
                          child:Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    bottomsImages[index][0],
                                    Expanded(child: Container(
                                        margin: EdgeInsets.only(left: 15),
                                        child:bottomsImages[index][1]
                                    ),),
                                    Image.asset(
                                      Constant.ASSETS_IMG + 'icon_right_arrow.png',
                                      width: 15.0,
                                      height: 30.0,
                                    )
                                  ],
                                ),
                                height: 65,
                                margin: EdgeInsets.only(left: 15,right: 15),
                              ),
                              Container(
                                height: 1,
                                color: Color(0xffEEEEEE),
                              )
                            ],
                          ),
                        );
                      },childCount: 3))
            ],
          ))
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  //顶部标题
  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 15),
              alignment: Alignment.centerLeft,
              child: Image.asset(
                Constant.ASSETS_IMG + 'icon_mine_add_friends.png',
                width: 25.0,
                height: 25.0,
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: new Text(
                '我',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.only(right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: InkWell(
                        child: Image.asset(
                          Constant.ASSETS_IMG + 'icon_mine_qrcode_2.png',
                          width: 25.0,
                          height: 25.0,
                        ),
                        onTap: () {},
                      ),
                    ),
                    Container(
                      child: InkWell(
                        child: Image.asset(
                          Constant.ASSETS_IMG + 'icon_mine_setting.png',
                          width: 25.0,
                          height: 25.0,
                        ),
                        onTap: () {
                          Routes.navigateTo(context, '${Routes.settingPage}');
                        },
                      ),
                    )
                  ],
                )),
            flex: 1,
          ),
        ],
      ),
    );
  }

  //我的信息
  Widget _buildMyInfo() {
    return InkWell(
      onTap: () {
        Routes.navigateTo(context, Routes.personinfoPage, params: {
          'userid': UserUtil.getUserInfo().id,
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 15, top: 15),
        child: Row(
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              child: UserUtil.getUserInfo().isvertify == 0
                  ? _mHeadWidget
                  : Stack(
                      children: <Widget>[
                        _mHeadWidget(),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            child: Image.asset(
                              (UserUtil.getUserInfo().isvertify == 1)
                                  ? Constant.ASSETS_IMG + 'home_vertify.webp'
                                  : Constant.ASSETS_IMG + 'home_vertify2.webp',
                              width: 16.0,
                              height: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: new Text(
                          UserUtil.getUserInfo().nick,
                          style: TextStyle(
                              fontSize: 14,
                              color: UserUtil.getUserInfo().ismember == 0
                                  ? Colors.black
                                  : Colors.orange),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        child: Center(
                          child: UserUtil.getUserInfo().ismember == 0
                              ? new Container()
                              : Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Image.asset(
                                    Constant.ASSETS_IMG + 'home_memeber.webp',
                                    width: 15.0,
                                    height: 13.0,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: new Text(
                      (UserUtil.getUserInfo() == null ||
                              UserUtil.getUserInfo().decs == null)
                          ? ""
                          : UserUtil.getUserInfo().decs,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )),
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Image.asset(
                        Constant.ASSETS_IMG + 'icon_right_arrow.png',
                        width: 15.0,
                        height: 30.0,
                      ),
                    )))
          ],
        ),
      ),
    );
  }

  Widget _mHeadWidget() {
    return (UserUtil.getUserInfo() == null ||
            UserUtil.getUserInfo().headurl == null)
        ? CircleAvatar(
            //头像半径
            radius: 25,
            //头像图片 -> NetworkImage网络图片，AssetImage项目资源包图片, FileImage本地存储图片
            backgroundImage:
                AssetImage(Constant.ASSETS_IMG + "ic_avatar_default.png"),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: AssetImage(Constant.ASSETS_IMG + 'img_default.png'),
              image: NetworkImage(UserUtil.getUserInfo().headurl),
            ),
          );
  }
}
