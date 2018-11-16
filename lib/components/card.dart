import 'package:flutter/material.dart';
import '../model/psData.dart';

class PsCard extends StatefulWidget {
	PsCard({
		Key key,
		@required this.item,
		this.onTap,
		this.onLongPress,
		this.onTapStar,
	}): super(key:key) {
//		print(item.status);
//		_colorAnimationController = new AnimationController(duration: Duration(milliseconds: 300), vsync: this);
	}

	final VoidCallback onTap;
	final VoidCallback onLongPress;
	final VoidCallback onTapStar;// 点击星星
	final PsItem item;

	@override
  State<StatefulWidget> createState() => PsCardState();
}

class PsCardState extends State<PsCard> with SingleTickerProviderStateMixin {
	// 定义一个动画控制器
	Animation<Color> _colorAnimation;
	Animation<Color> _borderColorAnimation;
	AnimationController _colorAnimationController;
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
    initAnimation();
	}

	@override
  void dispose() {
    // TODO: implement dispose
		_colorAnimationController.dispose();
    super.dispose();
  }
  // 初始化动画
  void initAnimation() {
	  _colorAnimationController = new AnimationController(
		   duration: Duration(milliseconds: 300), vsync: this);
	  _colorAnimation = new ColorTween(begin: Color(0xffdbdbdb), end: Colors.orange,).animate(_colorAnimationController);
	  _borderColorAnimation = new ColorTween(begin: Colors.blue, end: Colors.orange,).animate(_colorAnimationController);
		print(widget.item.status);
  }

  // 混淆密码
	obscurePassword(String password) {
		String frontStr = password.isNotEmpty ? password.substring(0, 2) : '';
		return '$frontStr********';
	}

  @override
  Widget build(BuildContext context) {
		var st = status;
    // TODO: implement build
    return AnimatedBuilder(
	    animation: _colorAnimationController,
	    builder: (BuildContext context, Widget child){
	    	return _buildItem();
	    },
    );
  }

  Widget _buildItem() => GestureDetector(
	  onTap: widget.onTap,
	  onLongPress: widget.onLongPress,
	  child: Card(
		  clipBehavior: Clip.hardEdge,
		  margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
		  child: Container(
			  padding: EdgeInsets.all(10.0),
			  decoration: BoxDecoration(
				  border: Border(
					  left: BorderSide(
						  color: _borderColorAnimation.value,
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
										  widget.item.title,
										  softWrap: true,
										  overflow: TextOverflow.ellipsis,
										  style: TextStyle(
											  fontSize: 16.0,
											  color: Color(0xff303030),
										  ),
									  ),
									  Text(
										  obscurePassword(widget.item.password),
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
									  color: _colorAnimation.value,
								  ),
								  onPressed: () {
//								  	_colorAnimationController.forward();
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
}