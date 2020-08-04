import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/model/WeiboAtUser.dart';
import 'package:lpinyin/lpinyin.dart';

class WeiBoPublishAtUserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeiBoPublishAtUserPageState();
  }
}

class _WeiBoPublishAtUserPageState extends State<WeiBoPublishAtUserPage> {
  List<WeiboAtUser> mNormalList = List();
  List<WeiboAtUser> mRecommendList = List();
  String _suspensionTag = "";
  int _suspensionHeight = 30;
  int _itemHeight = 60;


  @override
  void initState() {
    loadData();
    super.initState();

  }
  void loadData() async {
    DioManager.getInstance().post(ServiceUrl.getWeiBoAtUser, null, (data) {

      data['data']['hotusers'].forEach((data) {
        mRecommendList.add(WeiboAtUser.fromJson(data));
      });
      data['data']['normalusers'].forEach((data) {
        mNormalList.add(WeiboAtUser.fromJson(data));
      });

      mRecommendList.forEach((value) {
        value.tagIndex = "★";//推荐的下标为星，类似_hotCityList.add(CityInfo(name: "北京市", tagIndex: "★"));
      });
      _handleList(mNormalList);
      setState(() {
        _suspensionTag = mRecommendList[0].getSuspensionTag();//记录推荐的下标，返回tagIndex
      });
    }, (error) {});
  }

  void _handleList(List<WeiboAtUser> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].nick);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(mNormalList);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "联系人",
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
                          ],
                        ),
                      )),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: InkWell(
              child: Container(
                  padding: EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 45,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xffF4F4F4),
                    borderRadius: BorderRadius.all(
                      //圆角
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 5, top: 2),
                          child: Image.asset(
                            Constant.ASSETS_IMG + 'find_top_search.png',
                            width: 12.0,
                            height: 15.0,
                          ),
                        ),
                        Text(
                          "搜索",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14, color: Color(0xffee565656)),
                        ),
                      ],
                    ),
                  )),
              onTap: () {},
            ),
          ),
          Expanded(
              child: AzListView(
            data: mNormalList,
            topData: mRecommendList,
            itemBuilder: (context, sSuspensionBean) {
              return _buildListItem(sSuspensionBean);
            },
            suspensionWidget: _buildSusWidget(_suspensionTag),//每一个item的悬浮头部推荐联系人、A、B之类
            //悬停效果view
            isUseRealIndex: true,
            itemHeight: _itemHeight,
            suspensionHeight: _suspensionHeight,
            onSusTagChanged: _onSusTagChanged,
          ))
        ],
      ),
    ));
  }


  Widget _buildListItem(WeiboAtUser mModel) {
    String susTag = mModel.getSuspensionTag();
    susTag = (susTag == "1" ? "热门城市" : susTag);
    return Column(
      children: <Widget>[
        Offstage(
          offstage: mModel.isShowSuspension != true,//是否合并每一个悬浮
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 15),
                    child: CircleAvatar(
                      //头像半径
                      radius: 15,
                      //头像图片 -> NetworkImage网络图片，AssetImage项目资源包图片, FileImage本地存储图片
                      backgroundImage: NetworkImage('${mModel.headurl}'),
                    )),
                Container(
                  child: Text(
                    '${mModel.nick}',
                    style: TextStyle(
                        letterSpacing: 0, color: Colors.black, fontSize: 14),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).pop(mModel);
            },
          ),
        )
      ],
    );
  }

  Widget _buildSusWidget(String suspensionTag) {
    suspensionTag = (suspensionTag == "★" ? "推荐联系人" : suspensionTag);
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$suspensionTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }
}
