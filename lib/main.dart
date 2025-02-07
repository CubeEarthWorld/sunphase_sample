import 'package:flutter/material.dart';
import 'home_screen.dart';

// Application entry point / アプリケーションのエントリーポイント
void main() {
  runApp(MyApp());
}

/// MyApp demonstrates the usage of the sunphase package.
/// このアプリは、sunphase パッケージの基本的な利用例を示すデモアプリです。
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunphase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // UI は別ファイルの HomeScreen で実装
    );
  }
}
