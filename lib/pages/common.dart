import 'dart:async';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

class SecondaryTabView extends StatefulWidget {
  const SecondaryTabView(this.tabKey, this.tc, this.oldDemo);

  final String tabKey;
  final TabController tc;
  final bool oldDemo;

  @override
  _SecondaryTabViewState createState() => _SecondaryTabViewState();
}

class _SecondaryTabViewState extends State<SecondaryTabView>
    with AutomaticKeepAliveClientMixin {
  final List<String> _tabValues = [
    '热点',
    '本地',
    '话题',
    '超话',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final TabBar secondaryTabBar = TabBar(
      tabs: [
        new Tab(
          text: _tabValues[0],
        ),
        new Tab(
          text: _tabValues[1],
        ),
        new Tab(
          text: _tabValues[2],
        ),
        new Tab(
          text: _tabValues[3],
        ),
      ],
      isScrollable: true,
      indicatorColor: Color(0xffFF3700),
      indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Color(0xffFF3700), width: 2),
          insets: EdgeInsets.only(bottom: 7)),
      labelColor: Color(0xff333333),
      unselectedLabelColor: Color(0xff666666),
      labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
      unselectedLabelStyle: TextStyle(fontSize: 16.0),
      indicatorSize: TabBarIndicatorSize.label,
      controller: widget.tc,
    );
    return Column(
      children: <Widget>[
        secondaryTabBar,
        Expanded(
          child: TabBarView(
            controller: widget.tc,
            children: <Widget>[
              TabViewItem(Key(widget.tabKey + '0'), widget.oldDemo),
              TabViewItem(Key(widget.tabKey + '1'), widget.oldDemo),
              TabViewItem(Key(widget.tabKey + '2'), widget.oldDemo),
              TabViewItem(Key(widget.tabKey + '3'), widget.oldDemo),
            ],
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TabViewItem extends StatefulWidget {
  const TabViewItem(this.tabKey, this.oldDemo);

  final Key tabKey;
  final bool oldDemo;

  @override
  _TabViewItemState createState() => _TabViewItemState();
}

class _TabViewItemState extends State<TabViewItem>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ListView child = ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemBuilder: (BuildContext c, int i) {
          return Container(
            //decoration: BoxDecoration(border: Border.all(color: Colors.orange,width: 1.0)),
            alignment: Alignment.center,
            height: 60.0,
            width: double.infinity,
            //color: Colors.blue,
            child: Text(widget.tabKey.toString() + ': List$i'),
          );
        },
        itemCount: 100,
        padding: const EdgeInsets.all(0.0));

    if (widget.oldDemo) {
      return NestedScrollViewInnerScrollPositionKeyWidget(widget.tabKey, child);
    }

    /// new one doesn't need NestedScrollViewInnerScrollPositionKeyWidget any more.
    else {
      return child;
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class CommonSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  CommonSliverPersistentHeaderDelegate(this.child, this.height);

  final Widget child;
  final double height;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(CommonSliverPersistentHeaderDelegate oldDelegate) {
    //print('shouldRebuild---------------');
    return oldDelegate != this;
  }
}

Future<bool> onRefresh() {
  return Future<bool>.delayed(const Duration(seconds: 1), () {
    return true;
  });
}

List<Widget> buildSliverHeader() {
  final List<Widget> widgets = <Widget>[];

  widgets.add(SliverAppBar(
      pinned: true,
      expandedHeight: 200.0,
      //title: Text(old ? 'old demo' : 'new demo'),
      flexibleSpace: FlexibleSpaceBar(
          //centerTitle: true,
          collapseMode: CollapseMode.pin,
          background: Image.asset(
            'assets/467141054.jpg',
            fit: BoxFit.fill,
          ))));

  widgets.add(SliverGrid(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      crossAxisSpacing: 0.0,
      mainAxisSpacing: 0.0,
    ),
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Container(
          alignment: Alignment.center,
          height: 60.0,
          child: Text('Gird$index'),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.orange, width: 1.0)),
        );
      },
      childCount: 7,
    ),
  ));

  widgets.add(SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext c, int i) {
    return Container(
      alignment: Alignment.center,
      height: 60.0,
      child: Text('SliverList$i'),
    );
  }, childCount: 3)));

//  widgets.add(SliverPersistentHeader(
//      pinned: true,
//      floating: false,
//      delegate: CommonSliverPersistentHeaderDelegate(
//          Container(
//            child: primaryTabBar,
//            //color: Colors.white,
//          ),
//          primaryTabBar.preferredSize.height)));
  return widgets;
}
