import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/model/VideoModel.dart';
import 'package:flutterhybridandroid/util/date_util.dart';
import 'package:flutterhybridandroid/util/user_util.dart';
import 'package:flutterhybridandroid/widgets/loading_container.dart';
import 'package:flutterhybridandroid/model/WeiBoListModel.dart';
import 'package:flutterhybridandroid/widgets/weiboitem/WeiBoItem.dart';

//刷新状态枚举
enum LoadingStatus {
  //正在加载中
  STATUS_LOADING,
  //数据加载完毕
  STATUS_COMPLETED,
  //空闲状态
  STATUS_IDEL
}

class VideoHotPage extends StatefulWidget {
  String mCatId = "";

  VideoHotPage({Key key, @required this.mCatId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VideoHotPageState();
  }
}

class _VideoHotPageState extends State<VideoHotPage>
    with AutomaticKeepAliveClientMixin {
  String mCatId = "";
  var loadingStatus = LoadingStatus.STATUS_IDEL;
  int mCurPage = 1;
  int totalCount = 0;
  bool isRefreshloading = true; //是否显示加载页面

  ScrollController _scrollController = new ScrollController();
  List<VideoModel> hotContentList = [];
  List<String> mBannerAdList = [];

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
          child: hotContentList.length > 0
              ? RefreshIndicator(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Image.asset(
                                  Constant.ASSETS_IMG + 'video_hot_top1.png',
                                  width: 45.0,
                                  height: 45.0,
                                ),
                                Text(
                                  "排行榜",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Image.asset(
                                  Constant.ASSETS_IMG + 'video_hot_type2.png',
                                  width: 45.0,
                                  height: 45.0,
                                ),
                                Text(
                                  "每周必看",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Image.asset(
                                  Constant.ASSETS_IMG + 'video_hot_type3.png',
                                  width: 45.0,
                                  height: 45.0,
                                ),
                                Text(
                                  "宝藏博主",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                Image.asset(
                                  Constant.ASSETS_IMG + 'video_hot_type4.png',
                                  width: 45.0,
                                  height: 45.0,
                                ),
                                Text(
                                  "更多频道",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ))
                          ],
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          if (index == 0 || index == 1 || index == 2) {
                            if (hotContentList.length > 0) {
                              return getContentItem(
                                  context, index, hotContentList);
                            } else {
                              return new Container();
                            }
                          } else if (index == 3) {
                            return Container(
                              height: 120,
                              child: Swiper(
                                  pagination: SwiperPagination(
                                    alignment: Alignment.bottomRight,
                                    builder: DotSwiperPaginationBuilder(
                                      color: Color(0xffF0F0F0),
                                      activeColor: Colors.orange,
                                      size: 7,
                                      space: 2,
                                      activeSize: 7
                                    )
                                  ),
                                  itemCount: mBannerAdList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      child: FadeInImage(
                                          fit: BoxFit.cover,
                                          placeholder: AssetImage(
                                              Constant.ASSETS_IMG +
                                                  'img_default2.png'),
                                          image: NetworkImage(
                                              mBannerAdList[index])),
                                    );
                                  }),
                            );
                          } else {
                            if (hotContentList.length > 3) {
                              return getContentItem(
                                  context, index - 1, hotContentList);
                            } else {
                              return new Container();
                            }
                          }
                        }, childCount: hotContentList.length + 1),
                      ),
                      new SliverToBoxAdapter(
                        child: _buildLoadMore(),
                      ),
                    ],
                  ),
                  onRefresh: getSubDataRefresh,
                )
              : Center(
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
      BuildContext context, int index, List<VideoModel> hotContentList) {
    VideoModel model = hotContentList[index];
    return InkResponse(
      //InkWell 水波纹限制在文本组件之内；InkResponse 水波纹没有限制；
      highlightColor: Colors.transparent, //取消水波纹的方法
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100,
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage(
                        fit: BoxFit.cover,
                        placeholder: AssetImage(
                            Constant.ASSETS_IMG + 'img_default2.png'),
                        image: NetworkImage(model.coverimg)),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 5, left: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 3),
                            child: Image.asset(
                              Constant.ASSETS_IMG + 'video_play.png',
                              width: 15.0,
                              height: 15.0,
                            ),
                          ),
                          Text(model.playnum.toString(),
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.white)),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Text(
                                DateUtil.getFormatTime4(model.videotime)
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.white)),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
          Container(
            height: 40,
            margin: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width,
            child: Text(
              model.introduce,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    if (model.recommengstr == "null")
                      if (model.tag == "null")
                        new Container()
                      else
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            model.tag.toString(),
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        )
                    else
                      new Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            model.recommengstr,
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(
                              //圆角
                              Radius.circular(5.0),
                            ),
                            color: Color(0xffFEF5E2),
                          ))
                  ],
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 3),
                  child: Image.asset(
                    Constant.ASSETS_IMG + 'video_ver_more.png',
                    width: 15.0,
                    height: 15.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future getSubDataRefresh() async {
    FormData formData = FormData.fromMap({
      "pageNum": "1",
      "pageSize": Constant.PAGE_SIZE,
    });

    List<VideoModel> list = List();
    await DioManager.getInstance()
        .post(ServiceUrl.getVideoHotList, formData, (data) {
      data['data']['list'].forEach((data) {
        list.add(VideoModel.fromJson(data));
      });

      setState(() {
        isRefreshloading = false;
        loadingStatus = LoadingStatus.STATUS_IDEL;
        mCurPage = 1;
        hotContentList = list;
        totalCount = data['data']['total'];
      });
    }, (error) {
      setState(() {
        isRefreshloading = false;
        loadingStatus = LoadingStatus.STATUS_IDEL;
      });
    });

    DioManager.getInstance().post(
        //Dio使用post提交表单请求时，每次重新提交时，data参数都需要传入一个新的表单对象。
        ServiceUrl.getVideoHotBannerAdList,
        FormData.fromMap({
          "pageNum": "1",
          "pageSize": Constant.PAGE_SIZE,
        }), (data) {
      List<String> list = List();
      data['data'].forEach((data) {
        list.add(data.toString());
      });
      mBannerAdList = list;
      setState(() {});
    }, (error) {});
  }

  Future getSubDataLoadMore(int mCurPage) async {
    FormData formData = FormData.fromMap({
      "pageNum": mCurPage,
      "pageSize": Constant.PAGE_SIZE,
    });
    List<VideoModel> mListRecords = new List();

    await DioManager.getInstance()
        .post(ServiceUrl.getVideoHotList, formData, (data) {
      data['data']['list'].forEach((data) {
        mListRecords.add(VideoModel.fromJson(data));
      });
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
