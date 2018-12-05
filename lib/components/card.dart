import 'package:flutter/material.dart';
import '../model/psData.dart';
import '../utils/date_utils.dart';
import '../route/index.dart';
import 'package:fluro/fluro.dart';
import '../store/index.dart';

// 弹窗点击输出的两个状态，删除和编辑
enum DialogAction {
  del,
  editor,
}

class PsCard extends StatefulWidget {
  PsCard({
    Key key,
    @required this.item,
    this.onTap,
    this.onLongPress,
    this.onTapStar,
    @required this.index,
    this.duration,
  }) : super(key: key) {
//		print(item.status);
//		_colorAnimationController = new AnimationController(duration: Duration(milliseconds: 300), vsync: this);
  }

  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onTapStar; // 点击星星
  final PsItem item;
  final int index; // 索引
  final Duration duration;

  @override
  State<StatefulWidget> createState() => PsCardState();
}

class PsCardState extends State<PsCard> with TickerProviderStateMixin {
  // 定义一个动画控制器
  Animation<Color> _colorAnimation;
  Animation<Color> _borderColorAnimation;
  AnimationController _colorAnimationController;

  // AnimationController _opacityAnimationCtl; // 透明动画
  Animation<double> _opacityAnimation;

  Animation<double> _heightAnimation; //高度动画
  AnimationController _delAnimationCtl; // 删除动画的控制器


  //
//	PsItem item;

  int get status {
//		print('${widget.item.title}:${widget.item.status}');
    if (widget.item.status == 0) {
      _colorAnimationController?.reverse();
    } else {
      _colorAnimationController?.forward();
    }
    return widget.item.status;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    item = widget.item;
    initColorAnimation();
    initOpacityAnimation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _colorAnimationController.dispose();
    _delAnimationCtl.dispose();
    // _opacityAnimationCtl.dispose();
    super.dispose();
  }

  // 初始化动画
  void initColorAnimation() {
    print('初始化color动画:${widget.item.title}');
    _colorAnimationController = new AnimationController(
        duration: Duration(milliseconds: 300), vsync: this);
    _colorAnimation = new ColorTween(
      begin: Color(0xffdbdbdb),
      end: Colors.orange,
    ).animate(_colorAnimationController);
    _borderColorAnimation = new ColorTween(
      begin: Colors.blue,
      end: Colors.orange,
    ).animate(_colorAnimationController);
//		print(widget.item.status);
  }

  initOpacityAnimation() {
    print('初始化删除动画:${widget.item.title}');
    _delAnimationCtl = new AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _heightAnimation = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
      parent: _delAnimationCtl.view,
      curve: new Interval(
        0.5,
        1.0,
        curve: Curves.easeOut,
      ),
    ));

    _opacityAnimation = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
      parent: _delAnimationCtl.view,
      curve: new Interval(
        0.0,
        0.5,
        curve: Curves.linear,
      ),
    ));

    _heightAnimation.addStatusListener((statue) {
      if (statue == AnimationStatus.completed) {
        // todo 播放动画完成
        delItem(widget.index);
      }
    });

    // _opacityAnimationCtl = new AnimationController(
    //     duration: Duration(milliseconds: 500), vsync: this);
    // _opacityAnimation = new CurveTween(curve: Curves.easeIn).animate(_opacityAnimationCtl);
    // _opacityAnimation.addStatusListener((statue) {
    //   if (statue == AnimationStatus.completed) {
    //     // todo 播放动画完成
    //     delItem(widget.index);
    //   }
    // });
  }

  // 播放删除动画
  playDelAnimation() {
    // _opacityAnimationCtl.forward();
    _delAnimationCtl.forward();
  }

  // 删除当前card
  delItem(index) {
    GState model = GState.of(context);
    model.delPsItem(index: index);
    model.savePsData();
  }

  // 混淆密码
  obscurePassword(String password) {
    String frontStr = password.isNotEmpty ? password.substring(0, 2) : '';
    return '$frontStr********';
  }

//  弹窗
  void showModifyDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {}
    });
  }

  @override
  void didUpdateWidget(PsCard oldWidget) {
    // TODO: implement didUpdateWidget
      // print('更新card的自身状态:$testIndex');

    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) {
      // initOpacityAnimation();
      _delAnimationCtl.reset();
    }
    if (oldWidget.item.status != widget.item.status) {
      switch(widget.item.status){
        case 0:
        _colorAnimationController.reset();
        break;
        case 1:
        _colorAnimationController.forward(from: 1.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var st = status;
    // TODO: implement build
    print(_opacityAnimation.value);
    return _buildItem();
  }

  Widget _buildItem() => AnimatedBuilder(
        animation: _delAnimationCtl,
        builder: (BuildContext context, Widget child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          );
        },
        child: SizeTransition(
          sizeFactor: _heightAnimation,
          child: Card(
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
            child: AnimatedBuilder(
              animation: _colorAnimationController,
              builder: (BuildContext context, Widget child) {
                return Container(
                  // color: Colors.white,
                  // padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: _borderColorAnimation.value,
                        width: 5.0,
                      ),
                    ),
                  ),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: widget.onTap,
                      onLongPress: () {
                        showModifyDialog<DialogAction>(
                          context: context,
                          child: SimpleDialog(
                            children: <Widget>[
                              SimpleDialogOption(
                                onPressed: () {
                                  playDelAnimation();
                                  Navigator.pop(context, DialogAction.del);
                                },
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Icon(Icons.delete,
                                        size: 36.0, color: Colors.red),
                                    new Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: new Text('删除',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              ),
                              SimpleDialogOption(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Application.router.navigateTo(
                                      context, '/detail/${widget.index}',
                                      transition: TransitionType.inFromRight);
                                },
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Icon(Icons.edit,
                                        size: 36.0, color: Colors.blue),
                                    new Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: new Text(
                                        '编辑',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      // splashColor: Colors.blue,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 18.0, top: 10.0, bottom: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.item.title,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Color(0xff303030),
                                    ),
                                  ),
                                  Text(
                                    '${widget.item.account}(${obscurePassword(widget.item.password)})',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      height: 1.4,
                                      textBaseline: TextBaseline.alphabetic,
                                      color: Color(0xff999999),
                                    ),
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    toDateTimeStringZH(
                                        datetime: widget.item.modifyDate,
                                        formatString: 'yyyy年MM月dd日 hh:mm分'),
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      height: 1.2,
                                      color: Color(0xffb6b6b6),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: _colorAnimation.value,
                                ),
                                onPressed: () {
                                  widget.onTapStar();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
}
