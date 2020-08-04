import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/model/WeiBoModel.dart';
import 'package:flutterhybridandroid/util/user_util.dart';
import 'package:flutterhybridandroid/widgets/loading_container.dart';
import 'package:flutterhybridandroid/model/WeiBoListModel.dart';
import 'package:flutterhybridandroid/widgets/weiboitem/WeiBoItem.dart';
import 'weibodetailpage.dart';
//刷新状态枚举
enum LoadingStatus {
  //正在加载中
  STATUS_LOADING,
  //数据加载完毕
  STATUS_COMPLETED,
  //空闲状态
  STATUS_IDEL
}

class WeiBoFollowPage extends StatefulWidget {
  String mCatId = "";

  WeiBoFollowPage({Key key, @required this.mCatId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WeiBoFollowPageState();
  }
}

class _WeiBoFollowPageState extends State<WeiBoFollowPage>
    with AutomaticKeepAliveClientMixin {
  String mCatId = "";
  var loadingStatus = LoadingStatus.STATUS_IDEL;
  int mCurPage = 1;
  int totalCount = 0;
  bool isRefreshloading = true; //是否显示加载页面

  ScrollController _scrollController = new ScrollController();
  List<WeiBoModel> hotContentList = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("主页获取数据");

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

          if (hotContentList.length < totalCount) {
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
    return Scaffold(
      body: LoadingContainer(
          isLoading: isRefreshloading,
          child: hotContentList.length>0?RefreshIndicator(
            child: ListView.builder(
              itemCount: hotContentList.length + 1,
              itemBuilder: (ontext, index) {
                print("数目" +
                    "${hotContentList.length}" +
                    '===' +
                    "${totalCount}");

                if (index == hotContentList.length) {
                  return _buildLoadMore();
                } else {
                  return getContentItem(context, index, hotContentList);
                }
              },
              controller: _scrollController,
              physics:
              AlwaysScrollableScrollPhysics(), //当条目过少时listview某些嵌套情况下可能不会滚动
            ),
            onRefresh: getSubDataRefresh,
          ):Center(
            child: Text("暂无数据"),
          )),
    );
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
        child: hotContentList.length < totalCount
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

  Widget getContentItem(
      BuildContext context, int index, List<WeiBoModel> hotContentList) {
    WeiBoModel model = hotContentList[index];
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return WeiBoDetailPage(
            mModel: model,
          );
        }));
      },
      child: WeiBoItemWidget(mModel: model,isDetail: false,),
    );
  }

  Future getSubDataRefresh() async {
    FormData formData = FormData.fromMap({
      "catid": widget.mCatId,
      "pageNum": "1",
      "pageSize": Constant.PAGE_SIZE,
      "userId": UserUtil.getUserInfo().id,
    });
    await DioManager.getInstance().post(ServiceUrl.getWeiBo, formData, (data) {
      WeiBoListModel category = WeiBoListModel.fromJson(data);
      print("主页获取数据"+category.toString());

      setState(() {
        isRefreshloading = false;
        loadingStatus = LoadingStatus.STATUS_IDEL;
        mCurPage = 1;
        hotContentList = category.data.list;
        totalCount = category.data.total;
      });
    }, (error) {
      setState(() {
        isRefreshloading = false;
        loadingStatus = LoadingStatus.STATUS_IDEL;
      });
    });
  }

  Future getSubDataLoadMore(int mCurPage) async {
    FormData formData = FormData.fromMap({
      "catid": widget.mCatId,
      "pageNum": mCurPage,
      "pageSize": Constant.PAGE_SIZE,
      "userId": UserUtil.getUserInfo().id,
    });
    List<WeiBoModel> mListRecords = new List();

    await DioManager.getInstance().post(ServiceUrl.getWeiBo, formData, (data) {
      WeiBoListModel category = WeiBoListModel.fromJson(data);
      mListRecords = category.data.list;
      setState(() {
        loadingStatus = LoadingStatus.STATUS_IDEL;
        hotContentList.addAll(mListRecords);
      });
    }, (error) {
      setState(() {
        loadingStatus = LoadingStatus.STATUS_IDEL;
      });
    });
  }
}
