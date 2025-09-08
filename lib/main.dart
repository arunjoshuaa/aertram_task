import 'package:aetram_task/widgets/bottomnavbar_widget.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp
({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
    //  home: ProfilePage(),
    home: BottomnavbarWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}