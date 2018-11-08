import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluro/fluro.dart';
import 'package:scoped_model/scoped_model.dart';
import './route/index.dart';
import './store/index.dart';

void main() {
    runApp(MyApp());
    if (Platform.isAndroid) {
        // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
        SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
}

class MyApp extends StatelessWidget {
    final GModel gModel = new GModel();

    Router createRouter() {
        Application.router = new Router();
        Routes.configureRoutes(Application.router);
        return Application.router;
    }
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        return new ScopedModel(
            model: gModel,
            child: new MaterialApp(
                title: '密码簿',
                theme: new ThemeData(
                    // This is the theme of your application.
                    //
                    // Try running your application with "flutter run". You'll see the
                    // application has a blue toolbar. Then, without quitting the app, try
                    // changing the primarySwatch below to Colors.green and then invoke
                    // "hot reload" (press "r" in the console where you ran "flutter run",
                    // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
                    // counter didn't reset back to zero; the application is not restarted.
                    primaryColorBrightness: Brightness.dark
                ),
                initialRoute: '/',
                onGenerateRoute: createRouter().generator,
//            home: new MyHomePage(title: '首页'),
            )
        );
    }
}
