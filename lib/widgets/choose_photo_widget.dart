import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/util/toast_util.dart';
import 'package:image_picker/image_picker.dart';

class ChoosePhotoWidget extends StatelessWidget {
  final ValueChanged<File> chooseImgCallBack;

  ChoosePhotoWidget({Key key, this.chooseImgCallBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,//wrap_content
        children: <Widget>[
          InkWell(
            onTap: (){
              Navigator.pop(context);
              Future<File> imageFile =
              ImagePicker.pickImage(source: ImageSource.camera);
              imageFile.then((value) => chooseImgCallBack(value));
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: Text("立即拍照"),
            ),
          ),
          Container(
            height: 0.5,
            color: Colors.black12,
            //  margin: EdgeInsets.only(left: 60),
          ),
          InkWell(
            onTap: (){
              Navigator.pop(context);
              Future<File> imageFile =
              ImagePicker.pickImage(source: ImageSource.gallery);
              imageFile.then((value) => chooseImgCallBack(value));
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: Text("从相册选择"),
            ),
          ),
          Container(
            height: 0.5,
            color: Colors.black12,
            //  margin: EdgeInsets.only(left: 60),
          ),
          InkWell(
            onTap: (){
             ToastUtil.show("查看大图");
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: Text("查看大图"),
            ),
          ),
          Container(
            height: 10,
            color: Colors.black12,
            //  margin: EdgeInsets.only(left: 60),
          ),
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              height: 60,
              child: Text("取消"),
            ),
          ),
        ],
      ),
    );
  }
}
