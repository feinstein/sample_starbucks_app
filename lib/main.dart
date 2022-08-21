import 'package:flutter/material.dart';

import 'product/ui/product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        platform: TargetPlatform.iOS,
      ),
      routes: {
        ProductScreen.routeName: (context) => const ProductScreen(),
      },
      home: const ProductScreen(),
    );
  }
}
