import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:im_themed/im_themed.dart';

ThemeData initialTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
);

void main() async {
  runApp(
    const ImThemedApp(
      app: MainPage(),
    ),
  );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  late final textController = TextEditingController(
    text: encoder.convert(context.theme.toJson()),
  );

  @override
  Widget build(BuildContext context) {
    return ImThemedApp(
      initialTheme: initialTheme,
      app: Builder(
        builder: (context) {
          return MaterialApp(
            theme: context.theme,
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                title: Text(
                  'Live Theme Editor',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ) ??
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
              body: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                        ),
                        expands: true,
                        minLines: null,
                        maxLines: null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: updateAppTheme,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text('Apply Theme'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  void updateAppTheme() {
    try {
      final themeData = ThemeDataJsonConverterExtension.fromJson(
        jsonDecode(textController.text),
      );
      setState(() {
        initialTheme = themeData;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }
}
