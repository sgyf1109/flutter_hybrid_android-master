import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'SettingPage.dart';

class FirstPage extends StatefulWidget {
  String route;
  Map<String, dynamic> params;

  FirstPage(this.route, this.params);

  FirstPage.a();

  @override
  State<StatefulWidget> createState() {
    return _FirstPageState();
  }
}

class _FirstPageState extends State<FirstPage> {
  static const nativeChannel =
      const MethodChannel('com.example.flutter/native');
  static const flutterChannel =
      const MethodChannel('com.example.flutter/flutter');
  final _nameController = TextEditingController();

  static const _basicMessageChannel =
      const BasicMessageChannel('basic_channel', StringCodec());

  static const eventChannel = const EventChannel('event_channel');

  String message;
  String response;
  Map<dynamic, dynamic> params;

  @override
  void initState() {
    super.initState();
    Future<dynamic> handler(MethodCall call) async {
      switch (call.method) {
        case 'onActivityResult':
          Fluttertoast.showToast(
            msg: call.arguments['message'],
            toastLength: Toast.LENGTH_SHORT,
          );
          break;
        case 'goBack':
          // 返回上一页
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          } else {
            nativeChannel.invokeMethod('goBack');
          }
          break;
      }
    }

    flutterChannel.setMethodCallHandler(handler);

    //接受并回复消息
    _basicMessageChannel.setMessageHandler(
      (String message) => Future<String>(() {
        setState(() {
          Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
          );
          this.message = message;
        });
        return "回复native消息";//mBasicMessageChannel.send会接受到
      }),
    );

    eventChannel.receiveBroadcastStream().listen(_onData,onError:_onError);

  }

  void _onData(Object event) {
    //返回的内容
    Fluttertoast.showToast(
      msg: event.toString(),
      toastLength: Toast.LENGTH_SHORT,
    );
  }
  void _onError(Object error) {
    //返回的回调
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter页面'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '我是Flutter页面，route=${widget.route}，原生页面传过来的参数：name=${widget.params['name']}',
              style: TextStyle(fontSize: 16.0),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "请输入要传递到原生端的参数"),
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                  child: Text('返回上一页'),
                  onPressed: () {
                    Map<String, dynamic> result = {'message': '我从Flutter页面回来了'};
                    nativeChannel.invokeMethod('goBackWithResult', result);
                  }),
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                  child: Text('跳转Flutter页面'),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return SettingPage();
                    }));
                  }),
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                  child: Text('跳转Android原生页面'),
                  onPressed: () {
                    // 跳转原生页面
                    Map<String, dynamic> result = {
                      'name': _nameController.text
                    };
                    nativeChannel.invokeMethod('jumpToNative', result);
                  }),
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                  child: Text('向原生发送信息'),
                  onPressed: () async {
                    //发送消息
                    response=await _basicMessageChannel.send("来自flutter的message");
                    Fluttertoast.showToast(
                      msg: response,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                    //flutter并没有发送并接受回复消息的`send(T message, BasicMessageChannel.Reply<T> callback)`方法
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
