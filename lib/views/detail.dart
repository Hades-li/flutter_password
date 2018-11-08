import 'package:flutter/material.dart';

class Detail extends StatefulWidget {
  Detail({Key key, this.title}) : super(key: key);

  final String title;

  @override
  DetailState createState() => new DetailState();
}

class DetailState extends State<Detail> {
  bool canShow = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('密码标题'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                bottom: 50.0,
              ),
              child: Text(
                '密码*********',
                style: TextStyle(
                  fontSize: 16.0,
                ),
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
            )
          ],
        ),
      ),
    );
  }
}
