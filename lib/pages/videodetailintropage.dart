import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/model/VideoModel.dart';
import 'package:flutterhybridandroid/util/date_util.dart';

class VideoDetailIntroPage extends StatefulWidget {
  VideoModel mVideo;

  VideoDetailIntroPage(this.mVideo);

  @override
  State<StatefulWidget> createState() {
    return _VideoDetailIntroPageState();
  }
}

class _VideoDetailIntroPageState extends State<VideoDetailIntroPage> with AutomaticKeepAliveClientMixin{

  bool mZiDongPlaySwitch = false;
  List<VideoModel> mRecommendVideoList = new List();

  Future getmRecommendVideoList() async {
    FormData params = FormData.fromMap({
      'videoid': widget.mVideo.id,
    });
    DioManager.getInstance()
        .post(ServiceUrl.getVideoDetailRecommendList, params, (data) {
      mRecommendVideoList.clear();
      data['data'].forEach((data) {
        mRecommendVideoList.add(VideoModel.fromJson(data));
      });

      setState(() {});
    }, (error) {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getmRecommendVideoList();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                _authorRow(widget.mVideo),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    DateUtil.getFormatTime(DateTime.fromMillisecondsSinceEpoch(
                                widget.mVideo.createtime))
                            .toString() +
                        "   " +
                        widget.mVideo.playnum.toString() +
                        "次观看",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              Constant.ASSETS_IMG + 'video_detail_zhuanfa.png',
                              width: 25.0,
                              height: 25.0,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              child: Text(
                                "转发",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              Constant.ASSETS_IMG + 'video_detail_zan.png',
                              width: 25.0,
                              height: 25.0,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              child: Text(
                                "点赞",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              Constant.ASSETS_IMG + 'video_detail_share.png',
                              width: 25.0,
                              height: 25.0,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              child: Text(
                                "分享",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              Constant.ASSETS_IMG + 'video_detail_downlaod.png',
                              width: 25.0,
                              height: 25.0,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              child: Text(
                                "下载",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "接下来播放",
                      ),
                      Spacer(),
                      Text(
                        "自动播放",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Switch(
                          value: this.mZiDongPlaySwitch,
                          onChanged: (bool) {
                            setState(() {
                              this.mZiDongPlaySwitch = !this.mZiDongPlaySwitch;
                            });
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 15, right: 15),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return mRecommendVideoWidget(mRecommendVideoList[index],index);
                },childCount: mRecommendVideoList.length)),
          )
        ],
      ),
    );
  }

  //发布者昵称头像布局
  Widget _authorRow(VideoModel mVideo) {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 2),
      child: Row(
        children: <Widget>[
          InkWell(
            child: Container(
                child: mVideo.userisvertify == 0
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(mVideo.userheadurl),
                                fit: BoxFit.cover)),
                      )
                    : Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                      image: NetworkImage(mVideo.userheadurl),
                                      fit: BoxFit.cover),
                                )),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                child: Image.asset(
                                  (mVideo.userisvertify == 1)
                                      ? Constant.ASSETS_IMG +
                                          'home_vertify.webp'
                                      : Constant.ASSETS_IMG +
                                          'home_vertify2.webp',
                                  width: 15.0,
                                  height: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    //头像右边上面文字
                    children: <Widget>[
                      Center(
                        child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                            child: Text(mVideo.username,
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.black))),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(left: 5),
                          padding: new EdgeInsets.only(
                              top: 2.0, bottom: 2.0, left: 3.0, right: 3.0),
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 0.5),
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            '作者',
                            style: TextStyle(color: Colors.black, fontSize: 8),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(6.0, 2.0, 0.0, 0.0),
                      child: Text(
                          mVideo.userfancount.toString() + "粉丝  " + "视频博主",
                          style: TextStyle(
                              color: Color(0xff808080), fontSize: 11.0))),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
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
            ),
          )
        ],
      ),
    );
  }

  Widget mRecommendVideoWidget(VideoModel mModel, int index) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width * 3 / 8,
            child: Stack(
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage(fit:BoxFit.cover,placeholder: AssetImage(Constant.ASSETS_IMG + 'img_default.png'), image: NetworkImage(mModel.coverimg)),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 5,bottom: 5),
                    child: Text(
                        DateUtil.getFormatTime4(mModel.videotime)
                            .toString(),
                        style:
                        TextStyle(fontSize: 14.0, color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
          Expanded(child:Container(
            margin: EdgeInsets.only(left: 10),
            height: 80,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    child: Text(mModel.introduce,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14.0, color: Colors.black)),
                    //  margin: EdgeInsets.only(left: 60),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                            child: Text(
                              mModel.username.toString() + "  ",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            )),
                        Container(
                            child: Text(
                              mModel.playnum.toString(),
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            )),
                        Container(
                            child: Text(
                              "次观看 · ",
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            )),
                      ],
                    ),
                  )
                ],
            ),
          ))
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
