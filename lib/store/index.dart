import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../model/psData.dart';

class Io {
  static String _localPath = '';
  static File _file;

  //获取本地路径
  static Future<String> get localPath {
    if (_localPath.isEmpty != false) {
      return Future<String>(() =>_localPath);
    } else {
      return getApplicationDocumentsDirectory().then((dir) {
        _localPath = dir.path;
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
        return _file;
      }).catchError((e) {
        return null;
      });
    }
  }

  // 读取数据
  static Future<String> readData () {
    return file.then((file) {
      return file.readAsString().then((data) {
        return data;
      }).catchError((e) {
        return e;
      });
    });
  }

  // 写入数据
  static Future<File> writeData(String jsonString) {
    return file.then((file) {
      return file.writeAsString(jsonString);
    }); 
  }
}

class GState extends Model {
  PsData _data;
  PsData get data => _data;

  void setData(PsData data){
    _data = data;
  }

  static GState of(BuildContext context){
    return ScopedModel.of<GState>(context);
  }
}
