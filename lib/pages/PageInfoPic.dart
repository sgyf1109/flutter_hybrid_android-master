import 'package:flutter/material.dart';

class PageInfoPic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageInfoPicState();
  }
}

class _PageInfoPicState extends State<PageInfoPic> {
  @override
  Widget build(BuildContext context) {
    blockList.clear();
    for (int i = 0; i < 3; i++) {
      List<String> mPicList = new List();
      if (i == 0) {
        mPicList.add(
            "https://hrlweibo-1259131655.cos.ap-beijing.myqcloud.com/uinfo_pic_bottom1.jpg");
        mPicList.add(
            "https://hrlweibo-1259131655.cos.ap-beijing.myqcloud.com/uinfo_pic_bottom2.jpg");
        mPicList.add(
            "https://hrlweibo-1259131655.cos.ap-beijing.myqcloud.com/uinfo_pic_bottom3.jpg");
        mPicList.add(
            "https://hrlweibo-1259131655.cos.ap-beijing.myqcloud.com/uinfo_pic_bottom4.jpg");
      } else if (i == 1) {
        mPicList.add(
            "https://hrlweibo-1259131655.cos.ap-beijing.myqcloud.com/uinfo_pic_bottom5.jpg");
        mPicList.add(
            "https://hrlweibo-1259131655.cos.ap-beijing.myqcloud.com/uinfo_pic_bottom6.jpg");
        mPicList.add(
            "https://hrlweibo-1259131655.cos.ap-beijing.myqcloud.com/uinfo_pic_bottom7.jpg");
      } else if (i == 2) {
        mPicList.add(
            "https://hrlweibo-1259131655.cos.ap-beijing.myqcloud.com/uinfo_pic_bottom1.jpg");
      }
      blockList.add(mPicList);
    }

        return Container(
          color: Color(0xffEFEEEC),
          child:ListView.builder(itemBuilder: (context,index){
            return index==0?mPicTop():Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin:
                    EdgeInsets.only(top: 10, bottom: 5, left: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(index.toString() + "月",
                        style: TextStyle(
                            color: Colors.black, fontSize: 14)),
                  ),
                  mPicNormal(blockList[index - 1])
                ],
              ),
            );
          }, padding: EdgeInsets.only(top: 0),itemCount: 4) ,
        );
  }

  Widget mPicTop() {
    return Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(top: 15),
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - 75) / 4,
                    height: (MediaQuery.of(context).size.width - 75) / 4 + 50,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: (MediaQuery.of(context).size.width - 75) / 4,
                          height: (MediaQuery.of(context).size.width - 75) / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://hrlweibo-1259131655.cos.ap-beijing.myqcloud.com/uinfo_pic_top1.jpg'),
                                fit: BoxFit.cover,
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 5),
                          child: Text('全部图片',
                              style:
                              TextStyle(color: Colors.black, fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width - 75) / 4,
                    height: (MediaQuery.of(context).size.width - 75) / 4 + 50,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: (MediaQuery.of(context).size.width - 75) / 4,
                          height: (MediaQuery.of(context).size.width - 75) / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://hrlweibo-1259131655.cos.ap-beijing.myqcloud.com/uinfo_pic_top2.jpg'),
                                fit: BoxFit.cover,
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 5),
                          child: Text('头像图片',
                              style:
                              TextStyle(color: Colors.black, fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width - 75) / 4,
                    height: (MediaQuery.of(context).size.width - 75) / 4 + 50,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: (MediaQuery.of(context).size.width - 75) / 4,
                          height: (MediaQuery.of(context).size.width - 75) / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://hrlweibo-1259131655.cos.ap-beijing.myqcloud.com/uinfo_pic_top3.jpg'),
                                fit: BoxFit.cover,
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 5),
                          child: Text('赞过的图',
                              style:
                              TextStyle(color: Colors.black, fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width - 75) / 4,
                    height: (MediaQuery.of(context).size.width - 75) / 4 + 50,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: (MediaQuery.of(context).size.width - 75) / 4,
                          height: (MediaQuery.of(context).size.width - 75) / 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://hrlweibo-1259131655.cos.ap-beijing.myqcloud.com/uinfo_pic_top4.jpg'),
                                fit: BoxFit.cover,
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 5),
                          child: Text('更多图片',
                              style:
                              TextStyle(color: Colors.black, fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget mPicNormal(List<String> mList) {
    List<Widget> mListWidget = new List();
    for (int i = 0; i < mList.length; i++) {
      mListWidget.add(
        Container(
          width: (MediaQuery.of(context).size.width - 30) / 3,
          height: (MediaQuery.of(context).size.width - 30) / 3 - 20,
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: NetworkImage(mList[i]),
                fit: BoxFit.cover,
              )),
        ),
      );
    }

    return Container(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Wrap(
                      spacing: 5, //主轴上子控件的间距
                      runSpacing: 5, //交叉轴上子控件之间的间距
                      children: mListWidget),
                )),
          ],
        ));
  }

  List<List<String>> blockList = [];
}

