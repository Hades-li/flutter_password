import 'package:flutter/material.dart';
import '../model/psData.dart';

class Detail extends StatefulWidget {
  Detail({Key key, this.title}) : super(key: key);

  final String title;

  @override
  DetailState createState() => new DetailState();
}

class DetailState extends State<Detail> {
  bool canShow = false;
  bool isEditor = false;
  PsItem data;
  TextEditingController _textController;

  // 设置编辑模式
  void setEditor() {
    setState(() {
      isEditor = !isEditor;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    data = new PsItem(id: '0',title: '第一个密码',password:'123456789');
    _textController = new TextEditingController(text: data.password);
    super.initState();
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
                    padding: EdgeInsets.only(top: 10.0,left:10.0,right:10.0),
                    child: Icon(Icons.edit,color: isEditor == true ? Colors.blue : Colors.transparent,),
                  ),
                  Container(
                    width: 200.0,
                    child: isEditor == true
                        ?
                      TextField(
                        controller: _textController,
                        obscureText: true,
                        style: TextStyle(
                          fontSize: 16.0,
                          height: 2,
                          color: Color(0xff333333),
                        ),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.cyan),
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                        : Text(
                      data.password,
                      style: TextStyle(
                        fontSize: 16.0,
                        height: 2,
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
