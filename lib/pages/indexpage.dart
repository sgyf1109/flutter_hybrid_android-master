import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterhybridandroid/pages/homepage.dart';
import 'package:flutterhybridandroid/util/toast_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'firstpage.dart';
import 'videopage.dart';
import 'findpage.dart';
import 'messagepage.dart';
import 'minepage.dart';

class IndexPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new IndexPageState();
  }
}

class IndexPageState extends State<IndexPage> {
  static const nativeChannel =
  const MethodChannel('com.example.flutter/native');
  static const flutterChannel =
  const MethodChannel('com.example.flutter/flutter');
  int _tabIndex = 0;
  var tabImages;
  var appBarTitles;
  var bottomTabs;
  var currentPage;
  DateTime lastPopTime;


  /*
   * 根据选择获得对应的normal或是press的icon
   */
  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 13.0, color: Colors.black));
    } else {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 13.0, color: Colors.black));
    }
  }

  Image getTabImage(path) {
    return new Image.asset(path, width: 25.0, height: 25.0);
  }

  void initData() {
    tabImages = [
      [
        getTabImage('assets/images/tabbar_home.png'),
        getTabImage('assets/images/tabbar_home_highlighted.png')
      ],
      [
        getTabImage('assets/images/tabbar_video.png'),
        getTabImage('assets/images/tabbar_video_highlighted.png')
      ],
      [
        getTabImage('assets/images/tabbar_discover.png'),
        getTabImage('assets/images/tabbar_discover_highlighted.png')
      ],
      [
        getTabImage('assets/images/tabbar_message_center.png'),
        getTabImage('assets/images/tabbar_message_center_highlighted.png')
      ],
      [
        getTabImage('assets/images/tabbar_profile.png'),
        getTabImage('assets/images/tabbar_profile_highlighted.png')
      ],
    ];

    appBarTitles = ['首页', '视频', '发现', '消息', '我'];
  }


  final List<Widget> tabBodies = [
    HomePage(),
    VideoPage(),
    FindPage(),//待测试滑动冲突问题
    MessagePage(),
    MinePage()
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initData();


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
  }


  @override
  Widget build(BuildContext context) {
    bottomTabs = [
      BottomNavigationBarItem(icon: getTabIcon(0), title: getTabTitle(0)),
      BottomNavigationBarItem(icon: getTabIcon(1), title: getTabTitle(1)),
      BottomNavigationBarItem(icon: getTabIcon(2), title: getTabTitle(2)),
      BottomNavigationBarItem(icon: getTabIcon(3), title: getTabTitle(3)),
      BottomNavigationBarItem(icon: getTabIcon(4), title: getTabTitle(4)),
    ];

    return SafeArea(
      child: WillPopScope(
        child: new Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,//fixed模式为上下结构
            items: bottomTabs,
            currentIndex: _tabIndex,
            onTap: (index) async{
              setState(() {
                _tabIndex=index;
                currentPage=tabBodies[_tabIndex];
              });
            },
          ),
          body: IndexedStack(//一个根据索引值来决定某个child显示的widget
            children:tabBodies,
            index: _tabIndex,
          ),
        ),
        onWillPop: (){
          // 点击返回键的操作
          if (lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            ToastUtil.show('再按一次退出应用');
          } else {
            lastPopTime = DateTime.now();
            // 退出app
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        },
      ),
    );
  }
}