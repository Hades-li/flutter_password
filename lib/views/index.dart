import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../route/index.dart';
import 'package:fluro/fluro.dart';
import '../model/psData.dart';
import '../store/index.dart';

enum DialogAction {
  del,
  editor,
}

class PopVal {
  static DialogAction dialogAction;
  static int index = 0;
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  String keyStr = '';

  int get starCount {
    PsData data = GState
        .of(context)
        .data;
    int count = 0;
    data.list.forEach((item) {
      if (item.status == 1) {
        count += 1;
      }
    });
    return count;
  }

  @override
  void initState() {
    // TODO: implement initState
    print('首页进入');
//    List<PsItem> _list;
    super.initState();
  }

//  查询判断
  bool filter(PsItem item) {
    if (item.title.contains(keyStr)) {
      return true;
    } else if (keyStr == null || keyStr.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // 输入框文字变更
  textChange(String val) {
    print(val);
    setState(() {
      keyStr = val;
    });
  }

  obscurePassword(String password) {
    String frontStr = password.substring(0, 2);
    return '$frontStr********';
  }

//  弹窗
  void showModifyDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 获取全局数据
    // TODO: implement build
    _sliverAppBar() =>
        ScopedModelDescendant<GState>(
          builder: (context, child, model) =>
              SliverAppBar(
                expandedHeight: 105.0,
                pinned: false,
                flexibleSpace: SafeArea(
                  child: FlexibleSpaceBar(
                    background: Container(
                      padding: EdgeInsets.fromLTRB(30.0, 5.0, 20.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '总数',
                            style:
                            TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: model.data.list.length
                                      .toString()
                                      .padLeft(2, '0'),
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
                              style: TextStyle(fontSize: 14.0),
                              children: [
                                TextSpan(text: '重要的'),
                                TextSpan(text: '$starCount个'),
                                TextSpan(text: '，普通的'),
                                TextSpan(
                                  text: '${model.data.list.length - starCount}个',
                                ),
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
    _psItem(int index, PsItem item) =>
        ScopedModelDescendant<GState>(
          builder: (context, child, model) =>
              GestureDetector(
                onTap: () {
                  Application.router.navigateTo(context, '/detail/$index',
                      transition: TransitionType.inFromRight);
                },
                onLongPress: () {
//                  print('长安');
                  showModifyDialog<DialogAction>(
                    context: context,
                    child: SimpleDialog(
                      children: <Widget>[
                        SimpleDialogOption(
                          onPressed: () {
                            model.delPsItem(index:index);
                            model.savePsData();
                            Navigator.pop(context, DialogAction.del);
                          },
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Icon(Icons.delete, size: 36.0, color: Colors.red),
                              new Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: new Text('删除', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            Application.router.navigateTo(context, '/detail/$index',
                                transition: TransitionType.inFromRight);
                          },
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Icon(Icons.edit, size: 36.0, color: Colors.blue),
                              new Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: new Text('编辑', style: TextStyle(color: Colors.blue),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: item.status == 0 ? Colors.blue : Colors.orange,
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
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xff303030),
                                  ),
                                ),
                                Text(
                                  obscurePassword(item.password),
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
                            child: IconButton(
                              icon: Icon(
                                Icons.star,
                                color: item.status == 0
                                    ? Color(0xffdbdbdb)
                                    : Colors.orange,
                              ),
                              onPressed: () {
                                model.starItem(
                                    index: index,
                                    status: item.status == 0 ? 1 : 0);
                                model.savePsData().then((_) {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        );

    // 密码列表
    _psList() =>
        new ScopedModelDescendant<GState>(
          builder: (context, child, model) =>
              Container(
                padding: EdgeInsets.only(top: 10.0),
                color: Color(0xfff9f9f9),
                child: ListView.builder(
//          padding: EdgeInsets.only(top:20.0,bottom: 20.0,),
                  itemCount: model.data.list.length,
                  itemBuilder: (BuildContext context, int index) {
                    PsItem item = model.data.list[index];
                    if (filter(item)) {
                      return _psItem(index, item);
                    } else {
                      return Offstage(
                        offstage: true,
                      );
                    }
                  },
                ),
              ),
        );

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: TextField(
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white30,
              ),
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            hintText: '输入查询关键字',
            hintStyle: TextStyle(
              color: Colors.cyan,
              fontSize: 16.0,
            ),
            contentPadding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          ),
          onChanged: textChange,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            iconSize: 35.0,
            onPressed: () {
              Application.router.navigateTo(
                context,
                '/detail/?type=new',
                transition: TransitionType.inFromRight,
              );
            },
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            _sliverAppBar(),
          ];
        },
        body: _psList(),
      ),
      /*bottomNavigationBar: BottomNavigationBar(
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
      ),*/
    );
  }
}
