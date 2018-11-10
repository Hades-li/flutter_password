import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../views/detail.dart';
import '../views/index.dart';

class Application {
  static Router router;
}

class Routes {
  static String home = '/';
  static String detail = '/detail/:index';

  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new Home(title: '首页');
    });
    // 详情页调用
    router.define(detail, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String type = params['type']?.first;
      int index = int.tryParse(params['index']?.first);
      if (index == null) {
        index = -1;
        print(index);
      }
      return new Detail(title: '详情页',index: index, isNew: type == 'new');
    }));
    // 首页调用
    router.define(home, handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new Home(title: '首页');
    }));
  }
}
