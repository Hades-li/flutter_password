import 'package:flutter/material.dart';
import '../model/psData.dart';
import 'package:uuid/uuid.dart';
import '../store/index.dart';
import '../route/index.dart';
import '../utils/date_utils.dart';

class VerificationMsg {
	VerificationMsg({this.isSuccess = false, this.msg = ''});

	bool isSuccess;
	String msg;
}

class Detail extends StatefulWidget {
	Detail({Key key, this.title, this.index, this.isNew = false})
		 : super(key: key);

	final String title;
	final bool isNew; // 用于标记是否为新建
	final int index;

	@override
	DetailState createState() => new DetailState();
}

class DetailState extends State<Detail> {
	bool canShow = false;
	bool isEditor = false;
	Uuid uuid = new Uuid();
	PsItem item;
	GState state;

	TextEditingController _textController;
	VerificationMsg verPassword = new VerificationMsg(isSuccess: true, msg: '');
	TextEditingController _titleController;
	VerificationMsg verTitle = new VerificationMsg(isSuccess: true, msg: '');

	// 保存
	void save(BuildContext context) {
		item.modifyDate = new DateTime.now();
		if (widget.isNew) {
			item.createDate = item.modifyDate;
			// 新建
			state?.addPsItem(item);
//      print(state.data.list);
			state?.savePsData()?.then((file) {
				print('保存成功：${file.path}');
				Application.router.pop(context);
			})?.catchError((error) {
				print('保存失败：$error');
			});
		} else {
			// 编辑
			print(item.createDate.toString());
			state?.modifyPsItem(index: widget.index, item: item);
			state?.savePsData()?.then((file) {
				print('保存成功：${file.path}');
				Application.router.pop(context);
			})?.catchError((error) {
				print('保存失败：$error');
			});
		}
	}

	// 设置编辑模式
	void setEditor(BuildContext context) {
		if (isEditor == false) {
			setState(() {
				isEditor = true;
			});
		} else if(isEditor == true && verificationPassword(item.password) && verificationTitle(item.title)){
			isEditor = false;
			save(context);
		}
	}

	@override
	void initState() {
		// TODO: implement initState
		state = GState.of(context);
		print('详情页');

		isEditor = widget.isNew; // 初始化是否可编辑
		if (widget.isNew) {
			// 如果是新建，就创建一个新的临时变量
			DateTime dt = new DateTime.now();
			item = new PsItem(id: uuid.v1(), title: '', password: '',createDate: dt,modifyDate: dt);
		} else {
			// 如果是编辑，就通过copy创建也给临时变量
			int index = widget.index;
			String id = state.data.list[index].id;
			String title = state.data.list[index].title;
			String password = state.data.list[index].password;
			int status = state.data.list[index].status;
			DateTime createDate = state.data.list[index].createDate;
			DateTime modifyDate = state.data.list[index].modifyDate;
			item = new PsItem(id: id, title: title, password: password, status: status, createDate: createDate, modifyDate: modifyDate);
		}
		setController();
		super.initState();
	}

	// 密码输入框验证
	bool verificationPassword(String str) {
		if (str.isEmpty) {
			print(str.isEmpty);
			// 判断是否为空
			setState(() {
				verPassword?.isSuccess = false;
				verPassword?.msg = '不能为空';
			});
			return false;
		} else if (!str.contains(RegExp(r'^[0-9a-zA-Z]*$'))) {
			setState(() {
				verPassword?.isSuccess = false;
				verPassword?.msg = '仅能输入字母数字及特殊符号';
			});
			return false;
		}
		setState(() {
			verPassword?.isSuccess = true;
			verPassword?.msg = '';
		});
		return true;
	}

	// 标题输入框验证
	bool verificationTitle(String str) {
		if (str.isEmpty) {
			// 判断是否为空
			setState(() {
				verTitle?.isSuccess = false;
				verTitle?.msg = '不能为空';
			});
			return false;
		}
		setState(() {
			verTitle?.isSuccess = true;
			verTitle?.msg = '';
		});
		return true;
	}

	void setController() {
		_textController = new TextEditingController(text: item.password);
		_textController.addListener(() {
			item.password = _textController.text;
			verificationPassword(item.password);
		});
		_titleController = new TextEditingController(text: item.title);
		_titleController.addListener(() {
			item.title = _titleController.text;
			verificationTitle(item.title);
		});
	}

	@override
	void dispose() {
		// TODO: implement dispose
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		print('渲染');
//    state = GState.of(context);
		// TODO: implement build
		return Scaffold(
			appBar: AppBar(
				title: TextField(
					enabled: isEditor,
					controller: _titleController,
					textAlign: TextAlign.center,
					autocorrect: false,
					style: TextStyle(
						color: Colors.white,
						fontSize: 18.0,
					),
					decoration: InputDecoration(
						hintText: '请这里填写标题',
						hintStyle: TextStyle(color: Color(0xffa2bdd2), fontSize: 18.0),
						border: InputBorder.none,
						enabledBorder: isEditor
							 ? UnderlineInputBorder(
							 borderSide: BorderSide(
								 color: verTitle.isSuccess ? Colors.white30 : Colors.red,
//                    width: 1.0,
//                    style: BorderStyle.solid,
							 ))
							 : InputBorder.none,
						focusedBorder: UnderlineInputBorder(
							borderSide: BorderSide(
								color: verTitle.isSuccess ? Colors.white : Colors.red,
//              width: 1.0,
//              style: BorderStyle.solid,
							),
						),
						contentPadding: EdgeInsets.only(bottom: 5.0),
					),
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
			body: SafeArea(
				 child: Column(
					 crossAxisAlignment: CrossAxisAlignment.start,
					 children: <Widget>[
						 Container(
							 margin: EdgeInsets.only(left: 10.0,right: 10.0),
							 padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
							 constraints: BoxConstraints(
								 minWidth: double.infinity,
							 ),
							 decoration: BoxDecoration(
								  border: Border(
										 bottom: BorderSide(
											 color: Color(0xff8d989c),
										 )
								  )
							 ),
							 child: Text(
								 item.modifyDate != null ? toDateTimeStringZH(datetime: item.modifyDate, formatString: 'yyyy年MM月dd日 hh:mm分') : '',
								 style: TextStyle(
									 fontSize: 14.0,
									 height: 1.2,
									 color: Color(0xff8d989c),
								 ),
							 ),
						 ),
						 Expanded(
							 child: Center(
								 child: Column(
									 mainAxisAlignment: MainAxisAlignment.center,
									 children: <Widget>[
										 Padding(
											 padding: EdgeInsets.only(
												 bottom: 40.0,
											 ),
											 child: Row(
												 crossAxisAlignment: CrossAxisAlignment.start,
												 mainAxisAlignment: MainAxisAlignment.center,
												 children: <Widget>[
													 Padding(
														 padding:
														 EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
														 child: Icon(
															 Icons.edit,
															 color:
															 isEditor == true ? Colors.blue : Colors.transparent,
														 ),
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
																 errorText: verPassword.msg.isNotEmpty
																	  ? verPassword.msg
																	  : null,
																 hintStyle: TextStyle(color: Colors.cyan),
																 border: isEditor ? UnderlineInputBorder() : InputBorder
																	  .none,
																 /*errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          )
                        ),*/
																 /*enabledBorder: isEditor
                            ? UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black26,
                                ),
                              )
                            : InputBorder.none,*/
																 /*focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),*/
																 contentPadding: EdgeInsets.all(10.0),
															 ),
															 /*onChanged: (String val) {
                        item.password = val;
                      },*/
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
						 ),
						 Container(
							 padding: EdgeInsets.all(10.0),
							 constraints: BoxConstraints(
								 minWidth: double.infinity,
							 ),
							 child: Text(
								 '创建时间：${item.createDate != null ? toDateTimeStringZH(datetime: item.createDate, formatString: 'yyyy年MM月dd日 hh:mm分') : ''}',
								 textAlign: TextAlign.right,
								 style: TextStyle(
									 fontSize: 12.0,
									 height: 1.2,
									 color: Color(0xffb6b6b6),
								 ),
							 ),
						 )
					 ],
				 ),
			),
		);
	}
}
