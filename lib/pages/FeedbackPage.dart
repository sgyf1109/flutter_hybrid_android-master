import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/util/toast_util.dart';
import 'package:image_picker/image_picker.dart';

class FeedBackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedBackPageState();
  }
}

class _FeedBackPageState extends State<FeedBackPage> {
  TextEditingController _mEtController = new TextEditingController();
  File mSelectedImageFile;
  List<MultipartFile> mSubmitFileList = List();
  List<File> mFileList = List();

  @override
  Widget build(BuildContext context) {
    if (mSelectedImageFile != null) {
      mFileList.add(mSelectedImageFile);
    }
    mSelectedImageFile = null;

    return Scaffold(
        backgroundColor: Color(0xffF3F1F4),
        appBar: AppBar(
          backgroundColor: Color(0xffFAFAFA),
          leading: InkWell(
            child: Container(
              color: Color(0xffFAFAFA),
              padding: EdgeInsets.only(right: 15),
              alignment: Alignment.center,
              child: Text("取消"),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "意见反馈",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            InkWell(
              child: Container(
                color: Color(0xffFAFAFA),
                padding: EdgeInsets.only(right: 15),
                alignment: Alignment.center,
                child: Text("发送"),
              ),
              onTap: () {
                if (_mEtController.text.isEmpty) {
                  ToastUtil.show('内容不能为空!');
                  return;
                }

                mSubmitFileList.clear();
                for (int i = 0; i < mFileList.length; i++) {
                  mSubmitFileList.add(
                      MultipartFile.fromFileSync(mFileList.elementAt(i).path));
                }
                FormData formData = FormData.fromMap({
                  "description": _mEtController.text,
                  "files": mSubmitFileList
                });
                request(ServiceUrl.feedback, formData: formData).then((val) {
                  int code = val['status'];
                  String msg = val['msg'];
                  if (code == 200) {
                    ToastUtil.show('提交成功!');
                    setState(() {
                      mFileList.clear();
                      mSubmitFileList.clear();
                      _mEtController.clear();
                    });
                  } else {
                    ToastUtil.show(msg);
                  }
                });
              },
            )
          ],
          elevation: 0.5,
          centerTitle: true,
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView(
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 150,
                    ),
                    color: Color(0xffffffff),
                    child: TextField(
                      maxLength: 500,
                      maxLines: 5,
                      controller: _mEtController,
                      decoration: InputDecoration(
                          hintText: "快说点儿什么吧......",
                          contentPadding:
                              EdgeInsets.only(left: 15, right: 15, top: 10),
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: Color(0xff999999), fontSize: 15)),
                    ),
                  ),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: List.generate(mFileList.length + 1, (index) {
                      // 这个方法体用于生成GridView中的一个item
                      var content;
                      if (index == mFileList.length) {
                        // 添加图片按钮
                        var addCell = Center(
                            child: Image.asset(
                          Constant.ASSETS_IMG + 'mine_feedback_add_image.png',
                          width: double.infinity,
                          height: double.infinity,
                        ));
                        content = GestureDetector(
                          onTap: () {
                            // 添加图片
                            pickImage(context);
                          },
                          child: addCell,
                        );
                      } else {
                        // 被选中的图片
                        content = Stack(
                          children: <Widget>[
                            Center(
                              child: Image.file(
                                mFileList[index],
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () {
                                  mFileList.removeAt(index);
                                  mSelectedImageFile = null;
                                  setState(() {});
                                },
                                child: Image.asset(
                                  Constant.ASSETS_IMG +
                                      'mine_feedback_ic_del.png',
                                  width: 20.0,
                                  height: 20.0,
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        width: 80.0,
                        height: 80.0,
                        color: const Color(0xFFffffff),
                        child: content,
                      );
                    }),
                  )
                ],
              )),
              mFootView()
            ],
          ),
        ));
  }

  // 选择弹出相机拍照或者从图库选择图片
  pickImage(ctx) {
    // 如果已添加了9张图片，则提示不允许添加更多
    num size = mFileList.length;
    if (size >= 9) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text("最多只能添加9张图片！"),
      ));
      return;
    }
    showModalBottomSheet<void>(context: context, builder: _bottomSheetBuilder);
  }

  //弹出底部选择图片方式弹出框
  Widget _bottomSheetBuilder(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, //w
        children: <Widget>[
          _renderBottomMenuItem("相机拍照", ImageSource.camera),
          Divider(
            height: 2.0,
          ),
          _renderBottomMenuItem("图库选择照片", ImageSource.gallery)
        ],
      ),
    ));
  }

  //相机拍照或图库选择照片布局
  _renderBottomMenuItem(title, ImageSource source) {
    var item = Container(
      alignment: Alignment.center,
      height: 60.0,
      child: Text(title),
    );
    return InkWell(
      child: item,
      onTap: () {
        Navigator.of(context).pop();
        ImagePicker.pickImage(source: source).then((result) {
          setState(() {
            mSelectedImageFile = result;
            print("执行刷新:");
          });
        });
      },
    );
  }

  //底部布局
  Widget mFootView() {
    return new Container(
      color: Color(0xFFF9F9F9),
      //alignment:new Alignment(x, y)
      child: new Align(
        alignment: FractionalOffset.bottomCenter,
        child: new Padding(
          padding: EdgeInsets.all(10),
          child: new Row(children: <Widget>[
            new Expanded(
              child: InkWell(
                child: Image.asset(
                  Constant.ASSETS_IMG + 'icon_picture.png',
                  width: 25.0,
                  height: 25.0,
                ),
                onTap: () {},
              ),
              flex: 1,
            ),
            new Expanded(
              child: InkWell(
                child: Image.asset(
                  Constant.ASSETS_IMG + 'icon_mention.png',
                  width: 25.0,
                  height: 25.0,
                ),
                onTap: () {},
              ),
              flex: 1,
            ),
            new Expanded(
              child: InkWell(
                child: Image.asset(
                  Constant.ASSETS_IMG + 'icon_gif.png',
                  width: 25.0,
                  height: 25.0,
                ),
                onTap: () {},
              ),
              flex: 1,
            ),
            new Expanded(
              child: InkWell(
                child: Image.asset(
                  Constant.ASSETS_IMG + 'icon_emotion.png',
                  width: 25.0,
                  height: 25.0,
                ),
                onTap: () {},
              ),
              flex: 1,
            ),
            new Expanded(
              child: InkWell(
                child: Image.asset(
                  Constant.ASSETS_IMG + 'icon_add.png',
                  width: 25.0,
                  height: 25.0,
                ),
                onTap: () {},
              ),
              flex: 1,
            ),
          ]),
        ),
      ),
    );
  }
}
