import 'package:flutter/material.dart';
import 'my_widgets.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyStatefulWidget(),
    );
  }
}

/*
A.Giới thiệu Widget:
Widgets tà các thành phần cơ bản để xây dựng giao diện người dùng trong Flutter.
Mọi thứ trong Flutter đều là nột widget, từ cac nut ban, van ban đến các bố cục phức
tạp hơn.
widgets có thể lồng nhau để tạo ra giao điện người dùng phong phú và đa đạng.

B.Phån Loại Widgets:
+ Platform-specific widgets
Materiel Widgets: Thiết kế theo Material Design cua Google
import 'package: flutter/material.dart';

Cupertino Widgets: Thiết kế theo Human Interface Guidelines cua Apple
import 'package:flutter/cupertino.dart';

+ Layout widgets: Container, Center, Row, Column, Stack ...

+ State maintenance widgets: StatelessWidget / StatefulWidget

+ Platform-independent/basic widgets: Text, Icon, Image, ElevatedButton, ListView

...
C. Statelesswidget / Statefuwwidget
+ StatelessWidget: Statelesswidget là các widget tình không thể thay đổi nội dung hiến thị sau khi
đugc render. Dầy là các widget đơn giản với cấu trúc rõ ràng, dễ sử dụng.
Mot StatelessWidget yeu cầu mot hàm build(BuildContext context) dể render du
Liệu Lên man hình.

+ StatefulWidget là các widget động có thể thay đổi nội dung hiển thị bằng cách thay
đổi trạng thái của chính nó. StatefulWidget can một ham createState() de cung cap
trang thải (State) cho nó.
*/
