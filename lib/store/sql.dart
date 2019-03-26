import 'package:sqflite/sqflite.dart';
import 'package:flutter_password/store/index.dart';
import 'dart:async';

const DBName = 'data.db';
const PsDataTBName = 'PsData'; // Data表名称
const PsItemsTBName = 'PsItems'; // Item表名称

class PsDataHelper {}

class PsItemHelper {}

class DBPassword {
  Database database;

  // 初始化数据库
  Future<bool> initDB() {
     return Io.localPath.then((path) async {
      String fullPath = '$path/$DBName';
      try {
        database = await openDatabase(fullPath, version: 1,
            onCreate: (Database db, int version) async {
          print('版本：$version');
          // 建表
          await db.execute('CREATE TABLE $PsDataTBName (id TEXT PRIMARY KEY,account TEXT)');
          await db.execute("""CREATE TABLE $PsItemsTBName (
          dataId TEXT,
          id TEXT PRIMARY KEY,
          title TEXT,
          account TEXT,
          password TEXT,
          status INTEGER,
          createDate TEXT,
          modifyDate TEXT
        )""");
        });
      } catch (e) {
        print(e);
      }
      print("sql初始化结束");
      return true;
    });
  }

  // 获取主表信息
  Future<Map<String, dynamic>> getTableData(String account) async {
    if (database != null) {
      List<Map<String, dynamic>> list = await database.query(PsDataTBName,
          columns: ['id', 'account'],
          where: 'account = ?',
          whereArgs: [account]);
      if (list.length > 0) {
        return list.first;
      }
    }
    return null;
  }

  // 获取密码表信息
  Future<List<Map<String, dynamic>>> getTableItems(String dataId) async {
    if (database != null) {
      List<Map<String, dynamic>> list = await database.query(PsItemsTBName,
          columns: [
            'id',
            'title',
            'account',
            'password',
            'status',
            'createDate',
            'modifyDate'
          ],
          where: '"dataId" = ?',
          whereArgs: [dataId]);
      if (list.length > 0) {
        return list;
      }
    }
    return null;
  }

  // 新增账户数据
  Future<int> insertData(Map<String, dynamic> data) async {
    if (database != null) {
      int id = await database.insert(PsDataTBName, data);
      return id;
    }
    return null;
  }

  // 新增密码表
  Future<int> insertItem(Map<String, dynamic> item) async {
    if (database != null) {
      int id = await database.insert(PsItemsTBName, item);
      return id;
    }
    return null;
  }

//  删除密码表
  Future<int> delete(String id) async {
    if (database != null) {
      return await database.delete(PsItemsTBName, where: 'id = ?', whereArgs: [id]);
    }
    return null;
  }
  
  // 更新
  Future<int> update({String id, Map<String, dynamic> map}) {
    return database.update(PsItemsTBName, map, where: 'id = ?',whereArgs: [id]);
  }
}
