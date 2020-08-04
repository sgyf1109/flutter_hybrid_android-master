import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/model/FanFollowModel.dart';
import 'package:flutterhybridandroid/util/toast_util.dart';
import 'package:flutterhybridandroid/util/user_util.dart';

class FFRecommandPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FFRecommandPageState();
  }
}

//刷新状态枚举
enum LoadingStatus {
  //正在加载中
  STATUS_LOADING,
  //数据加载完毕
  STATUS_COMPLETED,
  //空闲状态
  STATUS_IDEL
}

class _FFRecommandPageState extends State<FFRecommandPage>
    with AutomaticKeepAliveClientMixin {
  var loadingStatus = LoadingStatus.STATUS_IDEL;
  int mCurPage = 1;
  int totalCount = 0;
  bool isRefreshloading = true; //是否显示加载页面

  ScrollController _scrollController = new ScrollController();
  List<FanFollowModel> mRecommendList = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubDataRefresh();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == //滑动距离
          _scrollController.position.maxScrollExtent) {
        ///最大可滑动距离，滑动组件内容长度
        print("调用加载更多");
        if (loadingStatus == LoadingStatus.STATUS_IDEL) {
          setState(() {
            loadingStatus = LoadingStatus.STATUS_LOADING;
          });

          if (mRecommendList.length < totalCount) {
            setState(() {
              mCurPage += 1;
            });
            getSubDataLoadMore(mCurPage);
          } else {
            setState(() {
              loadingStatus = LoadingStatus.STATUS_COMPLETED;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: RefreshIndicator(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverToBoxAdapter(
                  child: Container(
                color: Colors.white,
                height: 60,
                margin: EdgeInsets.only(bottom: 12),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: new EdgeInsets.only(left: 15.0, right: 15),
                      child: Image.asset(
                        Constant.ASSETS_IMG + "icon_find_friend.png",
                        width: 27,
                        height: 27,
                      ),
                    ),
                    Container(
                      child: Text("去寻找大V"),
                    ),
                    Spacer(),
                    new Container(
                      margin: const EdgeInsets.only(left: 5.0, right: 15),
                      child: Image.asset(
                        Constant.ASSETS_IMG + "icon_right_arrow.png",
                        width: 15,
                        height: 15,
                      ),
                    ),
                  ],
                ),
              )),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return getContentItem(index, mRecommendList[index]);
              }, childCount: mRecommendList.length)),
              new SliverToBoxAdapter(
                child: _buildLoadMore(),
              ),
            ],
          ),
          onRefresh: getSubDataRefresh),
    );
  }

  Future getSubDataRefresh() async {
    FormData params = FormData.fromMap({
      'userId': UserUtil.getUserInfo().id,
      'pageNum': "$mCurPage",
      "pageSize": Constant.PAGE_SIZE,
    });
    DioManager.getInstance().post(ServiceUrl.getFanFollowRecommend, params,
        (data) {
      List<FanFollowModel> list = List();
      data['data']['list'].forEach((data) {
        list.add(FanFollowModel.fromJson(data));
      });
      loadingStatus = LoadingStatus.STATUS_IDEL;
      mCurPage = 1;
      mRecommendList = list;
      totalCount = data['data']['total'];
      setState(() {});
    }, (error) {});
  }

  Future getSubDataLoadMore(int mCurPage) async {
    FormData params = FormData.fromMap({
      'userId': UserUtil.getUserInfo().id,
      'pageNum': "$mCurPage",
      "pageSize": Constant.PAGE_SIZE,
    });
    DioManager.getInstance().post(ServiceUrl.getFanFollowRecommend, params,
            (data) {
          List<FanFollowModel> list = List();
          data['data']['list'].forEach((data) {
            list.add(FanFollowModel.fromJson(data));
          });
          loadingStatus = LoadingStatus.STATUS_IDEL;
          mRecommendList.addAll(list);
          setState(() {});
        }, (error) {});
  }

  Widget getContentItem(int index, FanFollowModel mModel) {
    return Container(
      padding: EdgeInsets.only(top: 13),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: CircleAvatar(
                    //头像半径
                    radius: 22,
                    //头像图片 -> NetworkImage网络图片，AssetImage项目资源包图片, FileImage本地存储图片
                    backgroundImage:
                    NetworkImage(mModel.headurl.isEmpty ? "" : mModel.headurl),
                  )),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      '${mModel.nick}',
                      style: TextStyle(
                          letterSpacing: 0,
                          color: Colors.black,
                          fontSize: 14),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      '${mModel.decs}',
                      style: TextStyle(
                          letterSpacing: 0,
                          color: Color(0xff666666),
                          fontSize: 12),
                    ),
                  )
                ],
              )),
              Container(
                  margin: EdgeInsets.only(right: 15),
                  child: mFllowBtnWidget(mModel)
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 0.5,
            color: Colors.black12, //  margin: EdgeInsets.only(left: 60),
          ),
        ],
      ),
    );
  }

 Widget mFllowBtnWidget(FanFollowModel mModel) {
    if(mModel.relation==0){
      return   Container(
        child:InkWell(
          onTap: () async{
            await showCancelFollowDialog(mModel);
          },
          child: Container(
            margin: EdgeInsets.only(left: 5),
            padding: new EdgeInsets.only(
                top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xff999999)),
              borderRadius: new BorderRadius.circular(12.0),
            ),
            child: Text(
              '已关注',
              style: TextStyle(color:Color(0xff333333), fontSize: 12),
            ),
          ),
        ) ,
      );
    }else if(mModel.relation == 1){
      return   Container(
        child:InkWell(
          onTap: () {
            FormData params = FormData.fromMap({
              'userid': UserUtil.getUserInfo().id,
              'otheruserid': mModel.id,
            });
            DioManager.getInstance().post(ServiceUrl.followOther, params,
                    (data) {
                  int mRelation = data['data']['relation'];
                  mModel.relation = mRelation;
                  setState(() {});
                }, (error) {
                  ToastUtil.show(error);
                });
          },
          child: Container(
            margin: EdgeInsets.only(left: 5),
            padding: new EdgeInsets.only(
                top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.orange),
              borderRadius: new BorderRadius.circular(12.0),
            ),
            child: Text(
              '+ 关注',
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ),
        ) ,
      );
    }else if(mModel.relation == 2){
      return   Container(
        child:InkWell(
          onTap: ()async{
            await showCancelFollowDialog(mModel);
          },
          child: Container(
            margin: EdgeInsets.only(left: 5),
            padding: new EdgeInsets.only(
                top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.orange),
              borderRadius: new BorderRadius.circular(12.0),
            ),
            child: Text(
              '相互关注',
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ),
        ) ,
      );
    }
 }

 Future showCancelFollowDialog(FanFollowModel mModel) async {
      await showDialog(context: context,builder:(BuildContext context){
     return AlertDialog(
       title: Text("提示"),
       content: Text("确定不再关注"),
       actions: <Widget>[
         FlatButton(
             child: Text("取消"),
             onPressed: () => Navigator.pop(context)),
         FlatButton(
             child: Text("确定"),
             onPressed: (){
               FormData params = FormData.fromMap({
                 'userid': UserUtil.getUserInfo().id,
                 'otheruserid': mModel.id,
               });
               DioManager.getInstance()
                   .post(ServiceUrl.followCancelOther, params, (data) {
                 Navigator.of(context).pop();
                 int mRelation = data['data']['relation'];
                 mModel.relation = mRelation;
                 setState(() {});
               }, (error) {
                 ToastUtil.show(error);
               });
             }),
       ],
     );
   });
 }
  Widget _buildLoadMore() {
    if (loadingStatus == LoadingStatus.STATUS_LOADING) {
      return Container(
        child: Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: SizedBox(
                    //能强制子控件具有特定宽度、高度或两者都有,使子控件设置的宽高失效
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                    height: 12.0,
                    width: 12.0,
                  ),
                ),
                Text("加载中..."),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        child: mRecommendList.length < totalCount
            ? new Container()
            : Center(
          child: Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                "没有更多数据",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )),
        ),
      );
    }
  }
}
