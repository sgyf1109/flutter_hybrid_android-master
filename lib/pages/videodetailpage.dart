import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutterhybridandroid/constant/constant.dart';
import 'package:flutterhybridandroid/model/VideoModel.dart';
import 'package:flutterhybridandroid/pages/videodetailcommentpage.dart';
import 'package:video_player/video_player.dart';

import 'videodetailintropage.dart';

class VideoDetailPage extends StatefulWidget {
  VideoModel mVideo;

  VideoDetailPage(this.mVideo);

  @override
  State<StatefulWidget> createState() {
    return _VideoDetailPageState();
  }
}

class _VideoDetailPageState extends State<VideoDetailPage> with SingleTickerProviderStateMixin{
  List<String> mTabList = ["简介", "评论"];
  TabController mTabController;
  VideoPlayerController videoPlayerController;

  ChewieController chewieController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mTabController = TabController(
      length: mTabList.length,
      vsync: ScrollableState(), //动画效果的异步处理
    );
    videoPlayerController = VideoPlayerController.network(Constant.baseUrl + "file/weibo3.mp4");
    chewieController= ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 2 / 1,
      autoPlay: true,
      looping: true,
    );

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
    chewieController.dispose();
  }
  @override
  Widget build(BuildContext context) {
   return SafeArea(child: Scaffold(
     backgroundColor: Colors.white,
     body: Column(
       children: <Widget>[
         new Container(
           height: 200,
           child: Chewie(
             controller: chewieController,
           ),
         ),
         Container(
           height: 50,
           child: Row(
             children: <Widget>[
               TabBar(
                 tabs: [
                   new Tab(
                     text: mTabList[0],
                   ),
                   new Tab(
                     text: mTabList[1],
                   ),
                 ],
                 isScrollable: true,
                 indicatorColor: Color(0xffFF3700),
                 indicator: UnderlineTabIndicator(
                     borderSide: BorderSide(
                         color: Color(0xffFF3700), width: 2),
                     insets: EdgeInsets.only(bottom: 7)),
                 labelColor: Color(0xff333333),
                 unselectedLabelColor: Color(0xff666666),
                 labelStyle: TextStyle(
                     fontSize: 16.0, fontWeight: FontWeight.w700),
                 unselectedLabelStyle: TextStyle(fontSize: 16.0),
                 indicatorSize: TabBarIndicatorSize.label,
                 controller: mTabController,
               ),
             ],
           ),
         ),
         Container(
           height: 1,
           color: Color(0xffE2E2E2),
         ),
         Expanded(
           child: TabBarView(
             children: <Widget>[
               VideoDetailIntroPage(widget.mVideo),
               VideoDetailCommentPage(),
             ],
             controller: mTabController,
           ),
         ),
       ],
     ),
   ));
  }
}