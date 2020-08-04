import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';

typedef void ITextFieldCallBack(String content);

class AccountEditText extends StatefulWidget {
  final ITextFieldCallBack contentStrCallBack;

  AccountEditText({Key key, this.contentStrCallBack}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new AccountEditTextState();
  }
}

class AccountEditTextState extends State<AccountEditText> {
  ///预设输入框的内容
  String _inputAccount = "";
  TextEditingController _controller;
  bool _isShowDelete = false;

  @override
  Widget build(BuildContext context) {
    ///控制 初始化的时候光标保持在文字最后
    _controller = TextEditingController.fromValue(//initState只执行一次
      ///用来设置初始化时显示
        TextEditingValue(
          ///用来设置文本 controller.text = "输入文本"
            text: _inputAccount,
            ///设置光标的位置
            selection: TextSelection.fromPosition(TextPosition(
              ///用来设置文本的位置
                affinity: TextAffinity.downstream,
                /// 光标向后移动的长度
                offset: _inputAccount.length))));
    return Container(
      child: TextField(
        controller: _controller,
        style: TextStyle(color: Colors.black, fontSize: 14),
        decoration: InputDecoration(
            counterText: "",//必须主动设置为空，否则会显示下标
            hintText: "手机号或者邮箱",
            contentPadding: EdgeInsets.only(left: 0, top: 14, bottom: 14),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange)),
            suffixIcon: _isShowDelete
                ? Container(
                    child: IconButton(
                        iconSize: 14.0,
                        icon: Image.asset(
                          Constant.ASSETS_IMG + 'icon_et_delete.png',
                          width: 14,
                          height: 14,
                        ),
                        onPressed: () {
                          setState(() {
                            resetWidget(" ");
                          });
                        }),
                  )
                : Text('')),
        onChanged: (str) {
          resetWidget(str);
        },
        keyboardType: TextInputType.text,
        maxLength: 20,
        maxLines: 1,
      ),
    );
  }

  void resetWidget(String str) {
      _inputAccount = str;
    _isShowDelete = (_inputAccount.isNotEmpty);
    widget.contentStrCallBack(_inputAccount);
  }
}
