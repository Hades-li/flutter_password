import 'package:flutter/material.dart';
import '../model/psData.dart';
import 'package:uuid/uuid.dart';
import '../store/index.dart';
import '../route/index.dart';


class Detail extends StatefulWidget {
  Detail({Key key, this.title, this.isNew = false}) : super(key: key);

  final String title;
  final bool isNew; // 用于标记是否为新建

  @override
  DetailState createState() => new DetailState();
}

class DetailState extends State<Detail> {
  bool canShow = false;
  bool isEditor = false;
  Uuid uuid = new Uuid();
  PsItem data;
  GState state;

  TextEditingController _textController;
  TextEditingController _titleController;

  // 保存
  void save(BuildContext context) {
    if (widget.isNew) { // 新建
      state?.addPsItem(data);
      print(state.data.list);
      Application.router.pop(context);

      state?.savePsData()?.then((file) {
        print('保存成功：${file.path}');
      })?.catchError((error){
        print('保存失败：$error');
      });
    } else { // 编辑

    }
  }
  // 设置编辑模式
  void setEditor(BuildContext context) {
    setState(() {
      isEditor = !isEditor;
    });
    // 判断是否保存
    if(isEditor == false) {
      save(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print('详情页');
    isEditor = widget.isNew; // 初始化是否可编辑
    if (widget.isNew) {
      data = new PsItem(id: uuid.v1(),title: '',password: '');
    }
    else {
      data = new PsItem(id: '0',title: '第一个密码',password:'123456789');
    }
    _textController = new TextEditingController(text: data.password);
    _titleController = new TextEditingController(text: data.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    state = GState.of(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          enabled: isEditor,
          controller: _titleController,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          decoration: InputDecoration(
            hintText: '请这里填写标题',
            hintStyle: TextStyle(color: Color(0xffa2bdd2),fontSize: 18.0),
            border: InputBorder.none,
            enabledBorder: isEditor ? UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30,width: 1.0,style: BorderStyle.solid)) : InputBorder.none,
            focusedBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 1.0,style: BorderStyle.solid)),
            contentPadding: EdgeInsets.only(bottom: 5.0),
          ),
          onChanged: (String val) {
            data.title = val;
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(isEditor == true ? Icons.done : Icons.edit),
            onPressed: () {
              setEditor(context);
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
                    child: TextField(
                      enabled: isEditor,
                      controller: _textController,
                      obscureText: !canShow,
                      style: TextStyle(
                        fontSize: 16.0,
                        height: 1,
                        color: Color(0xff333333),
                      ),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.cyan),
                        border: isEditor ? UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue,width: 2.0,style: BorderStyle.solid)) : InputBorder.none,
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                      onChanged: (String val) {
                        data.password = val;
                      },
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
