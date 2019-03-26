import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import '../model/psData.dart';
import './sql.dart';

class Io {
  static String _localPath = '';
  static File _file;

  //获取本地路径
  static Future<String> get localPath {
    if (_localPath.isNotEmpty) {
      print('App文档路径:$_localPath');
      return Future<String>(() => _localPath);
    } else {
      return getApplicationDocumentsDirectory().then((dir) {
        _localPath = dir.path;
        print('App文档路径:$_localPath');
        return _localPath;
      });
    }
  }

  // 获取文件
  static Future<File> get file {
    if (_file != null) {
      return Future<File>(() => _file);
    } else {
      return localPath.then((path) {
        _file = File('$path/data.json');
        print('文件路径:$_file');
        return _file;
      }).catchError((e) {
        return null;
      });
    }
  }

  // 读取数据
  static Future<String> readData() {
    return file.then((file) {
      return file.readAsString().then((String data) {
        return data;
      }).catchError((e) {
        return e;
      });
    });
  }

  // 写入数据
  static Future<File> writeData(String jsonString) {
    return file.then((File file) {
      return file.writeAsString(jsonString);
    });
  }
}

class GState extends Model {
  PsData _data;

  PsData get data => _data;
  DBPassword _db;
  DBPassword get db => _db;

  GState() {
    _data = new PsData(id: '0', account: 'plusli', list: []);
    _db = DBPassword();
    loadData();
  }

  // 数据读取
  void loadData() {
    /*Io.readData().then((String jsonStr) {
      Map<String, dynamic> jsonMap = json.decode(jsonStr);
      PsData data = new PsData.fromJson(jsonMap);
      setData(data);
      print('文件读取成功:${_data.list.length}');
    }).catchError((error) {
      print('文件读取失败:$error');
    });*/

//    初始化db

    _db.initDB().then((b) async {
      if (b) {
        _db.getTableItems(_data.id).then((list) {
          if (list != null) {
            List<PsItem> items = [];
            list.forEach((map) {
              PsItem item = PsItem.fromJson(map);
              items.add(item);
            });
            PsData data = _data;
            data.list = items;
            setData(data);
          }
        });
      }
    });
  }

  void setData(PsData data) {
    _data = data;
    notifyListeners();
  }

  // 保存密码
  Future<File> savePsData() {
    Map<String, dynamic> mapData = _data.toJson();
    String jsonStr = json.encode(mapData);
    return Io.writeData(jsonStr);
  }

  // 新增密码
  Future<void> addPsItem(PsItem item) {
    // 增加至sql内的数据
    Map<String, dynamic> map = {
      'dataId': _data.id,
      'id': item.id,
      'title': item.title,
      'account': item.account,
      'password': item.password,
      'status': item.status,
      'createDate': item.createDate.toIso8601String(),
      'modifyDate': item.modifyDate.toIso8601String()
    };
    return _db.insertItem(map).then((id){
      print('数据库新增索引: $id');
      _data.list.add(item);
      notifyListeners();
    });
  }

  // 修改某个密码
  Future<void> modifyPsItem({int index, PsItem item}) {
    // 增加至sql内的数据
    Map<String, dynamic> map = {
      'title': item.title,
      'account': item.account,
      'password': item.password,
      'status': item.status,
      'createDate': item.createDate.toIso8601String(),
      'modifyDate': item.modifyDate.toIso8601String()
    };
    return _db.update(id: item.id, map: map).then((id) {
      print('数据库更新索引: $id');
      _data.list[index] = item;
    });
  }

  // 删除某个密码
  Future<void> delPsItem({int index}) {
    return _db.delete(_data.list[index].id).then((id) {
      print('数据库删除索引:$id');
      _data.list.removeAt(index);
      notifyListeners();
    });
  }

  // 改变状态
  void starItem({int index, int status}) {
    // 增加至sql内的数据
    Map<String, dynamic> map = {
      'status': status,
    };
    String id = _data.list[index].id;
    _db.update(id: id, map: map).then((id) {
      data.list[index].status = status;
      notifyListeners();
    });
  }

  static GState of(BuildContext context) {
    return ScopedModel.of<GState>(context);
  }
}
