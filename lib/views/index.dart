import 'package:flutter/material.dart';
import '../route/index.dart';
import 'package:fluro/fluro.dart';
import '../model/psData.dart';
import '../store/index.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    // 获取全局数据
    PsData data = GState.of(context).data;

    // TODO: implement build
    _sliverAppBar() => SliverAppBar(
          expandedHeight: 160.0,
          pinned: true,
          title: Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 18.0,
              right: 18.0,
            ),
//            height: 30.0,
            decoration: BoxDecoration(
//          color: Colors.blue,
              borderRadius: BorderRadius.circular(18.0),
              border: Border.all(
                color: Colors.white,
                width: 0.5,
                style: BorderStyle.solid,
              ),
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Searching',
                hintStyle: TextStyle(color: Colors.cyan),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          flexibleSpace: SafeArea(
            child: FlexibleSpaceBar(
              background: Container(
                padding: EdgeInsets.fromLTRB(30.0, 65.0, 20.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '总数',
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'XX',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32.0,
                            ),
                          ),
                          TextSpan(
                            text: '    个',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 16.0),
                        children: [
                          TextSpan(text: '重要的'),
                          TextSpan(text: 'XX个'),
                          TextSpan(text: '，普通的'),
                          TextSpan(text: 'XX个'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

    // 密码列表item
    _psItem(int index) => GestureDetector(
      onTap: () {
        Application.router.navigateTo(context, '/detail/$index',
           transition: TransitionType.inFromRight);
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.blue,
                width: 5.0,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '密码标题',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Color(0xff303030),
                        ),
                      ),
                      Text(
                        '密码的具体内容，不过会用在开头或者结尾加***星号的方式给隔离',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xffb6b6b6),
                        ),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.star,
                    color: Color(0xffdbdbdb),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );


    // 密码列表
    _psList() => Container(
          color: Color(0xfff9f9f9),
          child: ListView.builder(
            padding: EdgeInsets.only(top:20.0,bottom: 20.0,),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return _psItem(index);
            },
          ),
        );

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            _sliverAppBar(),
          ];
        },
        body: _psList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              size: 36.0,
            ),
            title: Text('新增'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 36.0,
            ),
            title: Text('我的'),
          ),
        ],
      ),
    );
  }
}
