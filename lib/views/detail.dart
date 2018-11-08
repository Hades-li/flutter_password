import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  Detail({Key key, this.title}) : super(key: key);

  final String title;

  @override
  DetailState createState() => new DetailState();
}

class DetailState extends State<Detail> {
  bool canShow = false;
  bool isEditor = false;

  // 设置编辑模式
  void setEditor() {
    setState(() {
      isEditor = !isEditor;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('密码标题'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(isEditor == true ? Icons.done : Icons.edit),
            onPressed: () {
              setEditor();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                bottom: 50.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 0.0,left:10.0,right:10.0),
                    child: Icon(Icons.edit),
                  ),
                  Container(
                    width: 200.0,
                    child: isEditor == true
                        ?
                      TextField(
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xff333333),
                        ),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.cyan),
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                        : Text(
                      '密码*********',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xff333333),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                setState(() {
                  canShow = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  canShow = false;
                });
              },
              child: Icon(
                canShow == true ? Icons.visibility : Icons.visibility_off,
                color: canShow == true ? Colors.blue : Color(0xff999999),
                size: 70.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
