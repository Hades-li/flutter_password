import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
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
  void initState() {
    // TODO: implement initState
    print('首页进入');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // 获取全局数据
    // TODO: implement build
    _sliverAppBar() => ScopedModelDescendant<GState>(
      builder: (context, child, model) => SliverAppBar(
        expandedHeight: 160.0,
        pinned: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              Application.router.navigateTo(context, '/detail/?type=new',
                  transition: TransitionType.inFromRight);
            },
          ),
        ],
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
                          text: model.data.list.length.toString().padLeft(2, '0'),
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
      ),
    );

    // 密码列表item
    _psItem(int index,PsItem item) => GestureDetector(
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
                        item.title,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Color(0xff303030),
                        ),
                      ),
                      Text(
                        item.password,
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
    _psList() => new ScopedModelDescendant<GState>(
      builder: (context, child, model) => Container(
        color: Color(0xfff9f9f9),
        child: ListView.builder(
          padding: EdgeInsets.only(top:20.0,bottom: 20.0,),
          itemCount: model.data.list.length,
          itemBuilder: (BuildContext context, int index) {
            return _psItem(index, model.data.list[index]);
          },
        ),
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
