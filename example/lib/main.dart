import 'package:flutter/material.dart';

import 'package:im_themed/im_themed.dart';

void main() async {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            'im_themed',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: const SizedBox(),
      ),
    );
  }
}
