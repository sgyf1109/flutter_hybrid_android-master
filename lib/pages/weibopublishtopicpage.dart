import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/model/WeiBoTopic.dart';
import 'package:flutterhybridandroid/model/WeiBoTopicType.dart';
import 'package:flutterhybridandroid/util/toast_util.dart';

typedef onMenuChecked = void Function(int value);

class WeiBoPublishTopicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WeiBoPublishTopicPageState();
  }
}

class _WeiBoPublishTopicPageState extends State<WeiBoPublishTopicPage> {
  List<WeiBoTopicType> mLeftTopicTypeList = new List();
  List<WeiBoTopic> mRightTopicList = new List();
  int _selectCount = 0;
  onMenuChecked onmenuChecked;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLeftTypeData();
    onmenuChecked = (int i) {
      if (_selectCount != i) {
        _selectCount = i;
      }
      setState(() {});

      loadRightTopicData(mLeftTopicTypeList[i].id.toString());
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "# 话题 电影 书 地点 股票",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xffee565656)),
                              ),
                            ],
                          ),
                        )),
                    onTap: () {
                      ToastUtil.show("搜索框");
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    ToastUtil.show("取消");
                  },
                  child: Container(
                    width: 60,
                    child: Text(
                      "取消",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Color(0xffEFEFEF),
            height: 1,
          ),
          Expanded(
              child: Row(
            children: <Widget>[leftList(mLeftTopicTypeList), RightListView()],
          ))
        ],
      ),
    ));
  }

  void loadLeftTypeData() async {
    DioManager.getInstance().post(ServiceUrl.getWeiBoTopicTypeList, null,
        (data) {
      data['data'].forEach((data) {
        mLeftTopicTypeList.add(WeiBoTopicType.fromJson(data));
      });
      loadRightTopicData(mLeftTopicTypeList[0].id.toString());
    }, (error) {});
  }

  void loadRightTopicData(String type) async {
    FormData params = FormData.fromMap({
      'topicType': type,
    });
    DioManager.getInstance().post(ServiceUrl.getWeiBoTopicList, params, (data) {
      mRightTopicList.clear();

      data['data'].forEach((data) {
        mRightTopicList.add(WeiBoTopic.fromJson(data));
      });
      setState(() {});
    }, (error) {
      mRightTopicList.clear();
      setState(() {});
      print("error拉");
    });
  }

  leftList(List<WeiBoTopicType> mLeftTopicTypeList) {
    return Expanded(
        child: Container(
            child: ListView.builder(
              itemBuilder: (contex, index) {
                return InkWell(
                  onTap: () {
                    onmenuChecked(index);
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      color: _selectCount == index
                          ? Colors.white
                          : Color(0xffEEEDF1),
                      border: Border(
                          left: BorderSide(
                              width: 5,
                              color: _selectCount == index
                                  ? Color(0xffF79A03)
                                  : Color(0xffEEEDF1))),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      mLeftTopicTypeList[index].name,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
              itemCount: mLeftTopicTypeList.length,
            ),
            color: Color(0xffEEEDF1)));
  }

  Widget RightListView() {
    return Expanded(
      flex: 3,
      child: Container(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                Navigator.of(context).pop(mRightTopicList[index]);
              },
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 45,
                          height: 45,
                          margin: EdgeInsets.only(right: 5,left: 15),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '${mRightTopicList[index].topicimg}'),
                                  fit: BoxFit.cover)),
                        ),
                        Expanded(child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "#" + mRightTopicList[index].topicdesc + "#",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "讨论" +
                                  mRightTopicList[index].topicdiscuss +
                                  "万",
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xff999999)),
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
                  Container(
                    color: Color(0xffEFEFEF),
                    height: 1,
                  )
                ],
              ),
            );
          },
          itemCount: mRightTopicList.length,
        ),
      ),
    );
  }
}
