import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/http/service_method.dart';
import 'package:flutterhybridandroid/http/service_url.dart';
import 'package:flutterhybridandroid/util/toast_util.dart';
import 'package:flutterhybridandroid/util/user_util.dart';

class CommentDialogPage extends StatefulWidget {
  String mWeiBoOrCommentId;
  bool isReplyWeiBo; //评论微博或者评论微博的回复
  Function() notifyParent;

  CommentDialogPage(
      this.mWeiBoOrCommentId, this.isReplyWeiBo, this.notifyParent);

  @override
  State<StatefulWidget> createState() {
    return _CommentDialogPageState();
  }
}

class _CommentDialogPageState extends State<CommentDialogPage> {
  TextEditingController _inputController = TextEditingController();
  bool _checkValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff8C333333),
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Color(0xffF8F8F8),
            height: 180,
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[buildTextField(), _buildEtRight()],
                ),
                Expanded(child: buildEtBottom())
              ],
            ),
          ),
        ));
  }

  Widget buildTextField() {
    return Container(
      margin: EdgeInsets.only(left: 15, top: 15),
      width: ((MediaQuery.of(context).size.width / 5) * 4),
      child: TextField(
        maxLines: 5,
        controller: _inputController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 5, right: 10, top: 10),
          //修改TextField的高度可以通过decoration: InputDecoration的contentPadding进行修改，代码如下
          filled: true,
          fillColor: Colors.white,
          hintText: "写评论",
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2),
              borderRadius: const BorderRadius.all(const Radius.circular(5.0))),
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
            borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
          ),
        ),
      ),
    );
  }

  //输入框底部布局
  Widget buildEtBottom() {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 5, bottom: 5, top: 10),
        child: Row(
          /* mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,*/
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  _checkValue = !_checkValue;
                });
              },
              child: Container(
                // decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: _checkValue
                      ? Image.asset(
                          Constant.ASSETS_IMG + 'guide_checkbox_checked.png',
                          width: 20.0,
                          height: 20.0,
                        )
                      : Image.asset(
                          Constant.ASSETS_IMG + 'guide_checkbox.png',
                          width: 20.0,
                          height: 20.0,
                        ),
                ),
              ),
            ),
            Text('同时转发'),
            new Expanded(
              child: InkWell(
                child: Image.asset(
                  Constant.ASSETS_IMG + 'icon_picture.png',
                  width: 20.0,
                  height: 20.0,
                ),
                onTap: () {},
              ),
              flex: 1,
            ),
            new Expanded(
              child: InkWell(
                child: Image.asset(
                  Constant.ASSETS_IMG + 'icon_mention.png',
                  width: 20.0,
                  height: 20.0,
                ),
                onTap: () {},
              ),
              flex: 1,
            ),
            new Expanded(
              child: InkWell(
                child: Image.asset(
                  Constant.ASSETS_IMG + 'icon_gif.png',
                  width: 20.0,
                  height: 20.0,
                ),
                onTap: () {},
              ),
              flex: 1,
            ),
            new Expanded(
              child: InkWell(
                child: Image.asset(
                  Constant.ASSETS_IMG + 'icon_emotion.png',
                  width: 20.0,
                  height: 20.0,
                ),
                onTap: () {},
              ),
              flex: 1,
            ),
            new Expanded(
              child: InkWell(
                child: Image.asset(
                  Constant.ASSETS_IMG + 'icon_add.png',
                  width: 20.0,
                  height: 20.0,
                ),
                onTap: () {},
              ),
            ),
          ],
        ));
  }

  Widget _buildEtRight() {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        children: <Widget>[
          Container(
            child: Image.asset(
              Constant.ASSETS_IMG + 'icon_comment_zhankai.png',
              width: 20.0,
              height: 20.0,
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 65),
              child: InkWell(
                child: Text('发送'),
                onTap: () {

                  if(_inputController.text.isEmpty){
                    ToastUtil.show('评论不能为空!');
                    return ;
                  }

                  if (widget.isReplyWeiBo) {
                    //如果是评论微博
                    FormData formData = FormData.fromMap({
                      "userId": UserUtil.getUserInfo().id,
                      "content": _inputController.text.toString(),
                      "weiboId": widget.mWeiBoOrCommentId
                    });
                    DioManager.getInstance()
                        .post(ServiceUrl.addComments, formData, (data) {
                      _inputController.clear();
                      ToastUtil.show('评论成功!');
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.notifyParent();
                    }, (error) {
                      ToastUtil.show('评论失败:' + error);
                    });
                  } else {
                    //如果是评论微博的回复
                    FormData formData = FormData.fromMap({
                      "userId": UserUtil.getUserInfo().id,
                      "content": _inputController.text.toString(),
                      "commentid": widget.mWeiBoOrCommentId
                    });
                    DioManager.getInstance().post(
                        ServiceUrl.addCommentsReply, formData, (data) {
                      _inputController.clear();
                      ToastUtil.show('评论成功!');
                      FocusScope.of(context).requestFocus(FocusNode());
                      widget.notifyParent();
                    }, (error) {
                      ToastUtil.show('评论失败:' + error);
                    });
                  }
                },
              ))
        ],
      ),
    ));
  }
}
