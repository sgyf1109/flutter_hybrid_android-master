import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/model/FindHomeModel.dart';

class FindTopicPage extends StatefulWidget {
  final Findtopic mModel;

  FindTopicPage({Key key, this.mModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FindTopicPageState();
  }
}

class _FindTopicPageState extends State<FindTopicPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey<String>('Tab2'),
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        Constant.ASSETS_IMG + "find_topic4.png",
                        width: 40,
                        height: 40,
                      ),
                      Text(
                        "话题榜单",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        Constant.ASSETS_IMG + "find_topic1.png",
                        width: 40,
                        height: 40,
                      ),
                      Text(
                        "火热参与",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        Constant.ASSETS_IMG + "find_topic2.png",
                        width: 40,
                        height: 40,
                      ),
                      Text(
                        "正在热议",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        Constant.ASSETS_IMG + "find_topic3.png",
                        width: 40,
                        height: 40,
                      ),
                      Text(
                        "兴趣话题",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 10,
            color: Color(0xffEEEEEE),
          ),
        ),
        SliverToBoxAdapter(
          child: Row(
            children: <Widget>[
              Container(
                height: 26,
                width: 3,
                color: Colors.orange,
                margin: EdgeInsets.only(top: 8, bottom: 8, right: 15),
              ),
              Expanded(
                child: Text(
                  "热门话题",
                  style: TextStyle(fontSize: 14, color: Color(0xff888888)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 15),
                child: Image.asset(
                  Constant.ASSETS_IMG + "find_hs_more.png",
                  width: 15,
                  height: 15,
                ),
              )
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 1,
            color: Color(0xffEEEEEE),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return mTopic1(index);
        }, childCount: 10)),
        SliverToBoxAdapter(
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 26,
                      width: 3,
                      margin: EdgeInsets.only(top: 8, bottom: 8, right: 15),
                      color: Colors.orange,
                    ),
                    Expanded(
                      child: Text(
                        "火热参与",
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff888888)),
                      ),
                    ),
                    Text(
                      "更多",
                      style: TextStyle(fontSize: 13, color: Color(0xff888888)),
                    ),
                    Container(
                      child: Image.asset(
                        Constant.ASSETS_IMG + "find_hs_more.png",
                        width: 15,
                        height: 15,
                      ),
                      margin: EdgeInsets.only(right: 10),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 1,
            color: Color(0xffEEEEEE),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10),
          sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: widget.mModel != null
                            ? Image.network(
                          '${widget.mModel.topic2[index].topicimg}',fit: BoxFit.cover,)
                            : Image.asset(Constant.ASSETS_IMG +
                            'img_default2.png'),
                        width: double.infinity,
                      ),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(top: 5),
                        child: new Text(
                          widget.mModel != null
                              ? widget.mModel.topic2[index].topicdesc
                              : "朋友总有办法吵醒熟睡的你",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      )),
                      Center(
                        child: new Text(
                          widget.mModel != null
                              ? widget.mModel.topic2[index].topicdiscuss
                              : "2700" + "参与",
                          style:
                              TextStyle(fontSize: 12, color: Color(0xff595959)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }, childCount: 3),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.6)),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 5),
            height: 10,
            color: Color(0xffEEEEEE),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 26,
                      width: 3,
                      margin: EdgeInsets.only(top: 8, bottom: 8, right: 15),
                      color: Colors.orange,
                    ),
                    Expanded(
                      child: Text(
                        "正在热议",
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff888888)),
                      ),
                    ),
                    Container(
                      child: Image.asset(
                        Constant.ASSETS_IMG + "find_hs_more.png",
                        width: 15,
                        height: 15,
                      ),
                      margin: EdgeInsets.only(right: 10),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 1,
            color: Color(0xffEEEEEE),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          if (index != 3) {
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                      width: 75,
                      height: 75,
                      child: widget.mModel != null
                          ? FadeInImage(
                              placeholder: AssetImage(
                                  Constant.ASSETS_IMG + 'img_default2.png'),
                              image: NetworkImage(
                                  '${widget.mModel.topic3[index].topicimg}'),
                              fit: BoxFit.cover,
                            )
                          : FadeInImage(
                              placeholder: AssetImage(
                                  Constant.ASSETS_IMG + 'img_default2.png'),
                              image: AssetImage(
                                  Constant.ASSETS_IMG + 'img_default2.png'),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: new Text(
                              widget.mModel != null
                                  ? widget.mModel.topic3[index].topicdesc
                                  : "#Yamy公司会议录音",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3, right: 15),
                            child: new Text(
                              widget.mModel != null
                                  ? widget.mModel.topic3[index].topicdiscuss +
                                      "讨论  " +
                                      widget.mModel.topic3[index].topicread +
                                      "阅读"
                                  : "14万讨论 8.8亿阅读",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 1,
                  color: Color(0xffEEEEEE),
                ),
              ],
            );
          } else {
            return Container(
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "查看更多议题",
                    style: TextStyle(fontSize: 14, color: Color(0xff797979)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 10),
                    child: Image.asset(
                      Constant.ASSETS_IMG + 'icon_right_arrow.png',
                      width: 15.0,
                      height: 13.0,
                    ),
                  )
                ],
              ),
            );
          }
        }, childCount: 4)),
        SliverToBoxAdapter(
          child: Container(
            height: 10,
            color: Color(0xffEEEEEE),
          ),
        ),
      ],
    );
  }

  Widget mTopic1(int index) {
    if (index.isEven) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(left: 15, right: 15, bottom: 3, top: 15),
                  child: Stack(
                    children: <Widget>[
                      if (widget.mModel != null)
                        FadeInImage(
                          width: 75,
                          height: 75,
                          placeholder: AssetImage(
                              Constant.ASSETS_IMG + 'img_default2.png'),
                          image: NetworkImage(
                              '${widget.mModel.topic1[index].topicimg}'),
                          fit: BoxFit.cover,
                        )
                      else
                        FadeInImage(
                          width: 75,
                          height: 75,
                          placeholder: AssetImage(
                              Constant.ASSETS_IMG + 'img_default2.png'),
                          image: AssetImage(
                              Constant.ASSETS_IMG + 'img_default2.png'),
                          fit: BoxFit.cover,
                        ),
                      Container(
                        child: Image.asset(
                          Constant.ASSETS_IMG + 'find_topic_red.webp',
                          fit: BoxFit.fill,
                          width: 20.0,
                          height: 20.0,
                        ),
                      ),
                      Container(
                        width: 20.0,
                        height: 20.0,
                        child: Center(
                          child: Text(
                            ((index + 2) / 2).floor().toString() + "",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: new Text(
                          widget.mModel != null
                              ? widget.mModel.topic1[index].topicdesc
                              : "#Yamy公司会议录音",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3, right: 15),
                        child: new Text(
                          widget.mModel != null
                              ? widget.mModel.topic1[index].topicdiscuss +
                                  "讨论  " +
                                  widget.mModel.topic1[index].topicread +
                                  "阅读"
                              : "14万讨论 8.8亿阅读",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 15, bottom: 10),
              child: new Text(
                widget.mModel != null
                    ? widget.mModel.topic1[index].topicintro
                    : "Yamy公开经济公司会议的录音",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            height: 1,
            color: Color(0xffEEEEEE),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20, right: 10),
                  child: Image.asset(
                    Constant.ASSETS_IMG + 'find_topic_red2.png',
                    width: 5.0,
                    height: 5.0,
                  ),
                ),
                Flexible(
                  child: new Text(
                      widget.mModel != null
                          ? '#${widget.mModel.topic1[index].topicdesc}#'
                          : "#遇到职场PUA该怎么办#",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Image.asset(
                    Constant.ASSETS_IMG + 'find_hs_hot.jpg',
                    width: 17.0,
                    height: 17.0,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 10,
            color: Color(0xffEEEEEE),
          ),
        ],
      );
    }
  }
}
